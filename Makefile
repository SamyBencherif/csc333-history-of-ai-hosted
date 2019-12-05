# Please make necessary configurations, then fix .gitignore
NAME=game#
LOVE=/mnt/c/Program\ Files/LOVE/love#
ZIP=zip#

build:
	# TODO check existence of game.zip, throw error if it exists
	cd source; $(ZIP) -r game .; mv game.zip ../$(NAME).love

run:
	$(LOVE) game.love
