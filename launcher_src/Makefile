# Platform name
# allowed values are: 'linux' and 'win'
LAUN_PLATFORM ?= win

# Compile settings
ifeq ($(LAUN_PLATFORM), win)
	LAUN_CC ?= x86_64-w64-mingw32-gcc
	LAUN_OPTS ?= -O0 -I/usr/share/mingw-w64/include
	LAUN_PRECMD ?= x86_64-w64-mingw32-windres winres.rc winres.o
	LAUN_OBJS ?= winres.o
endif
LAUN_CC ?= gcc
LAUN_OPTS ?= -O0
LAUN_PRECMD ?= echo
LAUN_OBJS ?= 

all: client dedicated
	
clean:
	$(shell rm -rf $(LAUN_PLATFORM))
client:
	$(shell $(LAUN_PRECMD))
	$(shell mkdir $(LAUN_PLATFORM))
	$(LAUN_CC) -g -Wall -std=gnu99 $(LAUN_OPTS) \
		platform_$(LAUN_PLATFORM).c \
		main.c \
		-o $(LAUN_PLATFORM)/launcher $(LAUN_OBJS)
dedicated:
	$(shell mkdir $(LAUN_PLATFORM))
	$(LAUN_CC) -Ddedicated -g -Wall -std=gnu99 $(LAUN_OPTS) \
		platform_$(LAUN_PLATFORM).c \
		main.c \
		-o $(LAUN_PLATFORM)/dedicated $(LAUN_OBJS)
