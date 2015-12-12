#!/usr/bin/perl

use warnings;
use v5.14;

# flog - log filter showing known lines only
# Copyright (C) 2015 blindluke

my $version = 'flog 0.8';

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

sub print_known_line {
    my $line = shift;
    $line =~ s/\R//g;
    say "\e[1m".$line."\e[0m";
}

sub print_description {
    my $line = shift;
    $line =~ s/\R//g;
    say "\e[2m    ".$line."\e[0m" if $line;
}

sub print_omitted_lines {
    my $cnt = shift;
    if ($cnt == 1) {
	say "[ $cnt unknown line  ]";
    }
    elsif ($cnt > 1) {
	say "[ $cnt unknown lines ]";
    }
    else {
	exit;
    }
}

if (-p STDIN) {
    my $cnt = 0;
    my @patterns = prep_patterns();

    LINE: while (<STDIN>) {
	for my $p (@patterns) {
	    if (/$p->{regex}/) {
		print_omitted_lines($cnt);
		print_known_line($_);
		print_description($p->{descr});
		$cnt = 0;
		next LINE;
	    }
	}
	$cnt++;
    }
    print_omitted_lines($cnt);
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

wlan\d+: associated
you successfully connected to a wireless network

Calling CRDA for country
CRDA is needed for regulatory compliance; some wifi channels aren't allowed in all countries

Kernel command line:
arguments as passed to the kernel from the bootloader

Calibrating delay loop
the benchmark units are completely bogus, but are used as a relative CPU speed indicator

Dentry hash table entries
dcache represents the kernel's view of the namespace of mounted filesystems

eth\d+: link is not ready
usually means the ethernet cable is disconnected

No NUMA configuration found
NUMA only matters if you have more than 1 CPU socket (cores do not matter)

\s[sh]d[a-z]:
layout of partitions, < > brackets denote an extended partition

usb-storage .+: USB Mass Storage device detected

Attached \w+ removable disk
the connected drive is now ready to use
