PREFIX  ?= /usr/local
bindir  ?= $(PREFIX)/bin
mandir  ?= $(PREFIX)/share/man
docdir  ?= $(PREFIX)/share/doc/whohas
exadir  ?= $(docdir)/examples
INSTALL ?= install
VERSION ?= 0.29.1
WH_PATH ?= ./

all: check

check:
	perl -wc whohas
	test "$$(sed -n 's/^.*distros[a-zA-Z]\+ = qw(\([^)]*\).*/\1/p' whohas)" = "$$(sed -n 's/^.*distro[a-zA-Z]\+ = qw(\([^)]*\).*/\1/p' whohas.cf)"

check-distros:
	status=0 ;\
	for distro in $$(sed -n 's/^.*distros[a-zA-Z]\+ = qw(\([^)]*\).*/\1/p' whohas) ; do \
	  echo -n "Checking $$distro... " ;\
	  lines=$$($(WH_PATH)whohas -d $$distro bash 2> /dev/null | wc -l) ;\
	  ret=$$? ;\
	  if [ 0 -eq $$lines -o $$ret -ne 0 ] ; then \
	    echo FAIL ;\
	    status=1 ;\
	  else \
	    echo OK ;\
	  fi ;\
	done ;\
	exit $$status

install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -m755 whohas $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(mandir)/man1
	$(INSTALL) -d $(DESTDIR)$(mandir)/de/man1
	$(INSTALL) -m644 usr/share/man/man1/whohas.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m644 usr/share/man/de/man1/whohas.1 $(DESTDIR)$(mandir)/de/man1
	$(INSTALL) -d $(DESTDIR)$(docdir)
	$(INSTALL) -m644 intro.html $(DESTDIR)$(docdir)
	$(INSTALL) -d $(DESTDIR)$(docdir)/html_assets
	$(INSTALL) -m755 html_assets/* $(DESTDIR)$(docdir)/html_assets
	$(INSTALL) -m644 README $(DESTDIR)$(docdir)
	$(INSTALL) -m644 NEWS $(DESTDIR)$(docdir)
	$(INSTALL) -m644 TODO $(DESTDIR)$(docdir)
	$(INSTALL) -d $(DESTDIR)$(exadir)
	$(INSTALL) -m644 whohas.cf $(DESTDIR)$(exadir)

release:
	gitk --all &
	echo '!!! Please summarize the release here one item per paragraph !!!' > NEWS.notes
	$$EDITOR NEWS.notes
	echo $(VERSION) > NEWS.new
	echo >> NEWS.new
	cat NEWS.notes >> NEWS.new
	echo >> NEWS.new
	cat NEWS >> NEWS.new
	mv NEWS.new NEWS
	sed -i '/^\.TH/s/"[0-9]\.[0-9.]\+"/"$(VERSION)"/' usr/share/man/man1/whohas.1 usr/share/man/de/man1/whohas.1
	git commit -m 'Release version $(VERSION)' NEWS usr
	git tag -s -a -F NEWS.notes $(VERSION)
	rm -f NEWS.notes
	GZIP= git archive --prefix=whohas-$(VERSION)/ -o whohas-$(VERSION).tar.gz $(VERSION)
	gpg --armour --detach-sign whohas-$(VERSION).tar.gz

.PHONY: all install check check-distros release
