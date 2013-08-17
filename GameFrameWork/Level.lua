require 'Utils/middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/Enemies/RomulanScout'
require 'GameFrameWork/Enemies/RomulanNorexan'
require 'GameFrameWork/Enemies/RomulanWarBird'
require 'GameFrameWork/Harvestables/HealthObject'
require 'GameFrameWork/Harvestables/WeaponObject'
require 'GameFrameWork/TileBlocks/TileBlock'
require 'GameFrameWork/TileBlocks/MineBlock'
require 'Utils/Debugging'

local loader = require("Utils/Advanced-Tiled-Loader/Loader")

 -- Path to the tmx files. The file structure must be similar to how they are saved in Tiled
loader.path = "Resources/maps/"

function load_level(map_name,space)
	local object_type=""
	local imagePath=""
	local quad=nil
	local obj=nil
	local processed_tiles={}
	local step_bg=1
	local n_bgs=4

	local map=loader.load(map_name)
	local ordered_paths={}
	local max_x=0
	--backgrounds
	for x, y, tile in map("fondo"):iterate() do
		ordered_paths[x]=tile.properties["img_path"]
	end
	for _,path in pairs(ordered_paths) do
		space:addBackGroundImage(path)
	end
	--all plane objects
	for plane=1,n_bgs do
		--DEBUG_PRINT("plano_"..plane)
		if map("plano_"..plane)~=nil then
			for x, y, tile in map("plano_"..plane):iterate() do
				
				obj=nil
				--avoid repeated tiles
				if processed_tiles[y*map.width+x]==nil then
					object_type=tile.tileset.properties["object_type"]
					if(tile.properties["object_type"]~=nil) then
						object_type=tile.properties["object_type"]
					end
					imagePath=tile.tileset.imagePath
			   		--print( string.format("Tile at (%d,%d) has an id of %d %s %s",
			   		--				x, y, tile.id,object_type,imagePath) )
					if object_type=="RomulanScout" then
						obj=RomulanScout:new(space,map.tileWidth*x,map.tileHeight*y)
					
					elseif object_type=="DestructorKlingon" then
						obj=PlayerShip:new(space,map.tileWidth*x,map.tileHeight*y)
					
					elseif object_type=="RomulanWarBird" then
						obj=RomulanWarBird:new(space,map.tileWidth*x,map.tileHeight*y)

					elseif object_type=="RomulanNorexan" then
						obj=RomulanNorexan:new(space,map.tileWidth*x,map.tileHeight*y)
					
					elseif object_type=="HealthObject" then
						obj=HealthObject:new(space,map.tileWidth*x,map.tileHeight*y)
					
					elseif object_type=="WeaponObject" then
						if tile.properties["weapon_type"]=="MACHINE_GUN" then
							obj=WeaponObject:new(space,WeaponObject.static.MACHINE_GUN,map.tileWidth*x,map.tileHeight*y)
						end
						if tile.properties["weapon_type"]=="DOUBLE_BLUE" then
							obj=WeaponObject:new(space,WeaponObject.static.DOUBLE_BLUE,map.tileWidth*x,map.tileHeight*y)
						end
						if tile.properties["weapon_type"]=="DOUBLE_GREEN" then
							obj=WeaponObject:new(space,WeaponObject.static.DOUBLE_GREEN,map.tileWidth*x,map.tileHeight*y)
						end

					elseif object_type=="TileBlock" then
							obj=TileBlock:new(space,tile,map.tileWidth*x,map.tileHeight*y)

					elseif object_type=="MineBlock" then
							obj=MineBlock:new(space,tile,map.tileWidth*x,map.tileHeight*y)
					end
					processed_tiles[y*map.width+x]=true
				end
				if(obj~=nil) then
					obj:setBackGroundDistance(plane*step_bg)
				end
			end
		end
	end

end
