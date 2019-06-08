# Setting up efficient and reproducible command-line R

RStudio is really nice. However it is difficult to set up to run using an
arbitrary conda environment and difficult to run from an interactive node on
biowulf.

As a result, we tend to run RStudio locally and work on the mapped drive. This
can cause permission issues on the mapped drive, and symlinks don't work, but
worse is that we each have separate sets of R packages locally installed and so
we cannot easily test each others' code.

The plain vanilla solution would be a text editor in one window and an open
R interpreter in the other. Then copy/paste from one to the other.

Below are instructions for setting up and using R from the terminal that is as
powerful than RStudio, can run in just a terminal (so from biowulf interactive
nodes), and can use arbitrary conda envs.

- streamlined copy/pasting since everything's in vim
- syntax highlighting for R code in RMarkdown code chunks
- shortcuts to send an entire code chunk at a time
- shortcut to render entire RMarkdown
- R with tab completion and syntax highlighting
- figures pop up in separate windows

# Neovim

This part's pretty easy, it's already installed on Biowulf.

I put the following in my `.bashrc` on Biowulf, so any time I log in I'll
always use nvim:

```bash
module load neovim
alias vim="nvim"
```

# Using daler/dotfiles?

```bash
cd dotfiles
git pull origin master
cp .config/nvim/init.vim ~/.config/nvim/init.vim
```

Then open nvim, and run:

```
:PlugInstall
```

You're good to go; skip down to the "Radian" and "Workflow" sections.

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

Neovim's config file lives in `~/.config/nvim/init.vim`. If you have a nicely
customized `.vimrc`, just copy it over, nvim is backwards compatible with vim.

My [dotfiles](https://github.com/daler/dotfiles) repo has a full `init.vim`
configuration, but I've copied only the parts relevant to running R in neovim
here. 

Then you'll need to copy the contents of this repo's `init.vim` to use neoterm.


# Workflow

## Initial setup

1. Open or create a new RMarkdown file with nvim
2. `,t` to open a terminal
3. `,w` to move over to the terminal and enter insert mode.
4. In the terminal, source activate your environment
5. Start R in the terminal
6. `<Esc>,q` to go back to the RMarkdown

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


## Folding

To help manage large RMarkdown files, you can use folding. Using the provided
`init.vim`, both code blocks and Markdown sections can be folded.


- `zM` to fold everything up
- `zn` to unfold everything
- `zc` to fold just the code block you're in or the section you're in
- `za` to unfold just the code block or section

You can also unfold by entering insert mode when the cursor is over a fold.

