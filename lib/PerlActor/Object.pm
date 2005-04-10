package PerlActor::Object;
use fields qw( listener context );
use strict;

#===============================================================================================
# Public Methods
#===============================================================================================

sub new
{
	my $proto = shift;
	my $class = ref $proto || $proto;
	my $self = fields::new($class);
	return $self;
}

sub setListener
{
	my $self = shift;
	$self->{listener} = shift;
}

sub setContext
{
	my $self = shift;
	$self->{context} = shift;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
