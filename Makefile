CMD      = @

VERSION  = 0.1.0
NAME     = mebs
SRC      = util.c conn.c list.c gemini.c history.c ui.c tabs.c tbrl.c
SRC3     = third_party/strlcpy.c third_party/curl/url.c \
	   third_party/curl/escape.c third_party/termbox/src/termbox.c \
	   third_party/termbox/src/utf8.c
OBJ      = $(SRC:.c=.o)
OBJ3     = $(SRC3:.c=.o)

WARNING  = -Wall -Wpedantic -Wextra -Wold-style-definition -Wmissing-prototypes \
	   -Winit-self -Wfloat-equal -Wstrict-prototypes -Wredundant-decls \
	   -Wendif-labels -Wstrict-aliasing=2 -Woverflow -Wformat=2 -Wtrigraphs \
	   -Wmissing-include-dirs -Wno-format-nonliteral -Wunused-parameter \
	   -Wincompatible-pointer-types \
	   -Werror=implicit-function-declaration -Werror=return-type

DEF      = -DVERSION=\"$(VERSION)\" -D_XOPEN_SOURCE=1000 -D_DEFAULT_SOURCE
INCL     = -I ~/local/include -Ithird_party/ -Ithird_party/termbox/src
CC       = clang
CFLAGS   = -Og -g $(DEF) $(INCL) $(WARNING) -funsigned-char
LD       = bfd
LDFLAGS  = -fuse-ld=$(LD) -L/usr/include -lm -ltls

UTF8PROC = ~/local/lib/libutf8proc.a

.PHONY: all
all: $(NAME)

.PHONY: run
run: $(NAME)
	$(CMD)./$(NAME)

%.o: %.c
	@printf "    %-8s%s\n" "CC" $@
	$(CMD)$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ): gemini.h
main.c: commands.c config.h
ui.o:   config.h

$(NAME): $(OBJ) $(OBJ3) $(UTF8PROC) main.c
	@printf "    %-8s%s\n" "CCLD" $@
	$(CMD)$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)

.PHONY: clean
clean:
	rm -rf $(NAME) $(OBJ) tests

.PHONY: deepclean
deepclean: clean
	rm -rf $(OBJ3)
