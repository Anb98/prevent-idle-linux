#!/bin/bash

# Initial configuration
SPEED=1000         # Movement speed in milliseconds
STEPS=10           # Number of steps between movements
SLEEP_ADJUST=0.001 # Synchronization adjustment

# Get screen resolution
RESOLUTION=$(xdpyinfo | grep dimensions | cut -d' ' -f7)
WIDTH=$(echo "$RESOLUTION" | cut -dx -f1)
HEIGHT=$(echo "$RESOLUTION" | cut -dx -f2)

# Startup message
echo "Moving the mouse randomly across the entire screen."
echo "Press Ctrl+C to stop."

# Main loop with interrupt control
trap 'echo "Stopping mouse movement..."; exit 0' INT

while true; do
    # Generate a new random position avoiding the title bar (e.g., the first 150px)
    TITLE_BAR=150
    x=$(($RANDOM % $WIDTH))
    y=$((TITLE_BAR + ($RANDOM % ($HEIGHT - TITLE_BAR))))

    # Gradually move the cursor to the new position
    for ((i=0; i<STEPS; i++)); do
        # Calculate intermediate position
        x_int=$(echo "scale=0; $x * ($i + 1) / $STEPS" | bc)
        y_int=$(echo "scale=0; $y * ($i + 1) / $STEPS" | bc)

        # Move the cursor
        xdotool mousemove $x_int $y_int

        # Wait a proportional time
        sleep $(bc -l <<< "scale=3; $SLEEP_ADJUST / $STEPS")
    done

    # Every certain number of cycles, randomly scroll up or down
    ((CYCLES++))
    SCROLL_INTERVAL=10  # Change this value to adjust how many cycles between scrolls
    if (( CYCLES % SCROLL_INTERVAL == 0 )); then
        SCROLL_CHANCE=$((RANDOM % 2))
        if [ $SCROLL_CHANCE -eq 0 ]; then
            # Scroll down
            xdotool click 5
            echo "Scroll down"
        else
            # Scroll up
            xdotool click 4
            echo "Scroll up"
        fi
    fi
done