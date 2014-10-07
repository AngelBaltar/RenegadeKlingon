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