{ rev ? "fdfe5b028bd4da08f0c8aabf9fb5e143ce96c56f"
, outputSha256 ? "0x0p418csdmpdfp6v4gl5ahzqhg115bb3cvrz1rb1jc7n4vxhcc8"
}:
let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    sha256 = outputSha256;
  };
  pkgs = import nixpkgs {};
  haskellPkgs = pkgs.haskell.packages.ghc822.override(old: {
    overrides = self: super: {
      nix-miso-template = super.callCabal2nix "nix-miso-template" ./. {};
      http-types = super.callHackage "http-types" "0.11" {};
      resourcet = super.callHackage "resourcet" "1.1.11" {};
      servant = super.callHackage "servant" "0.12.1" {};
      servant-server = super.callHackage "servant-server" "0.12" {};
    };
  });
in
{ server = haskellPkgs.nix-miso-template;
  server-shell = haskellPkgs.shellFor {
    packages = p: [p.nix-miso-template];
  };
}
