#
# AUTHOR: Tamas Molnar <stiron@gmail.com>
# REQUIRES:
# LICENSE: Apache License 2.0
#
# Simple Module to install a PostgreSQL server.

package Rex::Database::PostgreSQL;

use Rex -base;

my $pkg = case operating_system, {
    Ubuntu    => 'postgresql',
      default => 'postgresql',
};

my $service = case operating_system, {
    Ubuntu    => 'postgresql',
      default => 'postgresql',
};

desc 'Install the PostgreSQL package';
task 'install', sub {
    pkg $pkg, ensure => 'present';
    service $service => 'ensure' => 'started';
};

desc 'Start the PostgreSQL service';
task 'start', sub {
    service $service => 'start';
};

desc 'Stop the PostgreSQL service';
task 'stop', sub {
    service $service => 'stop';
};

desc 'Restart the PostgreSQL service';
task 'restart', sub {
    service $service => 'restart';
};
