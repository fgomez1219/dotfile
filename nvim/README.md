## Prerequisites ##
- [True Color Terminal](https://gist.github.com/kurahaupo/6ce0eaefe5e730841f03cb82b061daa2#now-supporting-true-color) - Make Neovim look pretty
- [Neovim](https://neovim.io/) - Version 0.9.1 or later
- [Nerd Font](https://www.nerdfonts.com/) - Needed to see nice icons in Neovim
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Needed for Telescope Fuzzy Finder
- [xclip](https://linuxconfig.org/how-to-use-xclip-on-linux) - Needed for system clipboard support
- [npm/node](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [Python](https://www.python.org/) - Version 3.8 or later

# Nerd Font installation
- Download 
- Extract.
- Put the extracted folder into /usr/.local/share/fonts if you want them to be installed only to your user, or /usr/share/fonts if you want them installed globally.
- Rebuild font cache by running `fc-cache -f -v`

Then to add the font to alacritty:

For yaml configuration:
```
font:
  size: <repace_with_your_size>
  normal:
    family: <name_of_the_font>
```

For toml configuration:
```
[font]
size = <repace_with_your_size>
normal = { family = "<name_of_the_font>", style = "Regular" }
```
