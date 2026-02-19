{ pkgs, lib, ... }:
{
  home.shellAliases = {
    getazkey = "AZKEY=$(az account get-access-token --resource-type oss-rdbms --output tsv --query accessToken | tee >(pbcopy))";
  };

  programs.zsh.initExtra = ''
    export NOTION_TOKEN=$(gopass show ph/notion-cli-key)
    source $(brew --prefix)/opt/spaceship/spaceship.zsh
    export NVM_DIR="$HOME/.nvm"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
  '';

  home.file = {
    ".aerospace.toml".source = ./../aerospace.toml;
    ".config/karabiner/karabiner.json".source = ./../karabiner.json;
    ".config/sketchybar/sketchybarrc".source = ./../sketchybarrc;
  };
}
