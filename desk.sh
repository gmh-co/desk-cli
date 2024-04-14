#!/bin/bash

ACTION=$1
HEIGHT=$2

# preset heights
SIT="80cm"
STAND="110cm"

# height check values
MAX_HEIGHT=115
MIN_HEIGHT=75

# colours
NOCOLOUR='\033[0m'
RED='\033[0;31m'
ORANGE='\033[0;33m'

warning() {
    echo -e "${RED}$1${NOCOLOUR}"
}

hint() {
    echo -e "${ORANGE}$1${NOCOLOUR}"
}

desk_move() {
    hint "Moving Desk to $ACTION_NAME: $1"
    osascript <<EOD
    tell application "Desk Controller"
        move to "$1"
    end tell
EOD
}

restart() {
    hint "Restarting Desk Controller"
    PID=$(pgrep -f "/Applications/Desk Controller.app/Contents/MacOS/Desk Controller")
    if [ -n "$PID" ]; then
        kill -9 "$PID"
    fi
    open -a "Desk Controller"
}

height_check() {
    if [ -z $HEIGHT ]; then
        warning "ERROR!"
        echo "Height not supplied"
        exit
    elif (($HEIGHT > $MAX_HEIGHT)); then
        warning "ERROR!"
        echo "Height $HEIGHT is too high"
        exit
    elif (($HEIGHT < $MIN_HEIGHT)); then
        warning "ERROR!"
        echo "Height $HEIGHT is too low"
        exit
    fi
}

case "$ACTION" in
    sit|down)
        VALUE=$SIT
        ACTION_NAME="sit"
        ;;
    stand|up)
        VALUE=$STAND
        ACTION_NAME="stand"
        ;;
    height)
        height_check "$HEIGHT"
        VALUE="${HEIGHT}cm"
        ACTION_NAME="height"
        ;;
    restart)
        restart
        exit
        ;;
    *)
        warning "Missing or invalid action"
        hint "Available actions:"
        echo "desk sit"
        echo "desk stand"
        echo "desk height <NUMBER>"
        echo "desk restart"
        exit 1
        ;;
esac

desk_move "$VALUE"
