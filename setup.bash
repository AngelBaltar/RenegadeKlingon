#!/bin/bash

# -- /* RenegadeKlingon - LÖVE2D GAME
# --  * setup.bash
# --  * Copyright (C) Angel Baltar Diaz
# --  *
# --  * This program is free software: you can redistribute it and/or
# --  * modify it under the terms of the GNU General Public
# --  * License as published by the Free Software Foundation; either
# --  * version 3 of the License, or (at your option) any later version.
# --  *
# --  * This program is distributed in the hope that it will be useful,
# --  * but WITHOUT ANY WARRANTY; without even the implied warranty of
# --  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# --  * General Public License for more details.
# --  *
# --  * You should have received a copy of the GNU General Public
# --  * License along with this program.  If not, see
# --  * <http://www.gnu.org/licenses/>.
# --  */

rm -rf bin
mkdir bin
cd bin
#deployments for mac will need
wget https://bitbucket.org/rude/love/downloads/love-0.9.1-macosx-x64.zip
#deployments for windows will need
wget https://bitbucket.org/rude/love/downloads/love-0.9.1-win32.zip