# fishconfig

This repo contains my config for my shell, which is [fish].
It goes together with [pathscripts], which contains scripts which aren't shell-specific but I find useful to keep around.

[fish]: https://fishshell.com/
[pathscripts]: https://github.com/alexwlchan/pathscripts

## Installation

To install this config on a new machine:

```console
$ ln -s (pwd)/config.fish ~/.config/fish/config.fish
```

## My shell prompt

This repo includes my shell prompt config (see [`_prompt.fish`](_prompt.fish)).

<img src="https://raw.githubusercontent.com/alexwlchan/fishconfig/main/prompt.png" alt="Screenshot of a terminal session. Black text on a white background. Each prompt starts on a newline with a dollar symbol. Some prompt have a line above them printing the current directory (in green), the Git branch (in cyan), and the hostname (in purple, and parentheses). The commands shown create and then read some text files, change to a new directory, then ssh into a remote host and run the same commands there.">

It's inspired by [other people's prompts](prompt_inspiration), but has a few ideas of my own.
It's meant to be fairly sparse, and progressively add information as it's interesting, rather than displaying everything by default.

*   I put a newline between prompts because I like having the clear separation between commands.

*   Each prompt has a context line that tells me what directory I'm working in, and what Git branch I'm on (if I'm in a Git repo).
    The shortened path (e.g. `~/r/fishconfig`) is provided by fish's [prompt_pwd function][prompt_pwd].

    I skip the context line if I'm in my home directory, because it's where new shells start, and that context isn't interesting.

*   I don't include the hostname in the prompt by default, because usually I find it to be visual noise -- I already know what machine I'm using!

    I do prepend the hostname if I've ssh'd into a machine (detecting the `SSH_CLIENT` environment variable), so that I can see this shell isn't for the machine I'm physically using.

[prompt_pwd]: https://fishshell.com/docs/current/cmds/prompt_pwd.html
