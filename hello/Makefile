CC			= gcc
LDFLAGS			= -O

SOURCES			= hello.c
OBJECTS			= $(SOURCES:.c=.o)

all:			libhello.so

libhello.so:		$(OBJECTS)
			$(CC) -fpic -shared  $(LDFLAGS) $^ -o $@

clean:
			@rm -f *.o *~ a.out \#*\#  core *.gch lib*.so
