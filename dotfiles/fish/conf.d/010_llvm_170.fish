set --local llvm_config (brew --prefix llvm@17)/bin/llvm-config

if test -x $llvm_config
    set --local llvm_config_prefix ($llvm_config --prefix)

    set --global --export LLVM_SYS_170_PREFIX $llvm_config_prefix
    set --global --export LDFLAGS -L$HOMEBREW_PREFIX/opt/llvm/lib/c++ -Wl,-rpath,$HOMEBREW_PREFIX/opt/llvm/lib/c++
end
