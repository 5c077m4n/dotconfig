{ pkgs-unstable }:
let
  inherit (pkgs-unstable)
    claude-code
    typescript-language-server
    vue-language-server
    pyright
    ;
in
{
  enable = true;
  package = claude-code;

  lspServers = {
    typescript = {
      command = "${typescript-language-server}/bin/typescript-language-server";
      args = [ "--stdio" ];
      extensionToLanguage = {
        ".ts" = "typescript";
        ".tsx" = "typescriptreact";
        ".js" = "javascript";
        ".jsx" = "javascriptreact";
        ".vue" = "vue";
      };
    };
    vue = {
      command = "${vue-language-server}/bin/vue-language-server";
      args = [ "--stdio" ];
      extensionToLanguage = {
        ".vue" = "vue";
      };
    };
    python = {
      command = "${pyright}/bin/pyright-langserver";
      args = [ "--stdio" ];
      extensionToLanguage = {
        ".py" = "python";
        ".pyi" = "python";
      };
    };
  };
}
