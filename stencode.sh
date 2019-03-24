#!/bin/bash
#########################################
##             DISCLAIMER              ##
#########################################
##                                     ##
## THIS UTILITY PROVIDES ABSOLUTELY NO ##
## SECURITY ON DATA WHATSOEVER! ANY    ##
## DATA PROCESSED IS MERELY OBSCURED.  ##
##                                     ##
## IF YOU NEED YOUR DATA SECURED, USE  ##
## ANOTHER TOOL TO ENCRYPT IT BEFORE   ##
## USING THIS ONE!                     ##
##                                     ##
## With that being stated, feel free   ##
## modify this tool and add some sort  ##
## of pre-processing feature that      ##
## securely encrypts the data before   ##
## encoding.                           ##
##                                     ##
#########################################

###############################################################################
# Title : stencode                                                            #
# Vers. : 0.3                                                                 #
# Author: Evan Shipman (March 2019)                                           #
# Descr.: Apply basic steganography and disguise data using one of two        #
#         wordlists.                                                          #
###############################################################################

S_WORDS="./small-wordlist.txt"
L_WORDS="./large-wordlist.txt"

BYTE_ENCODE=false
WORD_ENCODE=false

SEP=" "

# Parse the command line flags
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in 
        # Handle each byte of input (using S_WORDS)
        -b|--byte)
            BYTE_ENCODE=true
            shift
            ;;
        # Handle each 16-bit word of input (using L_WORDS)
        -w|--word)
            WORD_ENCODE=true
            shift
            ;;
        # User-defined separators in the output
        -s|--separator)
            SEP="$2"
            shift
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done
set -- "%{POSITIONAL[@]}"

# Operate only on each individual byte
if [[ ${BYTE_ENCODE} = true ]]; then
    instream=""
    input=""
    # Read the input stream printing out each char/byte converted
    while read instream; do
        for i in $(seq 1 ${#instream}); do
            # Get the decimal number of the character/byte
            num="$(printf "%d" "'${instream:i-1:1}")"

            # Print that line of the file
            printf "%s" "$(head -${num} ${S_WORDS} | tail -1)"

            # Add the specified separator
            if [[ "${i}" -lt "${#instream}" ]]; then
                printf "%s" "${SEP}"
            fi
        done
    done
    printf "\n"
# Operate on each 16-bit word
elif [[ ${WORD_ENCODE} = true ]]; then
    echo "16-bit encoding not implemented yet"
else
    echo "Error: No valid encoding option given"
fi
