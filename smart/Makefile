CC			= gcc
LDFLAGS			= -O

SOURCES			= smart.c
OBJECTS			= $(SOURCES:.c=.o)

all:			libsmart.so

libsmart.so:		$(OBJECTS)
			$(CC) -fpic -shared  $(LDFLAGS) $^ -o $@

clean:
			@rm -f *.o *~ a.out \#*\#  core *.gch lib*.so
