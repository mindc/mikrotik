package Mikrotik;

use strict;
use warnings;

use Mikrotik::Parser;

our $MNDP = {
	1 => sub { 'hwaddr' => join ":", unpack "(H2)6", shift },
	2 => sub { 'hwaddr' => join ":", unpack "(H2)6", shift },
	5 => sub { 'identity' => shift },
	7 => sub { 'fwversion' => shift },
	8 => sub { 'vendor' => shift },
	10 => sub { 'uptime' => unpack "L", shift },
	11 => sub { 'key' => shift },
	12 => sub { my $board = shift; return ( 'board' => $board, 'board_name' => $board ); },
	14 => sub { 'un1' => shift },
	16 => sub { 'un2' => shift },
};

sub mikrotik_ssh_get_interfaces
{
	my $ssh = shift;
	my ( $output, $error ) = $ssh->capture2( '/interface print detail' );
	my $data = mikrotik_parse( $output );
	return $data;
}


1;