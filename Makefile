PREFIX  ?= /usr/local
bindir  ?= $(PREFIX)/bin
mandir  ?= $(PREFIX)/share/man
exadir  ?= $(PREFIX)/share/doc/whohas/examples
INSTALL ?= install

all: check

check:
	perl -wc whohas
	test "$$(sed -n 's/^.*distros[a-zA-Z]\+ = qw(\([^)]*\).*/\1/p' whohas)" = "$$(sed -n 's/^.*distro[a-zA-Z]\+ = qw(\([^)]*\).*/\1/p' whohas.cf)"

install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -m755 whohas $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(mandir)/man1
	$(INSTALL) -d $(DESTDIR)$(mandir)/de/man1
	$(INSTALL) -m644 usr/share/man/man1/whohas.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m644 usr/share/man/de/man1/whohas.1 $(DESTDIR)$(mandir)/de/man1
	$(INSTALL) -d $(DESTDIR)$(exadir)
	$(INSTALL) -m644 whohas.cf $(DESTDIR)$(exadir)

.PHONY: all install check
