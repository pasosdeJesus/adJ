

HTML and Text with project Gutenberg formatting standards.

Besides the usual tools (autodetected by the script conf.sh) the
following tools are required:
	C compiler, perl, tidy and w3m

From the sources directory do:
./conf.sh
make gutenberg

The resulting HTML and text will be in directory gutenberg.

If required, after that, to generate a distribution of sources:
GUT=1 make dist
