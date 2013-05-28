use Rex::Commands::User;

desc "Create a new user.";
task "user-create", sub {
  sudo sub {
    my $newuser = "droid";
    create_group "$newuser" => { };
    create_user "$newuser" => {
      home => "/home/$newuser",
      comment => "Rexify Droid User.",
      groups => [$newuser, 'wheel'],
      password => "secret12",
      ssh_key => " key "
    };
  };
};

desc "Delete a user.";
task "user-delete", sub {
  sudo sub {
    delete_user "droid", {
      delete_home => 1,
      force       => 1,
    };
  };  
};

desc "Get the user list.";
task "user-list", sub {
  sudo sub {
    my @users = user_list();
    my $filename = run "hostname";
    my @sorted_users = sort @users;
    for my $user (@sorted_users) {
      open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
      print $fh "$user\n";
      close $fh;
    };
  };  
};

desc "Get user info.";
task "user-info", sub {
  sudo sub {
    my @infoarray = get_user("zsola");
    for my $info (@infoarray) {
      say "userinfo: $info";  
    };
  };  
};
