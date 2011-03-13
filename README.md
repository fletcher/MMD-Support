This directory  acts as a  replacement for the original  MultiMarkdown "Common
Installation" directory  from version  2.0. MultiMarkdown  itself is  a single
binary, and there are  also a couple of utility scripts  that are installed to
simplify  things  (`mmd`,  `mmd2tex`,   `mm2opml`,  `mmd2odf`).  This  support
installation adds a  few more utility scripts in the  `bin` directory. It also
adds support for using XSLT to  customize the LaTeX output from MultiMarkdown,
or to customize other output formats.

Most  users do  not need  to use  XSLT to  achieve their  desired output  from
MultiMarkdown, but it's always an option.

More importantly,  this package will replace  the scripts used in  the "Common
Installation" to allow programs like  Scrivener and TextMate to interface with
MultiMarkdown 3.0.


In general, the scripts  in `bin` act as shortcuts to  the binary with certain
command-line options to  emulate the behavior of the  old convenience scripts.
The files  in `XSLT` are  modifications to the  original XSLT files  that work
with MMD version 3. So now, in fact,  there are two routes to convert MMD into
LaTeX --- one is to use `multimarkdown -t  latex`, and the other is to use the
`mmd2tex-xslt`  script to  convert  MMD  into XHTML  and  then  into LaTeX  by
applying an XSLT file. This second route is significantly slower, and slightly
more complicated, and requires  that the XSLT files be in  the right place; it
does,  however,  offer a  greater  level  of customization  for  MultiMarkdown
"experts."

These shell scripts will  run on Mac OS X or *nix. I  suppose they will run on
Windows with the proper  support files installed. I will leave  this up to the
user.

To   install  on   a  Mac,   simply  download   the  MultiMarkdown-Support-Mac
[installer]. It will place the directory in the proper location.

[installer]: https://github.com/fletcher/peg-multimarkdown/downloads
