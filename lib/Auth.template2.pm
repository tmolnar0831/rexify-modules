#
# Auth.pm Rex authentication file
# Keep it safe!
#

# set your username
set user => "root";

# set your password
set password => "titkos";

# enable password auth
set -passauth;

auth
  fallback => {
    user     => "tmolnar",
    password => "titkos",
    sudo     => TRUE,
  },
  {
    user     => "iron",
    password => "titkos",
    public_key  => "blabla",
    private_key => "blalba",
  };
