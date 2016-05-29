package install;

use Rex -base;
use Rex::CMDB;

desc "Install miscellaneous packages on the system";
task "miscellaneous", sub {
    my $devtools = case operating_system, {
        CentOS    => "yum -y groupinstall \"Development Tools\"",
          Ubuntu  => "apt-get install --yes --quiet build-essential",
          default => "apt-get install --yes --quiet build-essential",
    };

    sudo sub {
        pkg [ "mc", "curl", "wget", "dkms" ], ensure => "latest";

        if ( operating_system eq "Ubuntu" ) {
            pkg "aptitude",                   ensure => "latest";
            pkg "python-software-properties", ensure => "latest";
        }

        Rex::Logger::info("Installing/updating the development tools");
        run "install-devtools", command => $devtools;
    };
};

desc "Install and configure the VIM package";
task "vim", sub {
    my $remote_user = get( cmdb('remote_user') );
    my $vimpkg = case operating_system, {
        CentOS    => "vim-common",
          Ubuntu  => "vim",
          default => "vim",
    };

    sudo sub {
        pkg $vimpkg, ensure => 'latest';

        file "/home/${remote_user}/.vimrc",
          source => 'files/vimrc',
          owner  => ${remote_user},
          group  => ${remote_user},
          mode   => 640;
    };
};

desc "Install and configure the tmux package";
task "tmux", sub {
    my $remote_user = get( cmdb('remote_user') );

    sudo sub {
        pkg "tmux", ensure => "latest";

        file "/home/${remote_user}/.tmux.conf",
          source => 'files/tmux.conf',
          owner  => ${remote_user},
          group  => ${remote_user},
          mode   => 640;
    };
};

desc "Install VirtualBox 5.0";
task "virtualbox", sub {
    needs repo 'virtualbox';
    sudo sub {
        pkg "virtualbox-5.0", ensure => "present";
    };
};

1;
