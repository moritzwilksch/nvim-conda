set -euo pipefail

# 1. patch lazypath variable to be in prefix (install location of lazy itself)
# 2. patch lazy root config to be in prefix (https://lazy.folke.io/configuration)

mkdir -p $PREFIX/share/nvim
mkdir -p $PREFIX/share/nvim/lazy/

cp nvim-config/*.lua $PREFIX/share/nvim
mv lazy-nvim $PREFIX/share/nvim/lazy/lazy.nvim

# patch nvim-lazy install path
sed -i "s|local lazypath = .*|local lazypath = \'$PREFIX/share/nvim/lazy/lazy.nvim\'|g" $PREFIX/share/nvim/init.lua
sed -i "s|local lazypath = .*|local lazypath = \'$PREFIX/share/nvim/lazy/lazy.nvim\'|g" $PREFIX/share/nvim/mini-init.lua

# patch lazygit root: add as a sibling of the already patched config using it as an anchor
linenum=$(grep -n "performance = { cache = { enabled = false, }}" $PREFIX/share/nvim/init.lua | cut -d ":" -f 1)
sed -i "${linenum}s/"'$'"/,/;${linenum}a     root = '$PREFIX/lazy'" $PREFIX/share/nvim/init.lua

nvim -u $PREFIX/share/nvim/init.lua --headless \
    "+Lazy! sync" "+qa" \
    "+TSInstall! python toml yaml sql bash c lua markdown vim vimdoc" \
    "+TSUpdatSync!" \
    "+qa"