# NixOS module for the OWON VDS1022 / VDS1022I USB oscilloscope.
# Software: https://github.com/florentbr/OWON-VDS1022 (modified OWON app, Java)
#
# Usage: copy to /etc/nixos/ and add  ./owon-vds1022.nix  to `imports` in configuration.nix.
{ pkgs, ... }:

let
  owon-vds-tiny = pkgs.stdenv.mkDerivation rec {
    pname = "owon-vds-tiny";
    version = "1.1.5-cf19";

    src = pkgs.fetchFromGitHub {
      owner = "florentbr";
      repo = "OWON-VDS1022";
      rev = "a21cee14fc0807ce804657a26772784c4e47b5ef";
      hash = "sha256-AeHYjJ4prJiHm1CUryH4ZBhKxPc4Ab9VnE96jmYPD2A=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper pkgs.copyDesktopItems ];
    buildInputs = [ pkgs.libusb1 ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = pname;
        desktopName = "OWON VDS1022";
        genericName = "Oscilloscope";
        comment = "Application for the OWON VDS1022 oscilloscope";
        exec = pname;
        icon = pname;
        categories = [ "Utility" "Electronics" "Engineering" ];
        startupWMClass = "com-owon-vds-tiny-Main";
      })
    ];

    installPhase = ''
      runHook preInstall

      app=$out/opt/${pname}
      mkdir -p $app/lib
      cp -r fwr doc version.txt $app/
      cp lib/*.jar $app/lib/
      # Native libs must sit next to ch.ntb.usb jar; app dir is resolved as lib/..
      cp lib/linux/amd64/* $app/lib/

      makeWrapper ${pkgs.jdk}/bin/java $out/bin/${pname} \
        --add-flags "-Dawt.robot.screenshotMethod=x11" \
        --add-flags "-cp '$app/lib/*' com.owon.vds.tiny.Main" \
        --prefix LD_LIBRARY_PATH : "$app/lib:${pkgs.libusb1}/lib"

      for px in 32 48 64 96 128 256; do
        install -Dm644 ico/icon-$px.png $out/share/icons/hicolor/''${px}x''${px}/apps/${pname}.png
      done

      runHook postInstall
    '';

    meta.platforms = [ "x86_64-linux" ];
  };
in
{
  environment.systemPackages = [ owon-vds-tiny ];

  # USB access for normal users, and stop usb_serial_simple from grabbing the scope.
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="5345", ATTRS{idProduct}=="1234", MODE="0666"
    ACTION=="bind", DRIVER=="usb_serial_simple", ATTRS{idVendor}=="5345", ATTRS{idProduct}=="1234", ATTR{driver/unbind}="%k"
  '';
}
