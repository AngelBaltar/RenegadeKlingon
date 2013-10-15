require 'Utils/middleclass/middleclass'
require 'GameFrameWork/PlayerShip'
require 'GameFrameWork/TextMessageObject'
require 'GameFrameWork/Harvestables/HealthObject'
require 'GameFrameWork/Harvestables/WeaponObject'
require 'GameFrameWork/TileBlocks/TileBlock'
require 'GameFrameWork/TileBlocks/MineBlock'
require 'GameFrameWork/PilotPatterns/RandomPilotPattern'
require 'GameFrameWork/Weapons/DoubleBasicWeapon'
require 'GameFrameWork/Enemies/Enemy'
require 'Utils/Debugging'

local loader = require("Utils/Advanced-Tiled-Loader/Loader")

 -- Path to the tmx files. The file structure must be similar to how they are saved in _tiled
loader.path = "Resources/maps/"

local _space=nil
local _map=nil
local _map_name=nil
local _tile=nil
local _num_messages=0

local _RomulanNorexan_ship= love.graphics.newImage("Resources/gfx/RomulanNorexan.png")
local _RomulanWarBird_ship = love.graphics.newImage("Resources/gfx/RomulanWarBird.png")
local _RomulanScout_ship = love.graphics.newImage("Resources/gfx/RomulanScout.png")

local _FederationSaber_ship = love.graphics.newImage("Resources/gfx/FederationSaber.png")
local _FederationExcelsior_ship=love.graphics.newImage("Resources/gfx/FederationExcelsior.png")
local _FederationGalaxy_ship=love.graphics.newImage("Resources/gfx/FederationGalaxy.png")

local create_RomulanScout=function(x,y)
	
	local health=10
	local speed=1.5
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleBasicWeapon:new(nil)
	local scout=Enemy:new(_space,_RomulanScout_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(scout)
	movementPattern:setShip(scout)
	return scout
end

local create_DestructorKlingon=function(x,y)
	
	return PlayerShip:new(_space,_map.tileWidth*x,_map.tileHeight*y)
end

local create_RomulanWarBird=function(x,y)
	
	local health=400
	local speed=3
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleBasicWeapon:new(nil)
	local warbird=Enemy:new(_space,_RomulanWarBird_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(warbird)
	movementPattern:setShip(warbird)
	return warbird
end

local create_RomulanNorexan=function(x,y)
	local health=50
	local speed=3
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleBasicWeapon:new(nil)
	local norexan=Enemy:new(_space,_RomulanNorexan_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(norexan)
	movementPattern:setShip(norexan)
	return norexan
end

local create_FederationSaber=function(x,y)
	local health=10
	local speed=1.5
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleBasicWeapon:new(nil)
	local runabout=Enemy:new(_space,_FederationSaber_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(runabout)
	movementPattern:setShip(runabout)
	return runabout
end

local create_FederationExcelsior=function(x,y)
	local health=28
	local speed=2.7
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleWeapon:new(nil,AnimatedBullet.static.GREEN_ANIMATED)
	local excelsior=Enemy:new(_space,_FederationExcelsior_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(excelsior)
	movementPattern:setShip(excelsior)
	return excelsior
end


local create_FederationGalaxy=function(x,y)
	local health=1200
	local speed=2.7
	local movementPattern=RandomPilotPattern:new(nil)
	local weapon=DoubleBasicWeapon:new(nil)
	local galaxy=Enemy:new(_space,_FederationGalaxy_ship,_map.tileWidth*x,_map.tileHeight*y,health,speed,movementPattern,weapon)
	weapon:setAttachedShip(galaxy)
	movementPattern:setShip(galaxy)
	return galaxy
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
	
	local msgFile=loader.path.."Messages/".._map_name..".msg.".._num_messages..".txt"
	_num_messages=_num_messages+1
	DEBUG_PRINT("text message ".._map.tileWidth*x.." ".._map.tileHeight*y)
	return TextMessageObject:new(_space,_tile,_map.tileWidth*x,_map.tileHeight*y,msgFile)
end

local _creation_tab={}

_creation_tab["DestructorKlingon"]=create_DestructorKlingon

_creation_tab["RomulanScout"]=create_RomulanScout
_creation_tab["RomulanWarBird"]=create_RomulanWarBird
_creation_tab["RomulanNorexan"]=create_RomulanNorexan

_creation_tab["FederationSaber"]=create_FederationSaber
_creation_tab["FederationExcelsior"]=create_FederationExcelsior
_creation_tab["FederationGalaxy"]=create_FederationGalaxy

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
	_map_name=map_name

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
