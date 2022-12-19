{
  pkgs ? import <nixpkgs> {},
}:
with pkgs;
let
  zipName =
    if stdenv.isLinux then "mkbootimg-Linux.zip"
    else if stdenv.isDarwin then "mkbootimg-MacOSX.zip"
    else abort "unknown os";
  mkbootimg = stdenv.mkDerivation {
    pname = "mkbootimg";
    version = "6b56345f01de7081f4021fd60d969c2df0932674";
    src = fetchFromGitLab {
      owner = "bztsrc";
      repo = "bootboot";
      rev = "6b56345f01de7081f4021fd60d969c2df0932674";
      sha256 = "sha256-GiDVffPE7nS+GSjWb8Kq9HzW4zOS8pYfngw3k3EPrpM=";
    };
    buildInputs = [ zip unzip gcc ];
    makeFlags = [ "-C" "mkbootimg" "mkbootimg" ];
    installPhase = ''
      mkdir -p $out/bin
      unzip ${zipName} mkbootimg -d $out/bin
    '';
  };
in
mkShell {
  buildInputs = [
    binutils
    mkbootimg
    qemu
    gdb
  ];
}
