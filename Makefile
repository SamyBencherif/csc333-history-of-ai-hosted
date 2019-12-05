# Please make necessary configurations, then fix .gitignore
NAME=game#

UNAME := $(shell uname)

WSLENV ?= notwsl
ifndef WSLENV
LOVE := /mnt/c/Program\ Files/LOVE/love.exe#
endif
ifeq ($(UNAME_S),Darwin)
LOVE := ~/Applications/love.app/Contents/MacOS/love#
endif

ZIP=zip#

build:
	# TODO check existence of game.zip, throw error if it exists
	cd source; $(ZIP) -r game .; mv game.zip ../$(NAME).love

run:
	$(LOVE) game.love
