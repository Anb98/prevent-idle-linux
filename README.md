# prevent-idle-linux

Prevents your Linux session from going idle by randomly moving the mouse across the screen. Includes a Bash script (`mouse.sh`) and a Node.js API to control its execution. The API can also open and close a Chromium browser window with a custom URL.

## Requirements

- **Operating System:** Linux
- **Display Server:** X11 (does not work properly under Wayland)
- **Required tools for the script:**
  - `xautomation`
  - `xdotool`
- **Required for API browser control:**
  - `chromium-browser` (must be installed and available in PATH)

## Installing script dependencies

Install the required tools by running:

```bash
sudo apt-get install xautomation xdotool
```

## Using the `mouse.sh` script

This script randomly moves the mouse across the screen to prevent the system from going to sleep.

### Manual execution

```bash
chmod +x mouse.sh
./mouse.sh
```

Press `Ctrl+C` to stop the script.

## Node.js API

The project includes a small API to start or stop the script via an HTTP request.

### Installing Node.js dependencies

```bash
yarn install
# or
npm install
```

### Running in development mode

```bash
yarn dev
# or
npm run dev
```

The API will be available at `http://localhost:3111` (port configurable via the `PORT` environment variable).

### Environment variables

- `PORT`: (optional) Port for the API server (default: 3111)
- `BROWSER_URL`: (optional) If set, the API will open this URL in Chromium-browser when starting the script, and close the browser when stopping the script.

### Endpoints

- `POST /api/toggle`: Starts or stops the execution of `mouse.sh`.
  - If the script is stopped, it will start and, if `BROWSER_URL` is set, open Chromium-browser with that URL.
  - If the script is running, it will stop and close Chromium-browser if it was opened by the API.

## Project structure

- `mouse.sh`: Bash script to move the mouse.
- `src/index.ts`: Express server to control the script and Chromium-browser via API.
- `package.json`, `tsconfig.json`: Node.js and TypeScript configuration.

## License

MIT
