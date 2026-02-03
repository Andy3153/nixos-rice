## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## UEFI boot config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.uefi;
in
{
  options.custom.boot.uefi =
  {
    enable = lib.mkEnableOption "enables UEFI boot";
    secure-boot.enable = lib.mkEnableOption
    # {{{ Secure Boot description
    ''
      enables UEFI Secure Boot support

      steps to make it work:
      (more info at `https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md`)

      1. generate Secure Boot keys:
      ```
      # sbctl create-keys
      ```

      2. set `custom.boot.uefi.secure-boot.enable` to `true` in your configuration

      3. rebuild

      4. check everything went well
      ```
        # sbctl verify
        Verifying file database and EFI images in /boot...
        ✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
        ✓ /boot/EFI/Linux/nixos-generation-[...].efi is signed
        ✗ /boot/EFI/nixos/kernel-[...].efi is not signed
        ✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
      ```
      it's expected for the kernel to not be signed

      5. enable Secure Boot in your firmware configuration

      6. enroll Secure Boot keys
      ```
      # sbctl enroll-keys --microsoft
      ```
    '';
    # }}}
  };

  config = lib.mkMerge
  [
    (lib.mkIf cfg.enable
    {
      boot.loader.efi =
      {
        canTouchEfiVariables = true;
        efiSysMountPoint     = "/boot";
      };

      custom =
      {
        boot.loader.systemd-boot.enable = true;
        extraPackages = with pkgs;
        [
          efibootmgr # EFI
          sbctl      # EFI key-manager
        ];
      };
    })

    (lib.mkIf cfg.secure-boot.enable
    {
      boot.lanzaboote =
      {
        enable                  = true;
        autoGenerateKeys.enable = true;

        pkiBundle = if (lib.versionAtLeast lib.version "25.05pre")
        then "/var/lib/sbctl"
        else "/etc/secureboot";
      };

      custom.boot =
      {
        loader.systemd-boot.enable = lib.mkForce false; # Lanzaboote replaces the systemd-boot module
        uefi.enable                = lib.mkForce true;
      };
    })
  ];
}
