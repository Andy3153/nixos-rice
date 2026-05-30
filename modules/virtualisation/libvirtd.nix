## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Libvirtd config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.virtualisation.libvirtd;
  mainUser = config.custom.users.mainUser;

  # {{{ virtiofsd fork
  ##
  ## https://gitlab.com/virtio-fs/virtiofsd/-/work_items/96#note_2514997399
  ##

  virtiofsd = pkgs.callPackage
  ({ lib
  , stdenv
  , rustPlatform
  , fetchFromGitLab
  , libcap_ng
  , libseccomp
  }:

  rustPlatform.buildRustPackage rec {
    pname = "virtiofsd-hreitz-fork"; # Or just "virtiofsd" if you ensure no clashes
    version = "8fa5564fdd4d5296997fb054a5e3193e18a81bcf"; # The specific commit hash

    src = fetchFromGitLab {
      owner = "hreitz";
      repo = "virtiofsd-rs";
      rev = version; # Use the commit hash
      hash = "sha256-QjLOjH+AvF3I9ffLTRhEfwRKG7SIjTy9kQv3Q/it+hs=";
    };

    # From the original nixpkgs package, likely still relevant
    separateDebugInfo = true;
    useFetchCargoVendor = true;

    cargoHash = "sha256-reaVHbfrHj5iZjpRaB+nREctoS3ZLdl5WGIurpRqjZU=";

    # Copied from the original nixpkgs virtiofsd package definition
    LIBCAPNG_LIB_PATH = "${lib.getLib libcap_ng}/lib";
    LIBCAPNG_LINK_TYPE = if stdenv.hostPlatform.isStatic then "static" else "dylib";

    buildInputs = [
      libcap_ng
      libseccomp
    ];

    # These phases assume '50-virtiofsd.json' exists at the root of the fetched source.
    # This file IS present at the specified commit in hreitz/virtiofsd-rs.
    postConfigure = ''
      sed -i "s|/usr/libexec|$out/bin|g" 50-virtiofsd.json
    '';

    postInstall = ''
      install -Dm644 50-virtiofsd.json "$out/share/qemu/vhost-user/50-virtiofsd.json"
    '';

    meta = with lib; {
      homepage = "https://gitlab.com/hreitz/virtiofsd-rs";
      description = "vhost-user virtio-fs device backend (hreitz/virtiofsd-rs fork at commit ${strings.substring 0 7 version})";
      platforms = platforms.linux;
      license = with licenses; [ asl20 bsd3 ];
      mainProgram = "virtiofsd";
    };
  }) { };
  # }}}
in
{
  options.custom.virtualisation.libvirtd.enable = lib.mkEnableOption "enables Libvirtd";

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = config.virtualisation.libvirtd.qemu.vhostUserPackages;

    programs.virt-manager.enable = true;

    virtualisation =
    {
      libvirtd =
      {
        enable = true;

        dbus.enable = true;

        onBoot     = "ignore";
        onShutdown = "suspend";

        qemu =
        {
          package           = pkgs.qemu_kvm;
          swtpm.enable      = true;
          vhostUserPackages = with pkgs;
          [
            guestfs-tools
            virtiofsd
          ];
        };
      };

      spiceUSBRedirection.enable = true;
    };

    users.users.${mainUser}.extraGroups = [ "libvirtd" ];

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      dconf.settings =
      {
        "org/virt-manager/virt-manager/connections" =
        {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
    # }}}
  };
}
