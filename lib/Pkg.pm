desc "Update only the package database.";
task "update-pkg-db", sub {
  sudo sub {  
    update_package_db;
  };
};

desc "Update the system.";
task "update-system", sub {
  sudo sub {
    update_package_db;
    update_system;
  };
};

desc "Install some essential stuff.";
task "install-packages", sub {
 sudo sub {
    install package => [ "vim", "mc", "perl", "git" ];
  };
};
