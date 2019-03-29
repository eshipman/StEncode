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

# Encode by default but don't choose a default encoding scheme
ENCODE=true
BYTE_ENCODE=false
WORD_ENCODE=false

# The default output separator is a space
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
        -d|--decode)
            ENCODE=false
            shift
            ;;
        -db|-bd)
            ENCODE=false
            BYTE_ENCODE=true
            shift
            ;;
        -dw|-wd)
            ENCODE=false
            WORD_ENCODE=true
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done
set -- "%{POSITIONAL[@]}"

# Encode the input
if [[ ${ENCODE} == true ]]; then

    # Operate only on each individual byte
    if [[ ${BYTE_ENCODE} == true && ${WORD_ENCODE} == false ]]; then
        # Read the input stream exactly, printing out each char/byte converted
        instream=$(</dev/stdin)
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

        # Manually print an ending newline character
        # Temporary solution until a cleaner one is written
        printf "${SEP}%s" "$(head -10 ${S_WORDS} | tail -1)"

    # Operate on each 16-bit word
    elif [[ ${WORD_ENCODE} == true && ${BYTE_ENCODE} == false ]]; then
        echo "16-bit encoding not implemented yet"
    elif [[ ${WORD_ENCODE} == true && ${BYTE_ENCODE} == true ]]; then
        echo "Error: Only one encoding scheme may be used at a time"
    else
        echo "Error: No valid encoding given"
    fi

# Decode the input
else
    # Decode each word as 1 byte
    if [[ ${BYTE_ENCODE} == true && ${WORD_ENCODE} == false ]]; then
        # Separate each line into an array of words and loop through it
        instream=$(</dev/stdin)
        arr=( $instream )
        for i in $(seq 0 $((${#arr[@]} - 1))); do
            # Get the index of the word from the file
            index="$(grep -En "^${arr[${i}]}$" "${S_WORDS}" | cut -d ':' -f1)"

            # Alert the user if a word couldn't be found in the word list
            if [[ "${index}" == "" ]]; then
                printf "Error: could not decode word '%s'\n" "${arr[${i}]}"
            # Otherwise print the ASCII character
            else
                printf "\x$(printf %x ${index})"
            fi
        done
    elif [[ ${WORD_ENCODE} == true && ${BYTE_ENCODE} == false ]]; then
        echo "16-bit decoding not implemented yet"
    elif [[ ${WORD_ENCODE} == true && ${BYTE_ENCODE} == true ]]; then
        echo "Error: Only one encoding scheme may be used at a time"
    else
        echo "Error: No valid encoding scheme given"
    fi
fi
