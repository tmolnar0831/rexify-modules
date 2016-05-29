# use CMDB
use Rex::CMDB;
set cmdb => {
    type => 'YAML',
    path => [ 'cmdb/{hostname}.yaml', 'cmdb/default.yaml', ],
};

logformat "[%D] %l %h - %s";

# enable new Features
use Rex -feature => 0.40;

# load the authentication module
require Auth;

# load server groups
require Servers;

# set parallel run
parallelism 5;

# allow to use modules
require install;
require update;
require repo;
require perl;
require users;
