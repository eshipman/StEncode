#ifndef STENCODE_C
#define STENCODE_C

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "small-wordlist.h"

/* Macro to check for two possible flag representations */
#define IS_FLAG(opt1, opt2) (                           \
    (strncmp(argv[i], opt1, strlen(opt1)) == 0 ||       \
    strncmp(argv[i], opt2, strlen(opt2)) == 0) ? 1 : 0  \
)

int main(int argc, char **argv)
{
    /*
     * BYTE_ENCODE - use the 8-bit encoding scheme
     * WORD_ENCODE - use the 16-bit encoding scheme
     * ENCODE - whether or not to be in encoding mode
     * SEP - the separator between output words
     * filename - the input filename
     */
    int BYTE_ENCODE = 0,
        WORD_ENCODE = 0,
        ENCODE = 1;
    char *SEP = NULL,
         *filename = NULL;

    /* ----- BEGIN FLAG READING ----- */
    /* Read the flags and set options accordingly */
    for (int i = 1; i < argc; i++) {
        if (IS_FLAG("-b", "--byte")) {
            BYTE_ENCODE = 1;
        } else if (IS_FLAG("-w", "--word")) {
            WORD_ENCODE = 1;
        } else if (IS_FLAG("-s", "--separator")) {
            SEP = argv[i++];
            /*
            SEP = (char*) malloc(sizeof(char) * strlen(argv[i++]));
            strncpy(SEP, argv[i], strlen(argv[i]));
            */
        } else if (IS_FLAG("-d", "--decode")) {
            ENCODE = 0;
        } else if (IS_FLAG("-f", "--file")) {
            filename = argv[++i];
        } else {
            fprintf(stderr, "Error: invalid option '%s'\n", argv[i]);
        }
    }
    /* ----- END FLAG READING ----- */

    /* ----- BEGIN FLAG VALIDATION ----- */
    if (BYTE_ENCODE && WORD_ENCODE) {
        fprintf(stderr, "Error: only one encoding scheme may be used at a time\n");
    } else if (!BYTE_ENCODE && !WORD_ENCODE) {
        fprintf(stderr, "Error: please specify an encoding scheme\n");
    }

    if (filename == NULL)
        fprintf(stderr, "Error: no input file specified\n");

    if (SEP == NULL) {
        SEP = (char*) malloc(sizeof(char));
        *SEP = ' ';
    }
    /* ----- END FLAG VALIDATION ----- */

    unsigned int file_size,
                 input_size;
    FILE *fp;
    char *input;

    fp = fopen(filename, "r");

    /* Get the file size */
    fseek(fp, 0L, SEEK_END);
    file_size = ftell(fp);
    rewind(fp);

    /* Fill the input array */
    input_size = file_size / sizeof(char);
    input = (char*) malloc(input_size);
    memset(input, 0, input_size * sizeof(char));
    fread(input, sizeof(char), input_size, fp);

    if (ENCODE) {
        /* Output the encoded version terminated by a newline */
        for (int i = 0; i < input_size - 1; i++)
            printf("%s%s", S_WORDS[(unsigned char) input[i] - 1], SEP);
        printf("%s\n", S_WORDS[(unsigned char) input[input_size - 1] - 1]);
    }

    return 0;
}

#endif
