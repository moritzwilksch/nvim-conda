set -euo pipefail

mkdir -p $PREFIX/share/nvim
mkdir -p $PREFIX/share/nvim/lazy/

cp nvim-config/*.lua $PREFIX/share/nvim
mv lazy-nvim $PREFIX/share/nvim/lazy/lazy.nvim

# patch nvim-lazy install path
sed -i "s|local lazypath = .*|local lazypath = \'$PREFIX/share/nvim/lazy/lazy.nvim\'|g" $PREFIX/share/nvim/init.lua
sed -i "s|local lazypath = .*|local lazypath = \'$PREFIX/share/nvim/lazy/lazy.nvim\'|g" $PREFIX/share/nvim/mini-init.lua

nvim -u $PREFIX/share/nvim/init.lua --headless  "+Lazy! sync" "+qa"


# \
#                      "+TSInstall! python toml yaml sql bash c lua markdown vim vimdoc" \
#                      "+TSUpdatSync!" \
#                      "+qa"