#!/usr/bin/perl

use warnings;
use v5.14;

# 2mon - randr wrapper for a 2 screen setup
# Copyright (C) 2015 blindluke

my $version = '2mon 0.5';

use IPC::Cmd qw[can_run run];
die 'xrandr is not installed!' unless can_run('xrandr');

my $opmode = shift;
print_usage() and exit(1) unless defined $opmode;

my %route  = (
    '--version' => sub { say $version; },
    '--help'    => \&print_usage,
    info        => \&info,
    left        => sub { setup("left-of") },
    right       => sub { setup("right-of") },
);

( $route{$opmode} || \&print_usage )->();

sub print_usage {
    say qq{
    2mon - randr wrapper for a 2 screen setup

    2mon info  - show info about detected screens
    2mon left  - setup with second screen on the left
    2mon right - setup with second screen on the right
    };
}

sub prompt {
    my $msg = shift;

    local $| = 1;
    local $\;
    say $msg;

    my $ans = <STDIN>;
    defined $ans ? chomp $ans : say;
    return $ans;
}

sub detect {
    my $output = `xrandr`;
    my %screens = $output =~ /([A-Z0-9]+)\s+connected[^\n]+\s+([^\s]+)/g;
    return %screens;
}

sub info {
    my %screens = detect();
    say 'Screens connected:';
    for (keys %screens) {
	say "  $_ with max available resolution of $screens{$_}";
    }
}

sub setup {
    my $direction = shift;
    my %screens = detect();

    if (keys %screens != 2) {
        say "This script works when exactly two screens are connected.";
        say "Run 2mon info to see info about connected screens.";
        exit(1);
    }
    else {
        for (keys %screens) {
            next if /LVDS1/;
            0 == system qq(xrandr --output $_ --mode $screens{$_} --$direction LVDS1)
                or die "Failed to execute xrandr.\n";
        }
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
