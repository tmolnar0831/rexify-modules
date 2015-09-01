package perl;

use Rex -base;

my $cpanm = case operating_system, {
    CentOS    => "perl-App-cpanminus",
      Ubuntu  => "cpanminus",
      default => "cpanminus",
};

desc "Install cpanminus";
task "install_cpanminus", sub {
    pkg $cpanm,
      ensure => "latest",
      on_change =>
      sub { Rex::Logger::info("$cpanm has been installed on the sysetem") };
};

desc "Install Perlbrew with cpanm";
task "install_perlbrew", sub {
    if ( !is_installed($cpanm) ) {
        perl::install_cpanminus();
    }
    Rex::Logger::info("Installing Perlbrew");
    run "install_perlbrew", command => "cpanm App::perlbrew";
    if ( $? != 0 ) {
        Rex::Logger::info( "Installing Perlbrew was not successful", "warn" );
        my $retries = 3;
        while ( $retries > 0 ) {
            Rex::Logger::info(
                "Retrying to install Perlbrew, retries: $retries", "warn" );
            run "install_perlbrew", command => "cpanm App::perlbrew";
            Rex::Logger::info("Perlbrew has been installed") if $? == 0;
            last if $? == 0;
            --$retries;
        }
    }
    else {
        Rex::Logger::info("Perlbrew has been installed");
    }
};

desc "Compile the perl interpreter from CPAN";
task "compile_perl_cpan", sub {
    my $perlver = "5.22.0";
    my $perldir = "perl-${perlver}";
    my $destdir = "/opt/perl5/${perlver}";

    Rex::Logger::info("Downloading ${perlver}");
    download "http://www.cpan.org/src/5.0/${perldir}.tar.gz",
      "/tmp/${perldir}.tar.gz";

    Rex::Logger::info("Uploading ${perlver} to the remote machine");
    upload "/tmp/${perldir}.tar.gz", "/tmp/${perldir}.tar.gz";

    Rex::Logger::info("Extracting ${perlver}");
    extract "/tmp/${perldir}.tar.gz",
      owner => "root",
      group => "root",
      to    => "/tmp/";

    Rex::Logger::info("Creating the destination directory for ${perlver}");
    file "${destdir}",
      ensure => "directory",
      owner  => "root",
      group  => "root",
      mode   => 777;

    Rex::Logger::info("Configuring ${perlver}");
    run "configure",
      cwd     => "/tmp/${perldir}/",
      command => "./Configure -des -Dprefix=${destdir}";

    Rex::Logger::info("Making ${perlver}");
    run "make",
      cwd     => "/tmp/${perldir}/",
      command => "make";

    Rex::Logger::info("Installing ${perlver}");
    run "makeinstall",
      cwd     => "/tmp/${perldir}/",
      command => "make install";
};

1;
