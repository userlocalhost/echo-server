curdir = $(shell pwd)
targetdir = "$(curdir)/ebin"

all: ebin generic_server nonblocking_server

generic_server:
	erlc -o $(targetdir) src/$@.erl

nonblocking_server: ebin nonblocking_server
	erlc -o $(targetdir) src/$@.erl

ebin:
	mkdir $(targetdir)
