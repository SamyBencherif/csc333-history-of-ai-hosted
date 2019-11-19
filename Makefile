NAME=game#

build:
	# TODO check existence of game.zip, throw error if it exists
	cd source; zip -r game .; mv game.zip ../$(NAME).love

and:

run:
	-killall love # :'(
	sleep .3
	open game.love
    
