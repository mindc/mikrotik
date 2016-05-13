package Mikrotik::Parser;

use Exporter qw( import );
use strict;
use warnings;

use Parse::RecDescent;

our @EXPORT = qw( mikrotik_parse );
our @EXPORT_OK = qw( mikrotik_parse );

$Data::Dumper::Indent = 1;

#$::RD_HINT   = 1;
#$::RD_WARN   = 1;
#$::RD_ERRORS = 1;
#$::RD_TRACE = 1;
#$::RD_AUTOACTION = q { print "\e[1;33m[",join("][",@item),"]\e[m",$/; [@item] };

our $grammar = <<'__GRAMMAR';
index: /[0-9]+/
flags: /[RSDXI\*]+/
comment: ';;;' /[^\r\n]*/ eol { $item[-2] }
name: /[-a-zA-Z0-9\/\.]+(?==)/
name2: /[-a-zA-Z0-9\/\.]+/
eol: /\r?\n/

value: /[-a-zA-Z0-9\._:,@%\/\(\) ]+(?= |"|\n)/  #"
value2: '"' /[-a-zA-Z0-9\._:,@%\/\(\) ]+/ '"' { $item[-2] } | /[-a-zA-Z0-9\._:,@%\/\(\) ]+/  { $item[-1] }


value_q:  '"' value '"' eol(?) { $item[-3] } | '"' '' '"' eol(?) { $item[-3] }
value_inner: value eol(?) ...name '=' { $item[-5] }
value_last: value eol(?) { $item[-2] }

parameter: <skip: qr/[ \t]*/> name '=' ( value_q | value_inner | value_last ) {{  name => $item[-3],  value => $item[-1] }}
entry: <skip: qr/[ \t]*/> index(?) flags(?) comment(?) parameter(s?) eol {{ index => $item[-5][0], comment => $item[-3][0], flags => $item[-4][0], parameters => $item[-2] }}

entry2: <skip: qr/[ \t]*/> name2 ': ' value2 eol {{  name => $item[-4],  value => $item[-2] }}
export: entry(s) | entry2(s)

__GRAMMAR

our $parser = Parse::RecDescent->new( $grammar );

sub mikrotik_parse
{
	my $string = shift;
	return $parser->export( _prepare( $string ) );	
}

sub _prepare
{
    my $string = shift;
    $string =~ s/Flags.*?\r?\n//;
    return $string;
}

1;