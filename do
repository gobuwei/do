#!/bin/sh

PROGNAME=$(basename $0)

# help message for 'hi' command
help_hi="Say Hi to someone
hi <name>
"
# 'hi' command
cmd_hi() {
    echo "Hi, $1!"
}

#####################################################################

__help__="\
usage:      $PROGNAME COMMAND [ ARGS ]
            $PROGNAME help [ COMMAND ]

Available COMMANDs:
  -h|--help Show this help
  help      Show this help or the help of COMMAND
"
cmd_help() {
    if [ -z "$1" ]; then
        # help for all commands
        printf "$__help__"
        helps=${!help_*}
        for h in $helps; do
            cmd=${h/help_/}
            help_cmd=${!h}
            printf "  %-10s" $cmd
            printf "$help_cmd\n" | head -1
        done
    elif [ "$(type -t "cmd_$1")" = "function" ]; then
        # help for a command
        eval "help_cmd=\$help_$1"
        if [ -n "$help_cmd" ]; then
            printf "$help_cmd\n" | head -1
            echo ""
            printf "$help_cmd\n" | sed 1d | sed -e 's/^/    /g'
        fi
    fi
}

# main
case "$1" in
    ''|-h|--help) cmd_help;;
    *)  cmd="$1"
        if [ "$(type -t "cmd_$cmd")" = "function" ]; then
            shift
            cmd_$cmd "$@"
        else
            echo "error: unknown command '$cmd'"
            cmd_help
        fi
        ;;
esac
