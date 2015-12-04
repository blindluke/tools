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
    
    # TODO check if there is another screen connected

    # TODO output,mode should match screen other than LVDS1
    say "Will run: xrandr --output DP1 --mode 1920x1200 --$direction LVDS1";
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
