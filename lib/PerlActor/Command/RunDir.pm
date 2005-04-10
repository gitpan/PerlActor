package PerlActor::Command::RunDir;
use strict;

use base 'PerlActor::Command';

use PerlActor::Exception;
use File::Find;

my @TESTS;

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	my $dir = $self->getParam(0);
	
	throw PerlActor::Exception("cannot collect test scripts: directory '$dir' does not exist!")
		unless -e $dir;
		
	$self->buildTestList($dir);

	foreach my $test (@TESTS)
	{
		$self->executeScript($test);
	}
}

sub buildTestList
{	
	my ($self, $dir) = @_;	
	find({ wanted => sub {$self->processFile}, follow => 1 }, $dir);
}

sub processFile
{	
	my $self = shift;	
	my $file = $File::Find::name;

	return unless $self->fileIsAPerlActorTest($file);
	
	push @TESTS, $file;
	
}

sub fileIsAPerlActorTest
{
	my ($self, $file) = @_;
	return $file =~ m/\.pact$/;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
