desc "Copy my .vimrc to the remote servers.";
task "copy-vim-config", sub {
  install file => "$myhome/.vimrc", {
    source => "$myhome/.vimrc",
    owner  => "iron",
    group  => "iron",
    mode   => 644,
  };
};
