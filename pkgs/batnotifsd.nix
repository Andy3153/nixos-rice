## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Battery notifications daemon
##
## https://github.com/Andy3153/batnotifsd
## https://pypi.org/project/batnotifsd/
##

{
  python3Packages,
  fetchPypi,
  lib,

  wrapGAppsNoGuiHook,
  gobject-introspection,
}:

python3Packages.buildPythonApplication (finalAttrs:
{
  pname   = "batnotifsd";
  version = "1.0.5";

  pyproject    = true;
  build-system = [ python3Packages.hatchling ];

  dependencies = lib.lists.flatten
  [
    (with python3Packages;
    [
      pydbus
      pygobject3
    ])

    [
      wrapGAppsNoGuiHook
      gobject-introspection
    ]
  ];

  src = fetchPypi
  {
    pname   = finalAttrs.pname;
    version = finalAttrs.version;
    hash    = "sha256-yTdh3e6t3TsJmkTpVgnghSwexC8aVuVg2PUA7j19BLo=";
  };

  postInstall =
  ''
    mkdir -p $out/bin
    mv $out/lib/python*/site-packages/${finalAttrs.pname}/${finalAttrs.pname}.py $out/bin/${finalAttrs.pname}
    rm -rf $out/lib
  '';

  meta =
  {
    description = "A Python script that sends notifications about the battery's status.";

    longDescription =
    ''
      This is a Python script that sends notifications about the battery's status (charger plugged in/unplugged, low/critical battery levels).

      It's useful for window managers where you don't get this functionality out of the box like in a desktop environment.
    '';

    homepage = "https://github.com/Andy3153/${finalAttrs.pname}";
    license  = lib.licenses.gpl2;

    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ Andy3153 ] ;
    platforms   = lib.platforms.all;
  };
})
