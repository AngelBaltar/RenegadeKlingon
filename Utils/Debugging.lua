-- /* RenegadeKlingon - LÖVE2D GAME
--  * Debugging.lua
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

local debug_enabled=1


function DEBUG(statements)
  
  
  if debug_enabled==1 then
    return loadstring( 'return ' .. statements )()
  end
end

function DEBUG_PRINT(string)
 if debug_enabled==1 then
    print(string)
  end
end

function enableDebug()
	debug_enabled=1
end

function disableDebug()
	debug_enabled=0
end

function getDebug()
	if debug_enabled==1 then
		return true
	else
		return false
	end
end