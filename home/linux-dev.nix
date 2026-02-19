{ ... }:
{
  # To add another Linux profile, create home/linux-<name>.nix and import ./linux.nix.
  imports = [
    ./linux.nix
  ];
}
