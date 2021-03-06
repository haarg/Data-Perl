package Data::Perl::Collection::Hash;

# ABSTRACT: Wrapping class for Perl's built in hash structure.

use Scalar::Util qw/blessed/;

use strictures 1;

sub new { my $cl = shift; bless({ @_ }, $cl) }

sub get { my $self = shift; @_ > 1 ? @{$self}{@_} : $self->{$_[0]} }

sub set {
  my $self = shift;
  my @keys_idx = grep { ! ($_ % 2) } 0..$#_;
  my @values_idx = grep { $_ % 2 } 0..$#_;

  @{$self}{@_[@keys_idx]} = @_[@values_idx];

  return wantarray ? @{$self}{@_[@keys_idx]} : $self->{$_[$keys_idx[0]]};
}

sub delete { delete @{$_[0]}{@_} }

sub keys { keys %{$_[0]} }

sub exists { exists $_[0]->{$_[1]} }

sub defined { defined $_[0]->{$_[1]} }

sub values { values %{$_[0]} }

sub kv { map { [ $_, $_[0]->{$_} ] } CORE::keys %{$_[0]} }

sub elements { map { $_, $_[0]->{$_} } CORE::keys %{$_[0]} }

sub clear { %{$_[0]} = () }

sub count { scalar CORE::keys %{$_[0]} }

sub is_empty { scalar CORE::keys %{$_[0]} ? 0 : 1 }

sub accessor {
  if (@_ == 2) {
    $_[0]->{$_[1]};
  }
  elsif (@_ > 2) {
    $_[0]->{$_[1]} = $_[2];
  }
}

sub shallow_clone { blessed($_[0]) ? bless({%{$_[0]}}, ref $_[0]) : {%{$_[0]}} }

1;

__END__
==pod

=head1 SYNOPSIS

  use Data::Perl qw/hash/;

  my $hash = hash(a => 1, b => 2);

  $hash->values; # (1, 2)

  $hash->set('foo', 'bar'); # (a => 1, b => 2, foo => 'bar')


=head1 DESCRIPTION

  This class provides a wrapper and methods for interacting with a hash.

=head1 PROVIDED METHODS

=over 4

=item B<new($key, $value, ...)>

Given an optional list of keys/values, constructs a new Data::Perl::Collection::Hash
object initalized with keys/values and returns it.

=item B<get($key, $key2, $key3...)>

Returns values from the hash.

In list context it returns a list of values in the hash for the given keys. In
scalar context it returns the value for the last key specified.

This method requires at least one argument.

=item B<set($key =E<gt> $value, $key2 =E<gt> $value2...)>

Sets the elements in the hash to the given values. It returns the new values
set for each key, in the same order as the keys passed to the method.

This method requires at least two arguments, and expects an even number of
arguments.

=item B<delete($key, $key2, $key3...)>

Removes the elements with the given keys.

In list context it returns a list of values in the hash for the deleted
keys. In scalar context it returns the value for the last key specified.

=item B<keys>

Returns the list of keys in the hash.

This method does not accept any arguments.

=item B<exists($key)>

Returns true if the given key is present in the hash.

This method requires a single argument.

=item B<defined($key)>

Returns true if the value of a given key is defined.

This method requires a single argument.

=item B<values>

Returns the list of values in the hash.

This method does not accept any arguments.

=item B<kv>

Returns the key/value pairs in the hash as an array of array references.

  for my $pair ( $object->option_pairs ) {
      print "$pair->[0] = $pair->[1]\n";
  }

This method does not accept any arguments.

=item B<elements>

Returns the key/value pairs in the hash as a flattened list..

This method does not accept any arguments.

=item B<clear>

Resets the hash to an empty value, like C<%hash = ()>.

This method does not accept any arguments.

=item B<count>

Returns the number of elements in the hash. Also useful for not empty:
C<< has_options => 'count' >>.

This method does not accept any arguments.

=item B<is_empty>

If the hash is populated, returns false. Otherwise, returns true.

This method does not accept any arguments.

=item B<accessor($key)>

=item B<accessor($key, $value)>

If passed one argument, returns the value of the specified key. If passed two
arguments, sets the value of the specified key.

When called as a setter, this method returns the value that was set.

=item B<shallow_clone>

This method returns a shallow clone of the hash reference.  The return value
is a reference to a new hash with the same keys and values.  It is I<shallow>
because any values that were references in the original will be the I<same>
references in the clone.

=back

Note that C<each> is deliberately omitted, due to its stateful interaction
with the hash iterator. C<keys> or C<kv> are much safer.

=head1 SEE ALSO

=over 4

=item * L<Data::Perl>

=item * L<MooX::HandlesVia>

=back

=cut
