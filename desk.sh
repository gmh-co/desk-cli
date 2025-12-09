#!/bin/bash

ACTION=$1

# height check values
MAX_HEIGHT=115
MIN_HEIGHT=75

# colours
NOCOLOUR='\033[0m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'

warning() {
    echo -e "${RED}$1${NOCOLOUR}"
}

hint() {
    echo -e "${ORANGE}$1${NOCOLOUR}"
}

success() {
    echo -e "${GREEN}$1${NOCOLOUR}"
}

desk_move() {
    DESK_ACTION=$1
    hint "Moving desk to ${DESK_ACTION} position..."
    idasen $DESK_ACTION
    if [ $? -ne 0 ]; then
        warning "Failed to move desk to ${DESK_ACTION} position."
        exit 1
    fi
    success "Desk moved to ${DESK_ACTION} position successfully."
}

height_check() {
    HEIGHT=$(idasen height)
    HEIGHT=${HEIGHT%% *}
    HEIGHT=$(printf "%.0f" "$(echo "$HEIGHT * 100" | bc -l)")
    if [ -z $HEIGHT ]; then
        warning "ERROR!"
        hint "Height not detected"
        exit
    elif (($HEIGHT > $MAX_HEIGHT)); then
        warning "ERROR!"
        hint "Height ${HEIGHT}cm is too high"
        exit
    elif (($HEIGHT < $MIN_HEIGHT)); then
        warning "ERROR!"
        hint "Height ${HEIGHT}cm is too low"
        exit
    else
        success "Height ${HEIGHT}cm is within the acceptable range"
    fi
}

case "$ACTION" in
    sit|down)
        ACTION_NAME="sit"
        ;;
    stand|up)
        ACTION_NAME="stand"
        ;;
    check)
        height_check
        ;;
    *)
        warning "Missing or invalid action"
        hint "Available actions:"
        echo "desk sit"
        echo "desk stand"
        echo "desk check"
        exit 1
        ;;
esac

if [ ${#ACTION_NAME} -gt 2 ]; then
    desk_move "$ACTION_NAME"
fi
