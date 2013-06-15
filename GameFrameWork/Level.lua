require 'Utils/middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Enemies/RomulanScout'
require 'GameFrameWork/Harvestables/HealthObject'
local loader = require("Utils/Advanced-Tiled-Loader/Loader")

 -- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
loader.path = "Resources/maps/"

Level = class('GameFrameWork.Level')

--constructor
function Level:initialize(map_name,space)
	local object_type=""
	local imagePath=""
	local quad=nil
	local obj=nil
	local processed_tiles={}

	self._map=loader.load(map_name)
	for x, y, tile in self._map("primer_plano"):iterate() do
		
		--avoid repeated tiles
		if processed_tiles[y*self._map.width+x]==nil then
			object_type=tile.tileset.properties["object_type"]
			imagePath=tile.tileset.imagePath
	   		--print( string.format("Tile at (%d,%d) has an id of %d %s %s",
	   		--				x, y, tile.id,object_type,imagePath) )
			if object_type=="RomulanScout" then
				obj=RomulanScout:new(space)
				obj:setPosition(self._map.tileWidth*x,self._map.tileHeight*y)

			elseif object_type=="DestructorKlingon" then
				obj=PlayerShip:new(space)
				obj:setPosition(self._map.tileWidth*x,self._map.tileHeight*y)
			elseif object_type=="HealthObject" then
				obj=HealthObject:new(space)
				obj:setPosition(self._map.tileWidth*x,self._map.tileHeight*y)
			end
			processed_tiles[y*self._map.width+x]=true
		end
		
	end
end
