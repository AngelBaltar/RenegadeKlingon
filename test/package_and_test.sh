#!/bin/bash

# -- /* RenegadeKlingon - LÖVE2D GAME
# --  * package_and_test.sh
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

#deploy the game to binary executables in deployments directory

path_linux=RenegadeKlingon_linux
path_windows=RenegadeKlingon_windows
path_mac=RenegadeKlingon_mac
path_act=`pwd`

test() {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1";
		exit 10;
    fi
}
me=`whoami`
echo "I am $me and I am on the path" $path_act
test ./auto_deploy_static.sh
