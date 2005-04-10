package PerlActor;

use 5.008006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


# Preloaded methods go here.

1;
__END__

=head1 NAME

PerlActor - A simple automated executable acceptance test framework for Perl

=head1 DESCRIPTION

PerlActor is a simple automated executable acceptance test framework
for Perl.  It can be used by Extreme Programming (XP) teams to rapidly
develop executable acceptance tests for their Perl code.

XP mandates that the Customer writes acceptance tests for the application
under development.  The acceptance tests, also known as customer tests,
demonstrate that application features are complete and that they work as
expected.  Ideally, the tests should be directly executable and
automated so that they can be run continuously, without manual effort.

PerlActor enables an XP Customer to write *executable* acceptance
tests as plain text files, using a very simple syntax. Each test consists
of a number of parameterized commands (one per line), which PerlActor
uses to exercise the application. PerlActor parses the test, invokes the
commands with any parameters, and reports the result. The developers provide
glue code to implement the commands required by the tests.

PerlActor allows tests to be grouped into suites so that related tests can be
run as a group.  The Customer can also just place test scripts in a directory
structure and have PerlActor find and execute them all.

The PerlActor approach to acceptance testing has a number of advantages:

1) As the application grows the team will gradually develop a
comprehensive set of Commands for testing the application.

2) The Customer, independent of the development team, can write and execute
new tests for the application at any time, using any of the existing 
Commands.

3) Existing tests may be changed by the Customer at any time, again
without developer help.


=head1 EXAMPLE SCRIPT

The following sample test script is adapted from one of the example
scripts contained in the 'examples/calculator' directory of this
distribution.  It tests a toy calculator "application":

    # Script to check addition
    # 10 + 32 = 42

    # Create a new calculator application
    NewCalculator

    # Ensure that the display reads '0' intially
    CheckDisplayReads  0

    # Press key '1', then key '0'
    PressKeys          1  0
    CheckDisplayReads  10

    PressKeys          +
    CheckDisplayReads  10

    PressKeys          3  2
    CheckDisplayReads  32

    PressKeys          =
    CheckDisplayReads  42


The following is sample output from the included test runner:

    Running Acceptance Tests at Sun Apr 10 17:59:11 GMT 2005
    ==========================================================
    .....
    0.545077 wallclock secs ( 0.42 usr +  0.11 sys =  0.53 CPU)
    Run: 5, Passed: 5, Failed: 0, Aborted: 0.

and with test failure:

    Running Acceptance Tests at Sun Apr 10 18:04:36 GMT 2005
    ==========================================================
    .F...
    1.24811 wallclock secs ( 0.47 usr +  0.07 sys =  0.54 CPU)
    Run: 5, Passed: 4, Failed: 1, Aborted: 0.

    !!!FAILED!!!

    1) FAILED: 'Display is wrong: expected 41, got 42' in scripts/test_addition.pact
    at 'CheckDisplayReads  41', line 37


=head1 CREDITS

PerlActor is inspired by a similar open source framework for Java called 
'exactor' published by eXoftware [see http://exactor.sourceforge.net/].

=head1 SEE ALSO

PerlActor is very basic at present, and as you will no doubt have noticed,
the documentation is somewhat lacking.  This will change very soon.

In the meantime the PerlActor distribution comes with a simple example
showing how the framework is used for acceptance testing.  You'll find
it in the 'examples' directory of the distribution.

=head1 AUTHOR

Tony Byrne, E<lt>perl@byrnehq.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Tony Byrne

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
