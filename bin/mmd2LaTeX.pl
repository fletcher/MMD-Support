#!/bin/sh

# Pass arguments on to the binary to convert to LaTeX
/usr/local/bin/multimarkdown -b -t latex $@
