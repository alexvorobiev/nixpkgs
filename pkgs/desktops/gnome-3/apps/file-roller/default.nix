{ stdenv, fetchurl, glib, gtk, meson, ninja, pkgconfig, gnome3, gettext, libxml2, libarchive
, wrapGAppsHook, libnotify, nautilus }:

stdenv.mkDerivation rec {
  name = "file-roller-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "15pn2m80x45bzibig4zrqybnbr0n1f9wpqx7f2p6difldns3jwf1";
  };

  nativeBuildInputs = [ meson ninja gettext pkgconfig libxml2 wrapGAppsHook ];

  buildInputs = [ glib libarchive gnome3.defaultIconTheme libnotify nautilus ];

  installFlags = [ "nautilus_extensiondir=$(out)/lib/nautilus/extensions-3.0" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "file-roller";
      attrPath = "gnome3.file-roller";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/FileRoller;
    description = "Archive manager for the GNOME desktop environment";
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
