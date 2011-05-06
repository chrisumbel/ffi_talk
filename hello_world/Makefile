CC			= gcc
LDFLAGS			= -O

SOURCES			= hello_world.c
OBJECTS			= $(SOURCES:.c=.o)

all:			libhelloworld.so

libhelloworld.so:	$(OBJECTS)
			$(CC) -fpic -shared  $(LDFLAGS) $^ -o $@

clean:
			@rm -f *.o *~ a.out \#*\#  core *.gch lib*.so
