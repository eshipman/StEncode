# StEncode

THIS TOOL PROVIDES ABSOLUTELY NO SECURITY IN ITS CURRENT STATE!
This tool merely disguises data, it does nothing to encrypt it. If you need to
keep your data secure, please use another tool to encrypt it beforehand.

StEncode is a simple steganographic tool for use on Unix/Linux systems. It
reads from standard input and outputs each block of data encoded as an index in
a wordfile. Currently, only 8-bit blocks are supported.

Encoding mechanisms:
    8-bit encoding:
        Each character input is converted to its numeric ASCII value and the
        word located on that numbered line in small-wordlist.txt is output for
        that byte.

Issues:
    8-bit encoding:
        - Non-printing ASCII characters do not work correctly. Only printing
          ASCII text currently works.
