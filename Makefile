#
#  Synopsis:
#	Root makefile for setspace clients and spider environment.
#  Depends:
#	local.mk, derived from local-linux.mk.example  local-macosx.mk.example
#  Blame:
#  	jmscott@setspace.com
#  	setspace@gmail.com
#  Note:
#	The execution PATH must include the PostgreSQL C precompile 'ecpg'
#	for schema/drblob.  See schema/drblob/Makefile.
#
include local.mk

PROG=					\
	append-brr			\
	dec2pgbit			\
	flip-tail

all: $(PROG) $(CGI) 
	cd schema;  $(MAKE) all

clean:
	rm -f $(PROG) $(CGI)
	cd schema;  $(MAKE) clean

install: all

ifdef SETSPACE_PREFIX
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/bin
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/spool
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/sbin
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/schema
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/lib
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/etc
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
				-d $(SETSPACE_PREFIX)/src
	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
		boot-flowd						\
		cron-pg_dump-mutable					\
		cron-reboot						\
		dec2pgbit						\
		dev-reboot						\
		find-schema						\
		kill-flowd						\
		kill-all-flowd						\
		tail-flowd						\
		$(SETSPACE_PREFIX)/sbin

	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
		append-brr						\
		eat-blob						\
		flip-tail						\
		$(SETSPACE_PREFIX)/bin

	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER) 		\
		profile.example						\
		crontab.conf.example					\
		$(SETSPACE_PREFIX)/lib

	$(INSTALL) -g $(SETSPACE_GROUP) -o $(SETSPACE_USER)		\
		Makefile						\
		append-brr.c						\
		local-linux.mk.example					\
		local-macosx.mk.example					\
		$(SETSPACE_PREFIX)/src
	cd schema && make install
endif

append-brr: append-brr.c
	cc $(CFLAGS) -o append-brr append-brr.c

flip-tail: flip-tail.c
	cc -o flip-tail $(CFLAGS) flip-tail.c

dec2pgbit: dec2pgbit.c
	cc -o dec2pgbit $(CFLAGS) dec2pgbit.c

distclean:
#ifdef SETSPACE_PREFIX
	cd schema && make distclean
	rm -rf $(SETSPACE_PREFIX)/bin
	rm -rf $(SETSPACE_PREFIX)/lib
	rm -rf $(SETSPACE_PREFIX)/lib
	rm -rf $(SETSPACE_PREFIX)/src
	rm -rf $(SETSPACE_PREFIX)/sbin
#endif
