# Please make necessary configurations, then fix .gitignore
NAME=game#
LOVE=~/Applications/love.app/Contents/MacOS/love#
ZIP=zip#

build:
	# TODO check existence of game.zip, throw error if it exists
	cd source; $(ZIP) -r game .; mv game.zip ../$(NAME).love

run:
	$(LOVE) game.love
