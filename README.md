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

## Fast access to throwaway directories

This function creates a new temporary directory, then switches to it immediately:

```shell
function tmpdir
    cd (mktemp -d)
end
```

For example:

```console
$ tmpdir

$ pwd
/private/var/folders/jy/351n9lnj5l3f07rtf2xybxx00000gn/T/tmp.IPM5GStx
```

I use this multiple times a day, whenever I want to write a throwaway Python script or a quick example.
I create the temp directory, do whatever work I need to do, then I move on -- and at some point (probably the next restart), the OS will clean it up for me.
If I decide I actually do want to keep it, I just move the folder to my Desktop.

It means I don't have to worry about cluttering up my disk with files that don't have any long-term value.
