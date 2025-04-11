set --local brew_llvm_170 (brew --prefix llvm@17)
set --local llvm_config_prefix ($brew_llvm_170/bin/llvm-config --prefix)

set --global --export LLVM_SYS_170_PREFIX $llvm_config_prefix
set --global --export LDFLAGS -L$HOMEBREW_PREFIX/opt/llvm/lib/c++ -Wl,-rpath,$HOMEBREW_PREFIX/opt/llvm/lib/c++
