# Warning: Refusing to link macOS provided/shadowed software: openssl@1.1
# If you need to have openssl@1.1 first in your PATH, run:
# echo 'fish_add_path /opt/homebrew/opt/openssl@1.1/bin' >> ~/.config/fish/config.fish
fish_add_path /opt/homebrew/opt/openssl@1.1/bin

# For compilers to find openssl@1.1 you may need to set:
set -gx LDFLAGS "-L/opt/homebrew/opt/openssl@1.1/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/openssl@1.1/include"

# For pkg-config to find openssl@1.1 you may need to set:
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
