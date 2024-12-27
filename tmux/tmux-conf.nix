{}:

''
set -g default-terminal 'screen-256color'
set-option -gw xterm-keys on
set -as terminal-overrides ',xterm*:Tc:sitm=\E[3m'

# Nvim performance options
set-option -sg escape-time 10
set-option -g focus-events on

# --- colors (solarized dark)
# default statusbar colors
set -g status-style bg=black,fg=yellow,default

# default window title colors
setw -g window-status-style fg=brightblue,bg=default

# active window title colors
setw -g window-status-current-style fg=yellow,bg=default,dim

# pane border
set -g pane-border-style fg=black,bg=default
set -g pane-active-border-style fg=yellow,bg=default

# command line/message text
set -g message-style bg=black,fg=yellow

# pane number display
set -g display-panes-active-colour yellow
set -g display-panes-colour brightblue

# clock
setw -g clock-mode-colour yellow
# --- end colors

# disable mouse
set -g mouse off

# scrollback buffer n lines
set -g history-limit 100000

# Ctrl-t split horizontally
# Ctrl-l split vertically
# Ctrl-n new window
bind-key -n C-t split-window -v
bind-key -n C-l split-window -h
bind-key -n C-n new-window

# Meta-Up/Down cyles through panes
bind-key -n M-Up   select-pane -t :.-
bind-key -n M-Down select-pane -t :.+
# Meta-p pastes yanked text
bind-key -n M-p paste-buffer

# Shift-Left/Right cycles through windows
bind-key -n S-Left  select-window -t :-
bind-key -n S-Right select-window -t :+

# In copy mode, use Vim bindings
setw -g mode-keys vi

# Unbind default rectangle-toggle
unbind-key -T copy-mode-vi 'v'
bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle
bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel
''
