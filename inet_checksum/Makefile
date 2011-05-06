CC			= gcc
LDFLAGS			= -O

SOURCES			= inet_checksum.c
OBJECTS			= $(SOURCES:.c=.o)

all:			libinetchecksum.so

libinetchecksum.so:	$(OBJECTS)
			$(CC) -fpic -shared  $(LDFLAGS) $^ -o $@

clean:
			@rm -f *.o *~ a.out \#*\#  core *.gch lib*.so
