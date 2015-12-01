#!/usr/bin/perl

use warnings;
use v5.14;

# gvn - git wrapper for svn people
# Copyright (C) 2015 blindluke

my $opmode = shift;

my %route  = ( 
    setup  => \&setup,
    init   => \&init,
    update => \&update,
    up     => \&update,
    commit => \&commit,
    ci     => \&commit,
    add    => \&add,
    remove => \&remove,
    rm     => \&remove,
    status => \&status,
    stat   => \&status,
    diff   => \&diff,
    log    => \&log,
);

( $route{$opmode} || \&usage )->();

sub usage {
    say qq{
    gvn - a git wrapper for svn people

    gvn setup: rewrites the global config
    gvn init: mkdir, init and github link
    gvn update: does 'git pull origin master'
    gvn commit: does 'git push origin master'
    gvn status, gvn diff: behave as expected
    };
}

sub setup {
    say "TODO Performing the initial config.";
}

sub init {
    my $repo = 'test';
    mkdir($repo) 
	or die "Failed to create $repo dir\n";
    chdir($repo)
	or die "Failed to change into $repo\n";
    0 == system('git', 'init')
	or die "Failed to initialize $repo repo\n";
}

sub update {
    0 == system qw(git pull origin master)
	or die "Failed to pull from origin\n";
}

sub commit {
    0 == system qw(git commit)
	or die "Failed to commit to staging\n";
    0 == system qw(git push origin master)
	or die "Failed to push to origin\n";
}

sub add {
    0 == system qw(git add .)
	or die "Failed to add files\n";
}

sub status {
    system qw(git status);
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