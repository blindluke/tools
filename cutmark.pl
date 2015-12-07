#!/usr/bin/perl

use warnings;
use v5.14;

# cutmark - show a section of a markdown file
# Copyright (C) 2015 blindluke

my $version = 'cutmark 1.0';

my $header = lc(join ' ', @ARGV);
print_usage() and exit(1) unless $header;

sub print_usage {
    say qq{
    cutmark - show a section of a markdown file

    given a header name, shows only the section 
    under the specified header
    }; 
}

my @data;
if (-p STDIN) {
    local $/ = "";
    while (<STDIN>) {
	if (/^(.+)[ \t]*\n=+[ \t]*\n+/) {
	    push @data, { level => '1', content => $_ };
	}
	elsif (/^(.+)[ \t]*\n-+[ \t]*\n+/) {
	    push @data, { level => '2', content => $_ };
	}
	elsif (/^(\#{1,5})[ \t]*(.+?)[ \t]*\#*\n+/) {
	    push @data, { level => length($1), content => $_ };
	}
	else {
	    push @data, { level => 9, content => $_ };
	}
    }
}
else {
    say "You should provide content to filter piped on STDIN." and exit(1);
}

my $section_found = 0;
my $output = "";
PARAGRAPH: for my $p (@data) {
    if ($p->{'level'} < 9) {
	if ($section_found) {
	    if ($p->{'level'} > $section_found) {
		$output .= $p->{'content'};
	    }
	    else {
		last PARAGRAPH;
	    }
	}
	else {
	    if (lc($p->{'content'}) =~ /$header/) {
		$section_found = $p->{'level'};
		$output .= $p->{'content'};
	    }
	    else {
		next PARAGRAPH;
	    }
	}
    }
    else {
	if ($section_found) {
	    $output .= $p->{'content'};
	}
	else {
	    next PARAGRAPH;
	}
    }
}

print $output;

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
