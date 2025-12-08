# dotdotdot
Bi-directional configuration-as-code. Deploy the same configuration on multiple machines, change the configuration anywhere, and have it synchronize across all machines.

## Quick installation

On Ubuntu the prerequisites are `ca-certificates bc git zsh curl rsync wget ssh`.

```
wget -qO - https://raw.githubusercontent.com/gauravmm/dotdotdot/master/install | bash
```

`dotdotdot` will be installed to `~/.dotdotdot`. You have to either manually run it each time, or call `~/.dotdotdot/update` at the end of your `.bashrc`. 

## How it Works

Machine configurations are specified by regular bash scripts ending in `.dotsh`. Put all your `.dotsh` configutation files into a single folder called `dotfiles` in this directory, and invoke the script with `./dotdotdot`. All your scripts will be run.

The real power of `dotdotdot` is in the `git` integration. If `dotfiles` is in a git repository, the repository state is checked and synchronized with the remote before the scripts are run.

The final piece of the puzzle are your scripts: in order for the configuration to be synchronized, your scripts should be bidirectional:

 - Entire files can be done with a pair of `rsync` commands. See `zsh.dotsh`.
 - Configuring programs can be done with some creative application of `bash` code. See `vscode.dotsh`.

After all the scripts are run, your repository should only be dirty if there are changes made to your configuration. You can then:

 - Revert these changes, undoing them at next execution;
 - Commit and push them, which shares them to all other machines;
 - Branch, commit, and push them, which lets you maintain separate configurations for groups of machines.

The beauty of this approach is that it is git-friendly, allowing you to use version control on your config files.
