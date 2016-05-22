package users;

use Rex -base;

desc "Create default users";
task "create_default", sub {
    my @users = qw(iron tmolnar rex);

    for my $newuser (@users) {
        Rex::Logger::info("Creating/updating $newuser");
        create_group "$newuser" => {};

        my $groups = case operating_system, {
            CentOS    => [qw(wheel adm)],
              Ubuntu  => [qw(sudo adm)],
              default => [qw(sudo adm)],
        };

        unshift @$groups, $newuser;

        account "$newuser",
          home        => "/home/${newuser}",
          create_home => TRUE,
          comment     => "General User Account",
          groups      => $groups,
          password    => "ch4ng3m3";
    }
};

1;
