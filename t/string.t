use Test::More;
use Data::Perl;

use strict;

# constructor
is ref(string('a')), 'Data::Perl::String', 'constructor shortcut works';

my $c = string('a');
is $$c, 'a', 'nondefault set works';

$c->inc;
is $$c, 'b', 'inc works';

$c = string(123);
is $$c, '123', 'nondefault set with number works';

# append
$c->append('z');
is $$c, '123z', 'append works';

# prepend
$c->prepend('a');
is $$c, 'a123z', 'prepend works';

# replace
$c->replace(qr/2/, 'e');
is $$c, 'a1e3z', 'replace works';
$c->replace('3', sub { ok 1, 'sub called in regex replace'; 'r'});
is $$c, 'a1erz', 'replace works';

# match
$c = string('5555');
ok $c->match(qr/5/), 'match works';

# chop
$c->chop;
is $$c, '555', 'chop works';

# chomp
$c = string("foo\n\n\n");
is $c->chomp, 1, 'chomp works';

# clear
$c->clear;
is $$c, '', 'clear works';


# length
$c = string("12345");
is $c->length, 5, 'length works';



done_testing();
