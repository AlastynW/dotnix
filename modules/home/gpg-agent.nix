{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    # 26.05 : pinentryPackage -> pinentry.package
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
