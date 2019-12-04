NAME=game#

build:
	# TODO check existence of game.zip, throw error if it exists
	cd source; zip -r game .; mv game.zip ../$(NAME).love

run:
	 ~/Applications/love.app/Contents/MacOS/love game.love
