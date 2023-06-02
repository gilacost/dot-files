{
  # {imported to configuration.nix direct as home-manager does not support 1password
  _1password = { enable = true; };

  # Enable the 1Passsword GUI with myself as an authorized user for polkit
  _1password-gui = {
    enable = true;
    #    polkitPolicyOwners = [ "dustin" ];
  };
}
