## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Spinner v2 Plymouth theme
##
## https://github.com/Andy3153/plymouth-spinnerv2-theme
##

{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs:
{
  themename = "spinnerv2";

  pname   = "plymouth-${finalAttrs.themename}-theme";
  version = "sdf";

  src = fetchFromGitHub
  {
    owner = "Andy3153";
    repo  = finalAttrs.pname;
    rev   = "738c426b5f70a75cf75304cb908149c7af612779";
    hash  = "sha256-3aLUSXqBFbnKRmpV7+NfDJ6CcSGQwbZjOh6oJqS8Ma0=";
  };

  dontBuild = true;

  installPhase =
  ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/${finalAttrs.themename}
    cp -r * $out/share/plymouth/themes/${finalAttrs.themename}
    substituteInPlace $out/share/plymouth/themes/${finalAttrs.themename}/${finalAttrs.themename}.plymouth \
      --replace-fail "/usr/" "$out/"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta =
  {
    description     = "A Plymouth theme loosely based on the default BGRT theme";
    longDescription = "Plymouth theme with the ACPI BGRT graphics on the background, custom elements, spinner animation from adi1090x/plymouth-themes and the NixOS logo at the bottom";
    homepage        = "https://github.com/Andy3153/${finalAttrs.pname}";
    license         = lib.licenses.gpl2;
    maintainers     = with lib.maintainers; [ Andy3153 ];
    platforms       = lib.platforms.linux;
  };
})
