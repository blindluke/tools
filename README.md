blindluke's tools
=================

This is a repository of small, self-contained, commandline scripts that
make my Debian box a nice place to live in.

Requirements
------------

All of the scripts require at least Perl 5.14, due to the `use v5.14;`
pragma used. This is more of a habit thing than an actual requirement,
as it's easier for me to type in `use v5.14;` than to type in `use
strict;`. So, if you want to party like it's 1999, you can probably
make them run on your Perl of choice.

Scripts
-------

### gvn - git wrapper for svn cavemen

**gvn** is a git wrapper that makes it simple for simple minded
people like myself. The aim is to make its usage as similar to
`bzr`/`svn` as possible, with some additional features on top.

**gvn init** asks for reponame, creates reponame dir, initializes an
empty repo in the directory and links it to github.

**gvn update** does `pull origin master`.

**gvn commit** does `commit` and `push origin master`, asking for the
commit message beforehand.

**gvn add** behaves as expected (as do remove, status, diff and log).

### 2mon - xrandr wrapper for a two screen setup

**2mon** does some initial guesswork and then runs

    xrandr --output DP1 --mode 1920x1200 --left-of LVDS1

or something like the line above, depending on the guesswork.  The
value for `--output` is the other connected screen (DP, HDMI, VGA),
value for `--mode` is the maximum supported resolution, and the
direction depends on the argument given to **2mon** (left or right).

Running `2mon info` shows a short summary of the connected screens.

### cutmark - show a section o a markdown file

**cutmark** operates as a filter on markdown formatted input. Given a
section (markdown header) name, it prints out only the section
matching the name given. It supports headers up to level five, with
both allowed styles.

An example of usage using this `README.md` as input:

    $ cat README.md | cutmark autho
    Author
    ------
    
    Luke <https://github.com/blindluke>


Author
------

Luke <https://github.com/blindluke>

License
-------

See the LICENSE file for license rights and limitations (GNU GPL v3).
