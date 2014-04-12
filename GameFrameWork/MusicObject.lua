-- /* RenegadeKlingon - LÖVE2D GAME
-- /* RenegadeKlingon - LÖVE2D GAME
--  * MusicObject.lua
--  * Copyright (C) Angel Baltar Diaz
--  *
--  * This program is free software: you can redistribute it and/or
--  * modify it under the terms of the GNU General Public
--  * License as published by the Free Software Foundation; either
--  * version 3 of the License, or (at your option) any later version.
--  *
--  * This program is distributed in the hope that it will be useful,
--  * but WITHOUT ANY WARRANTY; without even the implied warranty of
--  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  * General Public License for more details.
--  *
--  * You should have received a copy of the GNU General Public
--  * License along with this program.  If not, see
--  * <http://www.gnu.org/licenses/>.
--  */
require 'GameFrameWork/SpaceObject'
require 'Utils/Debugging'
require 'Utils/GameConfig'

MusicObject = class('GameFrameWork.MusicObject',SpaceObject)

local _sounds_map={}

_sounds_map["map1.tmx"]={}

_sounds_map["map1.tmx"][0]=love.audio.newSource('Resources/sfx/map1.mp3',"static")
_sounds_map["map1.tmx"][1]=love.audio.newSource('Resources/sfx/hold_the_line.mp3',"static")
--_sounds_map["map1.tmx"][1]=love.audio.newSource('Resources/sfx/explosion2.mp3',"static")

--constructor
--draw_object must be a drawable
--posx and posy define the initial positions for the object
function MusicObject:initialize(space,tile,posx,posy,map,music_number)

 self._is_playing=false
 self._source=_sounds_map[map][music_number]
 
 SpaceObject.initialize(self,space, tile,posx,posy,2000)

end

--return the width of this ship
function MusicObject:getWidth()
	return 0
end

--return the height of this ship
function MusicObject:getHeight()
	return 0
end


function MusicObject:die()

  DEBUG_PRINT("Music dies")
  SpaceObject.die(self)

end

--updates play music
function MusicObject:pilot(dt)
    
   
    local pilot=SpaceObject.isEnabled(self)
    if(not pilot) then
      SpaceObject.pilot(self,dt)
      return
    end

    if(not self._is_playing) then
      
       local space=SpaceObject.getSpace(self)
       local actual_playing=space:getMusicObject()
 
       if(actual_playing~=nil) then
          actual_playing:die()
       end
       space:setMusicObject(self)
       love.audio.stop()
       self._source:play()
--     self._source:setVolume(self._source:getVolume()/2)
       self._source:setLooping(true)
       self._is_playing=true
    end
   
end

--Draws the object in the screen
function MusicObject:draw()

end

function MusicObject:isMusicObject()
  return true
end