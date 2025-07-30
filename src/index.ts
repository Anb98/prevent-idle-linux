import express, { Request, Response } from "express";
import { spawn, ChildProcessWithoutNullStreams } from "child_process";
import path from "path";

const app = express();
const PORT = process.env.PORT || 3111;

let runningProcess: ChildProcessWithoutNullStreams | null = null;
let browserProcess: ChildProcessWithoutNullStreams | null = null;

app.post("/api/toggle", async (req: Request, res: Response) => {
  const urlToOpen = process.env.BROWSER_URL;
  if (!runningProcess) {
    // Open Chromium browser (Linux only)
    if (urlToOpen) {
      browserProcess = spawn("chromium-browser", [urlToOpen]);
      browserProcess.on("exit", () => {
        browserProcess = null;
      });
    }
    // Start the script
    const scriptPath = path.resolve(__dirname, "../mouse.sh");
    runningProcess = spawn("bash", [scriptPath]);
    runningProcess.stdout.on("data", (data) => {
      console.log(`stdout: ${data}`);
    });
    runningProcess.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });
    runningProcess.on("exit", () => {
      runningProcess = null;
    });
    return res.json({ status: "started" });
  } else {
    // Stop the script
    runningProcess.kill("SIGTERM");
    runningProcess = null;
    // Close Chromium if open
    if (browserProcess) {
      browserProcess.kill("SIGTERM");
      browserProcess = null;
    }
    return res.json({ status: "stopped" });
  }
});

app.listen(PORT, () => {
  console.log(`API listening at http://localhost:${PORT}`);
});
