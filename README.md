<div align="center">
    <h1>.dotfiles</h1>
    <p>Eventually, we all come back <b><code>$HOME</code></b> !</p>
    <p>

[The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles)
    </p>

</div>

## Restore Configurations
```bash
#!/usr/bin/env bash

cd ~
git clone --bare --recursive https://github.com/alen-mat/.dotfiles.git $HOME/.cfg

function config {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

mkdir -p .config-backup
config checkout

if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  config checkout
fi;

config submodule update --recursive --remote
config config status.showUntrackedFiles no
```
