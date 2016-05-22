package Crypt::RSA::Simple;

our $VERSION = '1.0.0';

use Crypt::OpenSSL::RSA;
use MIME::Base64;
use Carp;

=head1 NAME

B<Crypt::RSA::Simple> - Encrypts/decrypts text with RSA keys

=head1 SYNOPSIS

  use Crypt::RSA::Simple;

  my $crypt = Crypt::RSA::Simple->new(
    key_dir     => '/home/user/keys',
    key_size    => 2048,
    private_key => 'secure_key.priv',
    public_key  => 'secure_key.pub',
  );
  
  $crypt->generate()

Or it can be fed with method arguments:

  my $crypt = Crypt::RSA::Simple->new();

  $crypt->generate(
    '/home/user/keys',
    2048,
    'secure_key.priv',
    'secure_key.pub'
  );

Private and public keys can be set with
their getter/setter methods as well as the
key_dir and key_size:

  my $crypt->private_key( '/home/user/keys/secret.priv' );
  my $crypt->public_key( '/home/user/keys/secret.pub' );

  my $crypted   = $crypt->encrypt( 'text to crypt' );
  my $encrypted = $crypt->decrypt( $crypted );

Or keys can be used with the C<crypt> and C<decrypt>
methods as their arguments as well:

  my $decrypted = $crypt->decrypt(
    'encrypted text',
    '/home/user/keys/secret.priv'
  );

Class methods and instance methods are both supported:

  Crypt::RSA::Simple->encrypt( 'text', '/home/user/keys/secret.pub' );

=head1 DESCRIPTION

B<Crypt::RSA::Simple> is just a tiny but flexible wrapper on the top of the
C<Crypt::OpenSSL::RSA> library. It encrypts and decrypts
any text, and it can generate RSA keys if necessary.

This tool does not give any new features to the original module,
rather it wraps it into an easy-to-use form. It offers an elegant,
pure Perl OO interface.

It uses C<MIME::Base64> to encode/decode the crypted text, makes it
easier to store it on a drive e.g. in a file.

=head1 METHODS

=over 4

=item B<new>:

Creates a new Crypt::RSA::Simple object instance

B<Arguments>:

C<key_dir>: Path to the key directory (String)

C<key_size>: Key size for key generation (Integer)

C<private_key>: Name of the key (String)

C<public_key>: Name of the key (String)

All parameters can be set with getter/setter methods

=cut

sub new {
    my $this  = shift;
    my $class = ref($this) || $this;
    my $self  = bless {@_}, $class;
    $self->_set_defaults();
    return $self;
}

# Private function for setting default values
sub _set_defaults {
    my $self = shift;
    $self->{'key_dir'}     ||= '/var/tmp';
    $self->{'key_size'}    ||= 2048;
    $self->{'private_key'} ||= 'secure_rsa_key.priv';
    $self->{'public_key'}  ||= 'secure_rsa_key.pub';
    return $self;
}

=item B<private_key>:

Getter/setter method for the private key

=cut

sub private_key {
    my $self = shift;
    if (@_) {
        $self->{'private_key'} = shift;
    }
    return $self->{'private_key'};
}

=item B<public_key>:

Getter/setter method for the public key

=cut

sub public_key {
    my $self = shift;
    if (@_) {
        $self->{'public_key'} = shift;
    }
    return $self->{'public_key'};
}

=item B<key_dir>:

Getter/setter method for the key directory

=cut

sub key_dir {
    my $self = shift;
    if (@_) {
        $self->{'key_dir'} = shift;
    }
    return $self->{'key_dir'};
}

=item B<key_size>:

Getter/setter method for the key size

=cut

sub key_size {
    my $self = shift;
    if (@_) {
        $self->{'key_size'} = shift;
    }
    return $self->{'key_size'};
}

=item B<generate>:

Method for private and public key generation

B<Arguments>:

C<key_dir>: Path to the key directory (String)

C<key_size>: Key size for key generation (Integer)

C<private_key>: Name of the key (String)

C<public_key>: Name of the key (String)

This method generates a key pair into the C<key_dir> to
encrypt and decrypt with. If it is called without arguments
it uses the default values.

=cut

sub generate {
    my $self = shift;

    if (@_) {
        (
            $self->{'key_dir'},     $self->{'key_size'},
            $self->{'private_key'}, $self->{'public_key'}
        ) = @_;
    }

    if ( !-d $self->{'key_dir'} ) {
        croak "Keys directory does not exist: $self->{'key_dir'}\n";
    }

    my $rsa         = Crypt::OpenSSL::RSA->generate_key( $self->{'key_size'} );
    my $private_key = $rsa->get_private_key_string;
    my $public_key  = $rsa->get_public_key_string;
    my $priv_key_path = $self->{'key_dir'} . "/" . $self->{'private_key'};
    my $pub_key_path  = $self->{'key_dir'} . "/" . $self->{'public_key'};

    open( my $priv_fh, ">", $priv_key_path )
      or croak("Error writing to private key file: $priv_key_path: $!");
    print $priv_fh $private_key;
    close($priv_fh);

    open( my $pub_fh, ">", $pub_key_path )
      or croak("Error writing to public key file: $pub_key_path: $!");
    print $pub_fh $public_key;
    close($pub_fh);

    return 1;
}

=item B<encrypt>

Method for text encrytion

B<Arguments>:

C<text>: Text to be encrypted (String)

C<public_key>: Public key for encryption (String)

=cut

sub encrypt {
    my ( $self, $text, $public_key ) = @_;
    $public_key ||= $self->{'public_key'};
    my $key_string;
    open( my $pub_fh, "<", $public_key )
      or croak "Cannot open public key: $!\n";
    read( $pub_fh, $key_string, -s $pub_fh );
    close($pub_fh);
    my $public = Crypt::OpenSSL::RSA->new_public_key($key_string);

    return encode_base64( $public->encrypt($text) );
}

=item B<decrypt>

Method for decrypting ecrypted text

B<Arguments>:

C<text>: Text to be decrypted (String)

C<private_key>: Private key for encryption (String)

=cut

sub decrypt {
    my ( $self, $enc_text, $private_key ) = @_;
    $private_key ||= $self->{'private_key'};
    my $key_string;
    open( my $priv_fh, "<", $private_key )
      or croak "Cannot open private key: $!\n";
    read( $priv_fh, $key_string, -s $priv_fh );
    close($priv_fh);
    my $private = Crypt::OpenSSL::RSA->new_private_key($key_string);

    return $private->decrypt( decode_base64($enc_text) );
}

=back

=cut

=head1 AUTHOR

Tamas Molnar <stiron@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2015, Tamas Molnar

This library is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Crypt::OpenSSL::RSA>

L<MIME::Base64>

=cut

1;
