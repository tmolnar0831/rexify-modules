package citrix;

use Rex -base;

desc "Install citrix ICA client (Only on Ubuntu 14.04 desktop)";
task "icaclient", sub {
    if ( operating_system eq "Ubuntu" and operating_system_version == 1404 ) {
        my $icaclient_file = "icaclient_13.1.0.285639_amd64.deb";

        Rex::Logger::info("Uploading $icaclient_file to the remote machine");
        upload "files/${icaclient_file}", "/tmp/${icaclient_file}";

        Rex::Logger::info("Adding the 32bit arch to the system");
        run "add-architecture",
          command => "dpkg --add-architecture i386",
          cwd     => "/tmp",
          unless  => "dpkg -l icaclient";

        update_package_db;

        Rex::Logger::info("Installing dependencies");
        pkg [
            'libxerces-c3.1',     'libwebkitgtk-1.0-0',
            'libc6:i386',         'libstdc++6:i386',
            'libgtk2.0-0:i386',   'libxext6:i386',
            'libxmu6:i386',       'libxpm4:i386',
            'libasound2:i386',    'libx11-6:i386',
            'libice6:i386',       'libsm6:i386',
            'libspeex1:i386',     'libvorbis0a:i386',
            'libvorbisenc2:i386', 'libcanberra-gtk-module:i386'
          ],
          ensure => "latest";

        Rex::Logger::info("Installing ${icaclient_file}");
        run "install-icaclient",
          command => "dpkg -i /tmp/${icaclient_file}",
          unless  => "dpkg -l icaclient";

        Rex::Logger::info("Adding the icaclient certs to Mozilla");
        run "add-certs",
          command =>
"ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/",
          unless =>
"ls /opt/Citrix/ICAClient/keystore/cacerts/NetLock_Business_=Class_B=_Root.crt";

        Rex::Logger::info("Rehashing the keystore");
        run "rehash-keystore",
          command => "c_rehash /opt/Citrix/ICAClient/keystore/cacerts/";

        run "remove-npwrapper",
          command =>
"rm -f /usr/lib/mozilla/plugins/npwrapper.npica.so /usr/lib/firefox/plugins/npwrapper.npica.so",
          only_if => "ls /usr/lib/mozilla/plugins/npwrapper.npica.so";

        run "remove-npica",
          command => "rm -f /usr/lib/mozilla/plugins/npica.so";

        run "symlink-so",
          command =>
"ln -s /opt/Citrix/ICAClient/npica.so /usr/lib/mozilla/plugins/npica.so";
    }
};

1;
