This repo contains config files (for Nvim, Tmux, Zsh, SSH, Git, Yabai, Skhd, SketchyBar, and Ghostty), which with the exception of Yabai, Skhd, and Sketchybar, have package dependencies installable via the Nix flake in the [dotfile-deps](https://www.github.com/kevwjin/dotfile-deps) repo. Chezmoi has conditional logic that applies configurations depending on the system, allowing the config to support MacOS Sequoia and Ubuntu (Oracular Oriole) operating systems.

Chezmoi (pronounced /ʃeɪ mwa/ (shay-mwa)) is used for dotfile management. Chezmoi allows declarative configuration of file attributes through file name prefixes. When applying the config on `chezmoi apply`, for instance, the `dot_<filename>` prefix is replaced with a leading `.` for the filename, and the `private_<filename>` prefix sets the 600 permission for the file. Chezmoi also has age encryption integration, where `chezmoi add --encrypt <filename>` automatically encrypts and manages the file.

These dotfiles also include a `zoom-fullscreen` indicator powered by Sketchybar and Yabai. When any window in the current workspace is in `zoom-fullscreen` mode (not to be confused with native MacOS fullscreen), an indicator appears at the top left.

Another feature is event-based syncing with remote repositories. When opening a Zsh login shell, the zprofile config executes the following sync operations.
1. `update_chezmoi` syncs dotfiles by pulling and applying changes from this repo.
2. `update_nix` syncs dependencies by pulling and applying changes from the [dotfile-deps](https://www.github.com/kevwjin/dotfile-deps) repo.
Consequently, the user profile environment is consistent across my personal MacOS laptop and Ubuntu server.
