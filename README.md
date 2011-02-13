This directory acts as a  replacement for the original MultiMarkdown directory
from version 2.0.

MMD version 3 is  a single binary, but for more  complicated setups some users
may like to use the XSLT features from version 2 for more customization.

For  now, this  feature  is unsupported,  and for  "experts  only." Once  it's
finished,  the instructions  will be  improved, and  I will  be able  to offer
better support for it.

In general, the scripts  in `bin` act as shortcuts to  the binary with certain
command-line options to  emulate the behavior of the  old convenience scripts.
The files  in `XSLT` are  modifications to the  original XSLT files  that work
with MMD version 3. So now, in fact,  there are two routes to convert MMD into
LaTeX --- one is to use `multimarkdown -t  latex`, and the other is to use the
`mmd2xslt` script to convert MMD into XHTML and then into LaTeX by applying an
XSLT  file. This  second  route  is significantly  slower,  and slightly  more
complicated, and requires that the XSLT files  be in the right place; it does,
however, offer a greater level of customization for MultiMarkdown "experts."

These shell scripts will run on Mac OS X or *nix.

To use them on a Mac with  Scrivener, TextMate, or other applications that use
the "Common" installation, simply rename this directory to `MultiMarkdown` and
place it in an appropriate location:

* ~/Library/Application Support/MultiMarkdown
* /Library/Application Support/MultiMarkdown

