PREFIX  ?= /usr/local
bindir  ?= $(PREFIX)/bin
mandir  ?= $(PREFIX)/share/man
INSTALL ?= install

all:

install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -m755 program/whohas $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(mandir)/man1
	$(INSTALL) -d $(DESTDIR)$(mandir)/de/man1
	$(INSTALL) -m644 usr/share/man/man1/whohas.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m644 usr/share/man/de/man1/whohas.1 $(DESTDIR)$(mandir)/de/man1

.PHONY: all install
