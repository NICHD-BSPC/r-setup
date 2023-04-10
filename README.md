# Setting up efficient and reproducible command-line R

## Quickstart

- install neovim, plugins, and config
- work on code in nvim, send code to R interpreter (both running in terminal)
- view HTML and figures via mounted share

## Overview

RStudio is great for working with R on a local machine. However, it does not
work well in these situations:

1. You need to use more powerful hardware (CPU, RAM, storage) than is available on your local machine
2. You want to work in a shared environment (so others can work on, debug, or otherwise help directly)

Options not discussed further here:

- NoMachine can be used to connect to a high-performance compute cluster, and
  RStudio can be started up within a graphical user interface (GUI). However,
  the unavoidable lag induced by interacting with a GUI over the network makes
  it unusable at normal typing speeds.

- RStudio Server can be set up on a single high-powered server, either
  on-premises or in the cloud. This should not have the same lag issue.
  However, depending on institutional security requirements, this could be
  a rather large administrative burden. It can also be challenging to create
  reproducible environments that contain more than just R. Working in a shared
  environment can also be challenging with this method.

The solution we use at NICHD's Bioinformatics and Scientific Programming Core
(BSPC) is to create an RStudio-like environment within the terminal. Here, we
discuss setup on NIH's [Biowulf](https://hpc.nih.gov) HPC, but the setup is
similar.

To users accustomed to RStudio, a major difference in this method is how
figures are viewed. In RStudio, a new figure shows up either inline in the
RMarkdown, or in the side figure panel. Using this method, figures are viewed
by refreshing an HTML file or PNG in a web browser.

