{
  pkgs ? import <nixpkgs> {},
}:
with pkgs;
let
  mkbootimg = stdenv.mkDerivation {
    pname = "mkbootimg";
    version = "6b56345f01de7081f4021fd60d969c2df0932674";
    src = fetchFromGitLab {
      owner = "bztsrc";
      repo = "bootboot";
      rev = "6b56345f01de7081f4021fd60d969c2df0932674";
      sha256 = "sha256-GiDVffPE7nS+GSjWb8Kq9HzW4zOS8pYfngw3k3EPrpM=";
    };
    buildInputs = [ zip unzip ];
    makeFlags = [ "-C" "mkbootimg" "mkbootimg" ];
    installPhase = ''
      mkdir -p $out/bin
      unzip mkbootimg-Linux.zip mkbootimg -d $out/bin
    '';
  };
in
mkShell {
  buildInputs = [
    binutils
    mkbootimg
    qemu
  ];
}
