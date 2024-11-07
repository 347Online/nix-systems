{
  services.gotosocial = {
    enable = true;

    openFirewall = true;

    settings = {
      application-name = "Social.FatGirl.Cloud";
      host = "social.fatgirl.cloud";
      protocol = "https";
      bind-address = "0.0.0.0";
      port = 3475;
    };
  };
}
