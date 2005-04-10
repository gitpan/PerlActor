package PerlActor::Script;
use strict;
use base 'PerlActor::Object';
use fields qw( lines name currentLine currentLineNumber );
use Error qw( :try );

use PerlActor::CommandFactory;
use PerlActor::LineTokenizer;
use PerlActor::Exception::AssertionFailure;
use PerlActor::Exception::CommandFailed; 
use PerlActor::Exception::CommandAborted; 

#===============================================================================================
# Public Methods
#===============================================================================================

sub new
{
	my $proto = shift;
	my $self = $proto->SUPER::new(@_);
	$self->{name} = shift;
	$self->{lines} = [];
	$self->{context} = {};
	return $self;
}

sub setLines
{
	my $self = shift;
	my @lines = @_;
	$self->{lines} = \@lines;
}

sub getName
{
	my $self = shift;
	return $self->{name};
}

sub execute
{
	my $self = shift;
	$self->{listener}->scriptStarted($self);	

	$self->{currentLineNumber} = 0;
	try
	{
		foreach my $line (@{$self->{lines}})
		{
			chomp $line;
			$self->{currentLine} = $line;
			$self->{currentLineNumber}++;			
			my $command = $self->_parseLine($line);
			next unless $command;
			$self->executeCommand($command);
		}
		$self->{listener}->scriptPassed($self);		
		$self->{listener}->scriptEnded($self);
	}
	catch PerlActor::Exception::CommandFailed with
	{
		my $exception = shift;
		$self->{listener}->scriptFailed($self, $exception);
		$self->{listener}->scriptEnded($self);
	}
	catch PerlActor::Exception::CommandAborted with
	{
		my $exception = shift;
		$self->{listener}->scriptAborted($self, $exception);		
	};
}

sub executeCommand
{
	my $self = shift;
	my $command = shift;
	$command->setContext($self->{context});
	$command->setListener($self->{listener});
	$self->{listener}->commandStarted($self, $command);
	my $success;
	try
	{
		$command->execute();
		$self->{listener}->commandPassed($self, $command);				
		$self->{listener}->commandEnded($self, $command);	
	}
	catch PerlActor::Exception::AssertionFailure with
	{
		my $exception = shift;
		$self->{listener}->commandFailed($self, $command, $exception);
		$self->{listener}->commandEnded($self, $command);
		throw PerlActor::Exception::CommandFailed("$exception\n");
	}
	otherwise
	{
		my $exception = shift;
		$self->{listener}->commandAborted($self, $command, $exception);
		throw PerlActor::Exception::CommandAborted("$exception\n");
	};
}

sub parse
{
	my $self = shift;
	return $self->_parseLines(@{$self->{lines}});
}

sub getTraceInfo
{
	my $self = shift;
	my $name = $self->getName();
	return "in $name at '$self->{currentLine}', line $self->{currentLineNumber}";
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

sub _parseLines
{
	my $self = shift;
	my @lines = @_;
	my @commands;
	foreach my $line (@lines)
	{
		push @commands, $self->_parseLine($line);
	}
	return @commands;
}

sub _parseLine
{
	my ($self, $line) = @_;
	
	my $tokenizer = new PerlActor::LineTokenizer();
	my @tokens = $tokenizer->getTokens($line);

	return unless @tokens;
		
	my $factory = new PerlActor::CommandFactory();
	my $command = $factory->create(@tokens);
	
	return $command;
}

# Keep Perl happy.
1;