The trick is that you need access to the HTML or PNG on the local system. The
easiest way is to mount the storage locally, as described in the [Biowulf
docs](https://hpc.nih.gov/docs/hpcdrive.html). Then in a web browser, navigate
to your working directory (e.g., `file:///Volumes/mounted_directory/analysis`
on a Mac) to view results.

## Plain vanilla solution
- Use a text editor in one window and an open R interpreter in the other
- Copy/paste from one to the other
- Write plots to PNG (using `png(file="myplot.png")` just before
  plotting, and `dev.off()` just after), or write your code in RMarkdown (and
  run with `rmarkdown::render('myfile.Rmd')`. View
  output in a browser.

## An RStudio-like solution in the terminal

Below are instructions for setting up and using R from the terminal that is as
powerful than RStudio, can run in just a terminal (so from interactive nodes),
and can use arbitrary conda environments.

- streamlined copy/pasting since everything's in vim
- syntax highlighting for R code in RMarkdown code chunks
- shortcuts to send an entire code chunk at a time
- shortcut to render entire RMarkdown

The setup described here is intended to be run on the system you will be
running R on. So if you're planning on running R from the terminal on Biowulf
as well as locally, you'll need to do this on both systems.

In general, if this is all new to you, you may want to consider
https://github.com/daler/dotfiles which has a setup script that automates much
of this setup and installation.

### Neovim

If you are using [Biowulf](https://hpc.nih.gov), it's already installed but you
need to load the module (`module load neovim`) to use it.

Otherwise see https://github.com/daler/dotfiles for quick installation, or
https://neovim.io for more info.

There are some amazing plugins out there for nvim. Several are included in the
configration described below. To use them, you'll need a plugin manager.
A commonly-used one is `vim-plug`. You need to download `plug.vim` and save it
as `~/.local/share/nvim/site/autoload/plug.vim`. Or run the following commands
in `bash`:

```bash
dest=~/.local/share/nvim/site/autoload/plug.vim
mkdir -p $(dirname $dest)
wget -O - https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $dest
```

### Configuration

Neovim's config file lives in `~/.config/nvim/init.vim`.

This repo has a file, `init.vim`, with the minimal setup needed. It is
well-commented. You can copy the contents over to your existing `init.vim`, or use the whole thing.

If you don't already have your own dotfiles (set of config files), take a look
at https://github.com/daler/dotfiles for a starter set.

If you have a nicely customized `.vimrc`, just copy it over, nvim is backwards
compatible with vim.

Otherwise, copy the contents of this repo's `init.vim` to use neoterm. In `bash`:

```bash
mkdir -p .config/nvim
wget -O - \
  https://raw.githubusercontent.com/NICHD-BSPC/r-setup/master/init.vim \
  > ~/.config/nvim/init.vim
```

# Workflow

## Shortcuts

The following shortcuts are referred to in the instructions below. Note that
<kbd>,</kbd> is the leader key, set to comma in the above configuration.


| mapping                              | works in mode    | description                                                               |
|--------------------------------------|------------------|---------------------------------------------------------------------------|
| <kbd>,</kbd><kbd>t</kbd>             | normal           | Open a new terminal window to the right                                   |
| <kbd>Alt</kbd><kbd>w</kbd>           | normal or insert | Move to terminal window on right and enter insert mode                    |
| <kbd>,</kbd><kbd>w</kbd>             | normal           | Move to terminal on right and enter insert mode                           |
| <kbd>Alt</kbd><kbd>q</kbd>           | normal or insert | Move to buffer on left and enter normal mode                              |
| <kbd>,</kbd><kbd>q</kbd>             | normal           | Move to buffer on left and enter normal mode                              |
| <kbd>g</kbd><kbd>x</kbd>             | visual           | Send selection to terminal                                                |
| <kbd>g</kbd><kbd>x</kbd><kbd>x</kbd> | normal           | Send current line to terminal                                             |
| <kbd>,</kbd><kbd>c</kbd><kbd>d</kbd> | normal           | Send current Rmarkdown code chunk to terminal and move to next code chunk |
| <kbd>,</kbd><kbd>k</kbd>             | normal           | Render current RMarkdown as HTML                                          |

## Initial setup when first opening a file

When working on some code, do this first.

1. Open or create a new RMarkdown file with nvim
2. Open a new neoterm terminal to the right (`,t`).
3. Move to that terminal (`,w`)
4. In the terminal, activate your environment and start the R interpreter
5. Go back to the RMarkdown or R script (`,q`), and use the commands above to send
   lines over
6. Mount the remote storage on your local machine
7. Navigate to HTML or PNGs

## Iterative workflow

1. Write some R code.
2. `gxx` to send the current line to R
3. Highlight some lines (`Shift-V` in vim gets you to visual select mode), `gx`
   sends them over to the terminal.
4. Inside a code chunk, `,cd` sends the entire code chunk and then jumps to the
   next one. This way you can `,cd` your way through an Rmd
5. `,k` to render the current Rmd to HTML
6. Refresh browser to see new HTML

## Tightening the feedback loop

Many times we need to work on tweaking a figure that is part of
a larger analysis. In such a case, it does not make sense to run the *entire*
RMarkdown file each time we make a change to the figure.

Even with heavy use of chunk caching (so that code doesn't need to run), simply
creating the HTML file to inspect can take some time, especially when
extensive interactive [plotly](https://plotly.com) plots are included. This can
result in a long feedback loop and can get frustrating.

To improve this, we rely on the fact that the R workspace is persistent. Running
a large Rmd just once (e.g., with `,k`) will load all of the objects into the
running R interpreter. Then, we create a new RMarkdown file (`:e scratch.Rmd`),
and paste in just the small amount of code we're working on. That file can be
very quickly rendered with `,k`, and quickly inspected (in this example, the
results would be in `scratch.html`). 

In this way, we get a tight feedback loop between changing code, re-running
just that part into a smaller HTML file, and inspecting the results.

Once we've worked out what that single chunk should look like, we can copy it
back to the larger RMarkdown, and move to the next chunk -- often replacing the
previous contents of `scratch.Rmd` with the new chunk just to keep things simple.


## Troubleshooting

On Biowulf, sometimes text gets garbled when using an interactive node on biowulf. This is
due to a known bug in Slurm, but Biowulf is not intending on updating any time
soon. The fix is `Ctrl-L` either in the Rmd buffer or in the terminal buffer.
Alternatively, you can open the Rmd or R script file on Helix or the Biowulf
login node, and after opening the nvim terminal changing to the interactive
node to run R.

Remember that the terminal is a vim window, so to enter commands you need to be
in insert mode.

A common gotcha is when checking the help in R (`?`), to get out of it you need
to use `q`, but vim might still be in normal mode. So you may need to use `i`
or `a` to get into insert mode so you can use `q` to quit.

## Folding

To help manage large RMarkdown files, you can use folding. Using the provided
`init.vim`, both code blocks and Markdown sections can be folded.

- `zM` to fold everything up
- `zn` to unfold everything
- `zc` to fold just the code block you're in or the section you're in
- `za` to unfold just the code block or section

You can also unfold by entering insert mode when the cursor is over a fold.
