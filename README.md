# Setting up efficient and reproducible command-line R

RStudio is really nice. However it is difficult to set up to run using an
arbitrary conda environment and difficult to run from a cloud instance or an
interactive node on an HPC cluster.

As a result, we tend to run RStudio locally and work on the group network
share. This can cause permission issues on the network share, and symlinks
don't work, but worse is that we each have separate sets of R packages locally
installed and so we cannot easily test each others' code.

The plain vanilla solution would be a text editor in one window and an open
R interpreter in the other. Then copy/paste from one to the other.

Below are instructions for setting up and using R from the terminal that is as
powerful than RStudio, can run in just a terminal (so from interactive nodes),
and can use arbitrary conda envs.

- streamlined copy/pasting since everything's in vim
- syntax highlighting for R code in RMarkdown code chunks
- shortcuts to send an entire code chunk at a time
- shortcut to render entire RMarkdown
- R with tab completion and syntax highlighting
- figures pop up in separate windows

# Neovim

If you are using [Biowulf](https://hpc.nih.gov), it's already installed but you
need to load the module.

I put the following in my `.bashrc` on Biowulf, so any time I log in I'll
always use nvim:

```bash
module load neovim
alias vim="nvim"
```

# One-time installation of plugin manager

There are some amazing plugins out there for nvim. To use them, you'll need
a plugin manager. The one I use is `vim-plug`. You need to download `plug.vim`
and save it as `~/.local/share/nvim/site/autoload/plug.vim`. Or run the
following commands:

```bash
dest=~/.local/share/nvim/site/autoload/plug.vim
mkdir -p $(dirname $dest)
wget -O - https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > $dest
```

# Configuration

Neovim's config file lives in `~/.config/nvim/init.vim`.

If you have a nicely customized `.vimrc`, just copy it over, nvim is backwards
compatible with vim.

Otherwise, copy the contents of this repo's `init.vim` to use neoterm.

```bash
mkdir -p .config/nvim
wget -O - \
  https://raw.githubusercontent.com/NICHD-BSPC/r-setup/master/init.vim \
  ~/.config/nvim/init.vim
```

The file is well-commented so you can see what's going on.

# Workflow

## Connecting

To make sure that plots show up, make sure you're connecting with X11 forwarding.

If you will be working on Biowulf see the [biowulf
docs](https://hpc.nih.gov/docs/connect.html) on this.

## Shortcuts

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

## Initial setup

1. Open or create a new RMarkdown file with nvim
2. Open a neoterm terminal to the right (`,t`)
3. Move to that terminal (`Alt-w`).
4. In the terminal, source activate your environment
5. Start R in the terminal
6. Go back to the RMarkdown or R script, and use the commands above to send
   lines over.

## Working with R

1. Write some R code.
2. `gxx` to send the current line to R
3. Highlight some lines (`Shift-V` in vim gets you to visual select mode), `gx`
   sends them and then jumps to the terminal.
4. Inside a code chunk, `,cd` sends the entire code chunk and then jumps to the
   next one. This way you can `,cd` your way through an Rmd
5. `,k` to render the current Rmd to HTML.

## Troubleshooting

Sometimes text gets garbled when using an interactive node on biowulf. This is
due to a known bug in Slurm, but Biowulf is not intending on updating any time
soon. The fix is `Ctrl-L` either in the Rmd buffer or in the terminal buffer.

Remember that the terminal is a vim window, so to enter commands you need to be
in insert mode.

## Folding

To help manage large RMarkdown files, you can use folding. Using the provided
`init.vim`, both code blocks and Markdown sections can be folded.


- `zM` to fold everything up
- `zn` to unfold everything
- `zc` to fold just the code block you're in or the section you're in
- `za` to unfold just the code block or section

You can also unfold by entering insert mode when the cursor is over a fold.

