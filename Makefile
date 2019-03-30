# Usage:
# make			# Compile the project
# make clean	# Remove all compiled binaries


CC = gcc
LIBS = 
FLAGS = -Wall -O3

all: stencode.c
	${CC} ${FLAGS} -o stencode stencode.c ${LIBS}

clean:
	rm -f stencode
