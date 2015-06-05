#!/bin/bash
SESSION="infoactive"
DIR="~/infoactive"


create_session() {
  tmux -2 new-session -d -s "$SESSION"
  # Editor Window
  tmux send-keys "cd " $DIR C-m
  tmux send-keys "vi" C-m
  tmux split-window -v
  tmux resize-pane -D 15
  tmux send-keys "cd "  $DIR C-m
  tmux send-keys "ulimit -n 300" C-m
  tmux send-keys "karma start" C-m
  tmux split-window -h
  tmux send-keys "cd " $DIR C-m
  tmux send-keys "git fetch && git status" C-m
  # Server stuff window
  tmux new-window -t $SESSION:2 -n 'Server Processes'
  tmux split-window -h
  tmux split-window -h
  tmux select-layout even-horizontal
  tmux select-pane -t 1
  tmux send-keys "cd " $DIR  C-m
  tmux send-keys "foreman run rails s" C-m 
  tmux select-pane -t 2
  tmux send-keys "cd " $DIR  C-m
  tmux send-keys "rake jobs:work" C-m
  tmux select-pane -t 3
  tmux send-keys "cd " $DIR  C-m
  tmux send-keys "guard" C-m
  tmux select-pane -t 1

  tmux select-window -t $SESSION:1
  tmux select-pane -t 1
}

session_exists() {
  tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$SESSION$"
}

attach_to_session() {
  tmux -2 attach-session -t $SESSION
}

create_if_needed_and_attach() {
  if ! session_exists; then
    create_session
  fi
  attach_to_session
}

create_if_needed_and_attach
