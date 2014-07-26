#!/bin/sh

# -- /* RenegadeKlingon - LÖVE2D GAME
# --  * auto_deploy_static.sh
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
necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"

path_linux=RenegadeKlingon_linux
path_windows=RenegadeKlingon_windows
path_mac=RenegadeKlingon_mac
path_act=`pwd`


exit_deploy() {

	rm -rf $path_linux
	rm -rf $path_windows
	rm -rf $path_mac
	rm -rf love.app
	rm -rf love-0.9.1-win32
	exit "$@";
}

test() {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1";
		exit_deploy 10;
    fi

}
echo "extracting love binaries..."
test unzip love-0.9.1-win32.zip 1>/dev/null
test unzip love-0.9.1-macosx-x64.zip 1>/dev/null

echo "setting compressed map sources to make a compressed deploy..."
test mkdir ./tmpSources/
test cp ./Resources/maps/mapSources/* ./tmpSources/
test rm ./Resources/maps/mapSources/*
test cp ./compressed_map_sources/* ./Resources/maps/mapSources/

#lets deploy a .love for LINUX
echo "deploying for linux..."
rm -rf RenegadeKlingon_linux.zip
test mkdir $path_linux
test zip  -9 $path_linux/RenegadeKlingon.zip -r $necesary_files 1>/dev/null
test mv $path_linux/RenegadeKlingon.zip $path_linux/RenegadeKlingon.love
test cp $path_linux/RenegadeKlingon.love ./RenegadeKlingon.love
test zip -9 -r RenegadeKlingon_linux.zip $path_linux 1>/dev/null

# # lets deploy a .exe for WINDOWS
echo "deploying for windows..."
rm -rf RenegadeKlingon_windows.zip
test mkdir $path_windows
test cp ./RenegadeKlingon.love $path_windows/game.love
test cp -R ./love-0.9.1-win32/* $path_windows/
test cat $path_windows/love.exe $path_windows/game.love > $path_windows/RenegadeKlingon.exe
test rm $path_windows/*.love $path_windows/love.exe
test zip -9 -r RenegadeKlingon_windows.zip $path_windows 1>/dev/null

# #lets deploy a .app for MAC OSX
echo "deploying for mac..."
rm -rf RenegadeKlingon_mac.zip
test mkdir $path_mac
test cp -R ./love.app $path_mac/RenegadeKlingon.app
test cp ./RenegadeKlingon.love $path_mac/RenegadeKlingon.app/Contents/Resources/
test sed -i 's/>org.love2d.love</>com.with2balls.RenegadeKlingon</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test sed -i 's/>LÖVE</>RENEGADEKLINGON</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test zip -9 RenegadeKlingon.osx.zip -r $path_mac/RenegadeKlingon.app 1>/dev/null
test rm -rf $path_mac/RenegadeKlingon.app

echo "reset the mapSources..."
test rm ./Resources/maps/mapSources/*
test cp ./tmpSources/* ./Resources/maps/mapSources/
test rm -rf ./tmpSources

echo "Every deploy OK"
exit_deploy 0

