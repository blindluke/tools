#!/usr/bin/perl

use warnings;
use v5.14;

# gvn - git wrapper for svn people
# Copyright (C) 2015 blindluke

use IPC::Cmd qw[can_run run];
die 'git is not installed!' unless can_run('git');

my $opmode = shift;
print_usage() and exit(1) unless defined $opmode;

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

( $route{$opmode} || \&print_usage )->();

sub print_usage {
    say qq{
    gvn - a git wrapper for svn people

    gvn setup: rewrites the global config
    gvn init: mkdir, init and github link
    gvn update: does 'git pull origin master'
    gvn commit: does 'git push origin master'
    gvn status, gvn diff: behave as expected
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

sub setup {
    say "Current git global config:";
    system qq(git config --list);
    print "\n";
    my $user  = prompt("User name:");
    my $email = prompt("User email:");
    system qq(git config --global user.name "$user");
    system qq(git config --global user.email "$email");
    system qw(git config --global color.ui auto);
    say "\nAll done. Current git config:";
    system qq(git config --list);
}

sub init {
    my $repo = prompt("Repository name:");
    mkdir($repo) 
	or die "Failed to create $repo dir\n";
    chdir($repo)
	or die "Failed to change into $repo\n";
    0 == system('git', 'init')
	or die "Failed to initialize $repo repo\n";
    my $ghacc = prompt("GitHub account:");
    0 == system qq(git remote add origin https://github.com/${ghacc}/${repo}.git)
	or die "Failed to link repo with GitHub origin\n";
}

sub update {
    0 == system qw(git pull origin master)
	or die "Failed to pull from origin\n";
}

sub commit {
    my $msg = prompt("Commit message: ");
    0 == system qq(git commit -a -m "$msg")
	or die "Failed to commit to staging\n";
    0 == system qw(git push origin master)
	or die "Failed to push to origin\n";
}

sub add {
    0 == system qw(git add .)
	or die "Failed to add files\n";
}

sub status {
    for (`git -c color.ui=always status`) {
	s/\([^\)]+\)//;    # strip suggestions in brackets
	print if /\S/;     # omit blank lines
    }
}

sub diff {
    system qw(git diff);
}

sub log {
    system qw(git log);
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
