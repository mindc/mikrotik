package Mikrotik::Cmd;

use strict;
use warnings;

use Exporter qw( import );
use Mikrotik::Parser qw( mikrotik_parse );

sub cmd {
    my %opts = (ref $_[0] eq 'HASH' ? %{shift()} : ());
    my ( $ssh, @cmd ) = @_;
    my ( $read, $err ) = $ssh->capture2(\%opts, @cmd);

	print "READ:$read\n";
	print "ERROR:$err\n";


    my $data = mikrotik_parse( $read );
	return $data;
}

1;