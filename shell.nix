{ pkgs ? import <nixpkgs> {} }:
  with pkgs;
  mkShell {
    buildInputs = [
      ansible
      jq
      kubectl
      sshpass
      terraform
      vagrant
    ];
}
