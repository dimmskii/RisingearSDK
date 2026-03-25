# Platform name
# allowed values are: 'linux' and 'win'
LAUN_PLATFORM ?= win

# Compile settings
ifeq ($(LAUN_PLATFORM), win)
	LAUN_CC ?= i686-w64-mingw32-gcc
	LAUN_OPTS ?= -m32 -O0 -I/usr/share/mingw-w64/include
	LAUN_PRECMD ?= i686-w64-mingw32-windres winres.rc winres.o
	LAUN_OBJS ?= winres.o
endif
LAUN_CC ?= gcc
LAUN_OPTS ?= -m32 -O0
LAUN_PRECMD ?= echo
LAUN_OBJS ?= 

all: client dedicated
	
clean:
	$(shell rm -rf dist/*)
client:
	$(shell $(LAUN_PRECMD))
	$(shell mkdir dist)
	$(LAUN_CC) -g -Wall -std=gnu99 $(LAUN_OPTS) \
		platform_$(LAUN_PLATFORM).c \
		main.c \
		-o dist/launcher_$(LAUN_PLATFORM) $(LAUN_OBJS)
dedicated:
	$(shell mkdir dist)
	$(LAUN_CC) -Ddedicated -g -Wall -std=gnu99 $(LAUN_OPTS) \
		platform_$(LAUN_PLATFORM).c \
		main.c \
		-o dist/dedicated_$(LAUN_PLATFORM) $(LAUN_OBJS)
