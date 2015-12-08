#!/usr/bin/perl

use warnings;
use v5.14;

# apt-dwim - apt wrapper
# Copyright (C) 2015 blindluke

use IPC::Cmd qw[can_run run];
die "Cannot run apt-get!\n" unless can_run('apt-get');

sub print_usage {
    say qq{
    apt-dwim - apt wrapper

    given an argument, it runs a check, and:
    - if the arg is an existing .deb file, it shows info about the package
    - if the arg is an existing file, shows what package it belongs to
    - if the arg is a nonexistant path, shows what package would provide it
    - when the arg does not look like a path, runs apt-cache search on it
    - if the arg looks like update, check, autoclean, it passes the arg to apt-get
    };
}

my $arg = shift;
print_usage() and exit(1) unless defined $arg;

for ($arg) {
    if    (/\.deb$/)    { system qq/dpkg --info $arg/; }
    elsif (/check/)     { system qw/apt-get check/; }
    elsif (/update/)    { system qw/apt-get update/; }
    elsif (/upgrade/)   { system qw/apt-get upgrade/; }
    elsif (/autoclean/) { system qw/apt-get autoclean/; }
    elsif (/\/\w/) {
        if (-e $arg) {
            say "Searching for the package that provided $arg...";
            system qq/dpkg --search $arg/;
        }
        else {
            # nonexistant file - check what package would provide it
            die "Cannot run apt-file - this is needed to find out which package contains $arg.\n"
                unless can_run('apt-file');
            say "Searching for the package that would provide $arg...";
            system qq/apt-file search $arg/;
        }
    }
    else {
        # non-path non-deb argument treated as search string
        die "Cannot run apt-cache - this is needed to search for $arg.\n"
            unless can_run('apt-cache');
        say "Searching for $arg using apt-cache...";
        system qq/apt-cache search $arg/;
    }
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
