require 'GameScreens/FlowDownTextScreen'

CreditsScreen = class('CreditsScreen', FlowDownTextScreen)


local config=GameConfig.getInstance()


function CreditsScreen:initialize()

  local message="SPECIAL THANKS:\n"..
	 					"    with2balls.com\n"..
	 					"    David Antúnez Gonzalez\n\n"..
	 					"GRAPHIC DESIGNS:\n"..
	 					"    Angel Baltar Diaz\n"..
	 					"    opengameart.org\n\n"..
	 					"MUSIC AND SOUND:\n"..
	 					"    opengameart.org\n\n"..
	 					"GAME DESIGN:\n"..
	 					"    Angel Baltar Diaz\n\n"..
	 					"GAME PROGRAMMING:\n"..
	 					"    Angel Baltar Diaz\n\n"
    FlowDownTextScreen.initialize(self,message)
end 