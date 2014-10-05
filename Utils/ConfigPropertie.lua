require 'Utils/middleclass/middleclass'

ConfigPropertie = class('Utils.ConfigPropertie')

--constructor
function ConfigPropertie:initialize(path,love_filesys)
	if love_filesys then
		path=love.filesystem.getUserDirectory( )..path
	end
	self._prop_tab=dofile(path)
	self._path=path
end

--get a property
function ConfigPropertie:getProp(name)
	return self._prop_tab[name]
end

--set a property
function ConfigPropertie:setProp(name,value)
	self._prop_tab[name]=value
end

--save the properties again
function ConfigPropertie:save(path)
	if path==nil then
		path=self._path
	end
	file = io.open(path, "w")
	file:write("return{")
	not_first=false
	for k,prop in pairs(self._prop_tab) do
		if not_first then
			file:write(",\n")
		else
			file:write("\n")
		end
		file:write(k.."="..prop)
		not_first=true
	end
	file:write("\n}\n")
	file:close()
end