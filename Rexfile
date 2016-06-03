# use CMDB
use Rex::CMDB;
set cmdb => {
    type => 'YAML',
    path => [ 'cmdb/{hostname}.yaml', 'cmdb/default.yaml', ],
};

logformat "[%D] %l %h - %s";

# enable new Features
use Rex -feature => ['1.0'];

# load the authentication module
require Auth;

# turn on sudo globally
sudo -on;

# load server groups
require Servers;

# set parallel run
parallelism 5;

# allow to use modules
require Rex::Database::PostgreSQL;

require install;
require System;
require repo;
require perl;
require users;
