package System;

use Rex -base;
use Data::Dumper;

desc "Update the operating system";
task "update", sub {
    sudo sub {
        if ( operating_system eq "Ubuntu" ) {
            Rex::Logger::info(
                "Updating package database first on Debian based systems");
            update_package_db;
        }

        Rex::Logger::info("Updating the system");
        update_system;
    };
};

desc 'Dump hardware information';
task 'hwinfo', sub {
    my %all_info  = Rex::Hardware->get(qw/ All /);
    print Dumper \%all_info;
};

1;
