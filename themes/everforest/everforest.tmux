# Copyright (c) 2016-present Sven Greb <development@svengreb.de>
# This source code is licensed under the MIT license found in the license file.

EVERFOREST_TMUX_COLOR_THEME_FILE=src/everforest.conf
EVERFOREST_TMUX_VERSION=0.3.0
EVERFOREST_TMUX_STATUS_CONTENT_FILE="src/everforest-status-content.conf"
EVERFOREST_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE="src/everforest-status-content-no-patched-font.conf"
EVERFOREST_TMUX_STATUS_CONTENT_OPTION="@everforest_tmux_show_status_content"
EVERFOREST_TMUX_STATUS_CONTENT_DATE_FORMAT="@everforest_tmux_date_format"
EVERFOREST_TMUX_NO_PATCHED_FONT_OPTION="@everforest_tmux_no_patched_font"
_current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

__cleanup() {
  unset -v EVERFOREST_TMUX_COLOR_THEME_FILE EVERFOREST_TMUX_VERSION
  unset -v EVERFOREST_TMUX_STATUS_CONTENT_FILE EVERFOREST_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE
  unset -v EVERFOREST_TMUX_STATUS_CONTENT_OPTION EVERFOREST_TMUX_NO_PATCHED_FONT_OPTION
  unset -v EVERFOREST_TMUX_STATUS_CONTENT_DATE_FORMAT
  unset -v _current_dir
  unset -f __load __cleanup
  tmux set-environment -gu EVERFOREST_TMUX_STATUS_TIME_FORMAT
  tmux set-environment -gu EVERFOREST_TMUX_STATUS_DATE_FORMAT
}

__load() {
  tmux source-file "$_current_dir/$EVERFOREST_TMUX_COLOR_THEME_FILE"

  local status_content=$(tmux show-option -gqv "$EVERFOREST_TMUX_STATUS_CONTENT_OPTION")
  local no_patched_font=$(tmux show-option -gqv "$EVERFOREST_TMUX_NO_PATCHED_FONT_OPTION")
  local date_format=$(tmux show-option -gqv "$EVERFOREST_TMUX_STATUS_CONTENT_DATE_FORMAT")

  if [ "$(tmux show-option -gqv "clock-mode-style")" == '12' ]; then
    tmux set-environment -g EVERFOREST_TMUX_STATUS_TIME_FORMAT "%I:%M %p"
  else
    tmux set-environment -g EVERFOREST_TMUX_STATUS_TIME_FORMAT "%H:%M"
  fi

  if [ -z "$date_format" ]; then
    tmux set-environment -g EVERFOREST_TMUX_STATUS_DATE_FORMAT "%Y-%m-%d"
  else
    tmux set-environment -g EVERFOREST_TMUX_STATUS_DATE_FORMAT "$date_format"
  fi

  if [ "$status_content" != "0" ]; then
    if [ "$no_patched_font" != "1" ]; then
      tmux source-file "$_current_dir/$EVERFOREST_TMUX_STATUS_CONTENT_FILE"
    else
      tmux source-file "$_current_dir/$EVERFOREST_TMUX_STATUS_CONTENT_NO_PATCHED_FONT_FILE"
    fi
  fi
}

__load
__cleanup
