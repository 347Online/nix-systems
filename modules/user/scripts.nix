{ pkgs, flakeDir, ... }:
{
  home.packages = [
    (
      let
        eds = "eds";
      in
      pkgs.writeShellScriptBin eds ''
        usage () {
          echo "Usage: ${eds} [OPTIONS] [FILES...]
          [OPTIONS]
            -s <session>  name of new tmux session
            -h            show this help message

          [FILES...]
            File/Directory paths passed to editor
          "
        }

          session="main"

          while getopts ":s:h" opt; do
            case $opt in
              s)
                session=$OPTARG
                ;;
              h)
                usage
                exit 0
                ;;
              \?)
                echo "Bad option: -$OPTARG" >&2
                exit 1
                ;;
              :)
                echo "Option -$OPTARG requires value" >&2
                exit 1
                ;;
            esac
          done
          shift $((OPTIND - 1))

          if tmux has-session -t "$session" 2>/dev/null; then
            echo "Session" "$session" "already exists, attaching to it"
          else
            tmux new-session -d -s "$session"
            tmux rename-window -t 1 "editor"
            tmux new-window
            tmux rename-window -t 2 "scratch"
            tmux split-window -t "scratch" -v
            if ! [[ $PWD == "${flakeDir}"* ]]; then
              tmux new-window
              tmux rename-window -t 3 "nix"
              tmux send-keys -t "nix" 'cd "${flakeDir}"' C-m 'clear' C-m
            fi
            tmux select-window -t "editor"
            tmux send-keys -t "editor" "nvim $@" C-m
          fi

          tmux attach-session -t "$session"
      ''
    )
  ];
}
