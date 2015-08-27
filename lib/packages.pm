package packages;

use Rex -base;

desc "Install miscellaneous packages on the system";
task "install_misc", sub {
    my $vimpkg = case operating_system, {
        CentOS    => "vim-common",
          Ubuntu  => "vim",
          default => "vim",
    };
    my $devtools = case operating_system, {
        CentOS    => "yum -y groupinstall \"Development Tools\"",
          Ubuntu  => "apt-get install --yes --quiet build-essential",
          default => "apt-get install --yes --quiet build-essential",
    };

    pkg [ $vimpkg, "tmux", "mc", "curl", "wget", "python-software-properties" ],
      ensure => "latest";

    if ( operating_system eq "Ubuntu" ) {
        pkg "aptitude", ensure => "latest";
    }

    Rex::Logger::info("Installing/updating the development tools");
    run "install-devtools", command => $devtools;
};

desc "Update the operating system packages";
task "update_system", sub {
    if ( operating_system eq "Ubuntu" ) {
        Rex::Logger::info(
            "Updating package database first on Debian based systems");
        update_package_db;
    }

    Rex::Logger::info("Updating the system");
    update_system;
};

desc "Install VirtualBox";
task "virtualbox", sub {
    repository
      "add"      => "virtualbox",
      url        => "http://download.virtualbox.org/virtualbox/debian",
      distro     => "precise",
      repository => "contrib",
      key_url    => "https://www.virtualbox.org/download/oracle_vbox.asc";

    Rex::Logger::info(
        "Updating the package database after adding the new repo");
    update_package_db;

    pkg "virtualbox-5.0", ensure => "present";
};

desc "Install go-mptfs (Only on Ubuntu 12.04 desktop)";
task "go_mtpfs", sub {
    if ( operating_system eq "Ubuntu" and operating_system_version == 1204 ) {
        repository
          "add"      => "go-mtpfs",
          url        => "http://ppa.launchpad.net/webupd8team/unstable/ubuntu",
          distro     => "precise",
          repository => "main",
          key_server => "keyserver.ubuntu.com",
          key_id     => "7B2C3B0889BF5709A105D03AC2518248EEA14886";

        Rex::Logger::info(
            "Updating the package database after adding the new repo");
        update_package_db;

        pkg "go-mtpfs", ensure => "present";
    }
    else {
        die("This task only works on Ubuntu 12.04");
    }
};

1;
