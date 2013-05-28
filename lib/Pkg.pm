desc "Update the package database.";
task "update-pkg-db", sub {
  sudo sub {  
    update_package_db;
  };
};

desc "Update the system.";
task "update-system", sub {
  sudo sub {
    update_system;
  };
};

desc "Install some packages.";
task "install-packages", sub {
 sudo sub {
    install package => [ "vim", "mc", "perl", "git" ];
  };
};
