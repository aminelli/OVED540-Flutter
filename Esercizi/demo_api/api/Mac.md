
sudo rm -rf /usr/local/bin/node

sudo rm -rf /usr/local/lib/node_modules

sudo rm -rf /usr/local/include/node

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

source ~/.zshrc

nvm install --lts

nvm use --lts

node --version