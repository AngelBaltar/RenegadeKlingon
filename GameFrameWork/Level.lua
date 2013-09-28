require 'Utils/middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/TextMessageObject'
require 'GameFrameWork/Enemies/RomulanScout'
require 'GameFrameWork/Enemies/RomulanNorexan'
require 'GameFrameWork/Enemies/RomulanWarBird'
require 'GameFrameWork/Harvestables/HealthObject'
require 'GameFrameWork/Harvestables/WeaponObject'
require 'GameFrameWork/TileBlocks/TileBlock'
require 'GameFrameWork/TileBlocks/MineBlock'
require 'Utils/Debugging'

local loader = require("Utils/Advanced-Tiled-Loader/Loader")

 -- Path to the tmx files. The file structure must be similar to how they are saved in _tiled
loader.path = "Resources/maps/"

local _space=nil
local _map=nil
local _tile=nil
local _num_messages=0

local create_RomulanScout=function(x,y)
	
	return RomulanScout:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_DestructorKlingon=function(x,y)
	
	return PlayerShip:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_RomulanWarBird=function(x,y)
	
	return RomulanWarBird:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_RomulanNorexan=function(x,y)
	
	return RomulanNorexan:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_HealthObject=function(x,y)
	
	return HealthObject:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_WeaponObject=function(x,y)

	local gun=WeaponObject.static.MACHINE_GUN

	if _tile.properties["weapon_type"]=="MACHINE_GUN" then
		gun=WeaponObject.static.MACHINE_GUN
	end
	if _tile.properties["weapon_type"]=="DOUBLE_BLUE" then
		gun=WeaponObject.static.DOUBLE_BLUE
	end
	if _tile.properties["weapon_type"]=="DOUBLE_GREEN" then
		gun=WeaponObject.static.DOUBLE_GREEN
	end

	return WeaponObject:new(_space,gun,_map.tileWidth*x,_map.tileHeight*y)
end


local create_tileBlock=function(x,y)
	
	return TileBlock:new(_space,_tile,_map.tileWidth*x,_map.tileHeight*y)
end

local create_MineBlock=function(x,y)
	
	return MineBlock:new(_space,_tile,_map.tileWidth*x,_map.tileHeight*y)
end

local create_TextMessageObject=function(x,y)
	
	local msgFile=_map.name..".msg.".._num_messages..".txt"
	_num_messages=_num_messages+1
	DEBUG_PRINT("text message ".._map.tileWidth*x.." ".._map.tileHeight*y)
	return TextMessageObject:new(_space,_tile,_map.tileWidth*x,_map.tileHeight*y,msgFile)
end

local _creation_tab={}

_creation_tab["RomulanScout"]=create_RomulanScout
_creation_tab["DestructorKlingon"]=create_DestructorKlingon
_creation_tab["RomulanWarBird"]=create_RomulanWarBird
_creation_tab["RomulanNorexan"]=create_RomulanNorexan
_creation_tab["HealthObject"]=create_HealthObject
_creation_tab["WeaponObject"]=create_WeaponObject
_creation_tab["TileBlock"]=create_tileBlock
_creation_tab["MineBlock"]=create_MineBlock
_creation_tab["TextMessageObject"]=create_TextMessageObject




function load_level(map_name,space)
	local object_type=""
	local imagePath=""
	local quad=nil
	local obj=nil
	local processed__tiles={}
	local step_bg=1
	local n_bgs=4
	local hud=nil
	_space=space
	_num_messages=0

	if(_space~=nil) then
		hud=_space:getHud()
	end

	_space:initialize()
	
	if(hud~=nil) then
		_space:getHud():addToScore(hud:getScore()) --keep the previous score if exists
	end


	_map=loader.load(map_name)
	local ordered_paths={}
	local max_x=0
	--backgrounds
	for x, y, _tile in _map("fondo"):iterate() do
		ordered_paths[x]=_tile.properties["img_path"]
		if(max_x<x) then
			max_x=x
		end
	end
	for x=0 ,max_x do
		if(ordered_paths[x]~=nil) then
			_space:addBackGroundImage(ordered_paths[x])
		end
	end
	--all plane objects
	for plane=1,n_bgs do
		--DEBUG_PRINT("plano_"..plane)
		if _map("plano_"..plane)~=nil then
			for x, y, block in _map("plano_"..plane):iterate() do
				_tile=block
				obj=nil
				--avoid repeated _tiles
				if processed__tiles[y*_map.width+x]==nil then
					
					object_type=_tile.tileset.properties["object_type"]
					imagePath=_tile.tileset.imagePath
					
					if(_tile.properties["object_type"]~=nil) then
						object_type=_tile.properties["object_type"]
					end
					
			   		--print( string.format("plano_"..plane.."_tile at (%d,%d) has an id of %d %s %s",
			   		--				x, y, _tile.id,object_type,imagePath) )

					if _creation_tab[object_type]~=nil then
						obj=_creation_tab[object_type](x,y)
					else
						obj=nil
					end
					
					processed__tiles[y*_map.width+x]=true
				end
				if(obj~=nil) then
					obj:setBackGroundDistance(plane*step_bg)
				end
			end
		end
	end

end
