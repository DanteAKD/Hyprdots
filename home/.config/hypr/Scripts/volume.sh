#!/usr/bin/env bash

# You can call this script like this:
# $ ./volume.sh up
# $ ./volume.sh down
# $ ./volume.sh mute

function get_volume {
    # Get the volume of the default audio sink
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP '(\d+(\.\d+)?)' | awk '{print int($1 * 100)}'
}

function is_mute {
    # Check if the default sink is muted
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '[MUTED]'
}

function send_notification {
    DIR=$(dirname "$0")
    volume=$(get_volume)

    # Create a visual bar for volume
    bar=$(seq -s "─" $((volume / 5)) | sed 's/[0-9]//g')

    # Send the notification
    $DIR/notify-send.sh "Volume $volume%" -i " " -t 2000 -h "int:value:$volume" -h "string:synchronous:$bar" --replace=555
}

case $1 in
    up)
        # Unmute and increase volume by 2%
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02+ > /dev/null
        send_notification
        ;;
    down)
        # Unmute and decrease volume by 2%
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.02- > /dev/null
        send_notification
        ;;
    mute)
        # Toggle mute
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null
        if is_mute; then
            DIR=$(dirname "$0")
            $DIR/notify-send.sh -i "" --replace=555 -u normal "Mute" -t 2000
        else
            send_notification
        fi
        ;;
esac
