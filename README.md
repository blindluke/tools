Blindluke's tools
=================

This is repository of small, self-contained, commandline scripts that
make my Debian box a nice place to live in.

Requirements
------------

All of the scripts require at least Perl 5.14, due to the `use v5.14;`
pragma used. This is more of a habit thing than an actual requirement,
as it's easier for me to type in `use v5.14;` than to type in `use
strict;`. So, if you want to party like it's 1999, you can probably
make them run on your Perl of choice.

gvn - git wrapper for svn cavemen
---------------------------------

**gvn.pl** is a git wrapper that makes it simple for simple minded
people like myself. The aim is to make its usage as similar to
`bzr`/`svn` as possible, with some additional features on top.

### USAGE ###

**gvn init** asks for reponame, creates reponame dir, initializes an
empty repo in the directory and links it to github.

**gvn update** does `pull origin master`.

**gvn commit** does `commit` and `push origin master`, asking for the
commit message beforehand.

**gvn add** behaves as expected (as do remove, status, diff and log).

Author
------

Luke <https://github.com/blindluke>

License
-------

See the LICENSE file for license rights and limitations (GNU GPL v3).
