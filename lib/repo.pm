package repo;

use Rex -base;

desc 'Add the Virtualbox repository';
task 'virtualbox', sub {
    sudo sub {
        repository
          "add"      => "virtualbox",
          url        => "http://download.virtualbox.org/virtualbox/debian",
          distro     => "precise",
          repository => "contrib",
          key_url    => "https://www.virtualbox.org/download/oracle_vbox.asc";
        update_package_db;
    };
};

1;
