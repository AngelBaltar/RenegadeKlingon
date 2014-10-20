-- /* RenegadeKlingon - LÖVE2D GAME
--  * ConfigPropertie.lua
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


require 'Utils/middleclass/middleclass'

ConfigPropertie = class('Utils.ConfigPropertie')


local _file_exists=function(name)
   local f=io.open(name,"r")
   if f~=nil then 
   	io.close(f) 
   	return true 
   else 
   	return false 
   end
end

--constructor
function ConfigPropertie:initialize(path)
	self._prop_tab={}
	self._path=""
	if path~=nil then
		self._path=path
		if love.filesystem.exists(path) then	
			path=love.filesystem.getSaveDirectory( ).."/"..path
		else
			path=love.filesystem.getWorkingDirectory( ).."/"..path
		end
		print("loading... ",path)
		if _file_exists(path) then
			self._prop_tab=dofile(path)
		end
		
	end
end

function ConfigPropertie:clearProps()
	self._prop_tab={}
end

function ConfigPropertie:getIterator()
	return pairs(self._prop_tab)
end

--get a property
function ConfigPropertie:getProp(name)
	return self._prop_tab[name]
end

--set a property
function ConfigPropertie:setProp(name,value)
	self._prop_tab[name]=value
end

function ConfigPropertie:getPropTab()
	return self._prop_tab
end

function ConfigPropertie:setPath(path)
	self._path=path
end

--save the properties again
function ConfigPropertie:save(path)
	if path==nil then
		path=self._path
	end
	--print("path is"..path)
	file =love.filesystem.newFile( path )
	file:open('w')
	file:write("return{")
	not_first=false
	for k,prop in pairs(self._prop_tab) do
		if not_first then
			file:write(",\n")
		else
			file:write("\n")
		end
		-- print(k)
		-- print(type(k))
		if type(prop)=="string" then
			file:write(k.."=\""..prop.."\"")
		else
			file:write(k.."="..prop)
		end
		not_first=true
	end
	file:write("\n}\n")
	file:close()
end