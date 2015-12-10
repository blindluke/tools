#!/usr/bin/perl

use warnings;
use v5.14;

# flog - log filter showing known lines only
# Copyright (C) 2015 blindluke

my $version = 'flog 0.5';

my $arg = shift;
if (defined $arg) {
    say $version and exit(0)  if ($arg eq '--version');
    print_usage() and exit(0) if ($arg eq '--help');
}
	
sub print_usage {
    say qq{
    flog - log filter showing known lines only

    Given a piped STDIN input, prints only known lines, and folds the
    rest of the input.  
    }; 
}

sub prep_patterns {
    my @patterns;
    local $/ = "";
    while (<DATA>) {
	s/\\\\/\n/;
	s/^(.*)\n//;
	push @patterns, { regex => qr/$1/, descr => "$_"}; 
    }
    return @patterns;
}

if (-p STDIN) {
    my $cnt = 0;
    my @patterns = prep_patterns();

    LINE: while (<STDIN>) {
	for my $p (@patterns) {
	    if (/$p->{regex}/) {
		say "[ $cnt unknown line(s) ]" unless ($cnt==0);
		print "\e[1m".$_."\e[0m";
		chomp $p->{descr};
		say "\e[3m    ".$p->{descr}."\e[0m";
		$cnt = 0;
		next LINE;
	    }
	}
	$cnt++;
    }
    say "[ $cnt unknown line(s) ]" unless ($cnt==0);
}
else {
    print_usage() and exit(1);
}


# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

__DATA__

\binstall\b
The package is about to be installed.

\bstatus installed\b
The package has been installed.
