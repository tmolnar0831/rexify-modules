package update;

use Rex -base;

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

1;
