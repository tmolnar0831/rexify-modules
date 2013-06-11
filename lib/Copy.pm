desc "Copy my .vimrc to the remote servers.";
task "copy-vim-config", sub {
  install file => "/home/iron/.vimrc", {
    source => "/home/iron/.vimrc",
    owner  => "iron",
    group  => "iron",
    mode   => 644,
  };
};
