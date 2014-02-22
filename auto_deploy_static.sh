#bash
#deploy the game to binary executables in deployments directory
necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"

path_linux=linux
path_windows=windows
path_mac=mac
path_act=`pwd`


test() {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1";
	exit 10;
    fi
}



#lets deploy a .love for LINUX
echo "deploying for linux..."
rm -rf $path_linux
mkdir $path_linux
test zip  $path_linux/RenegadeKlingon.zip -r $necesary_files
test mv $path_linux/RenegadeKlingon.zip $path_linux/RenegadeKlingon.love
test cp $path_linux/RenegadeKlingon.love ./RenegadeKlingon.love
test zip -r RenegadeKlingon_linux.zip $path_linux
echo "deploy for linux OK"

# # lets deploy a .exe for WINDOWS
echo "deploying for windows..."
rm -rf $path_windows
mkdir $path_windows
test cp ./RenegadeKlingon.love $path_windows/game.love
test cp -R ./love-0.8.0-win-x86/* $path_windows/
test cat $path_windows/love.exe $path_windows/game.love > $path_windows/RenegadeKlingon.exe
test rm $path_windows/*.love $path_windows/love.exe
test zip -r RenegadeKlingon_windows.zip $path_windows
echo "deploy for windows OK"

# #lets deploy a .app for MAC OSX
rm -rf $path_mac
mkdir $path_mac
test cp -R ./love.app $path_mac/RenegadeKlingon.app
test cp ./RenegadeKlingon.love $path_mac/RenegadeKlingon.app/Contents/Resources/
test sed -i 's/>org.love2d.love</>com.with2balls.RenegadeKlingon</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test sed -i 's/>LÖVE</>RENEGADEKLINGON</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test zip RenegadeKlingon.osx.zip -r $path_mac/RenegadeKlingon.app
test rm -rf $path_mac/RenegadeKlingon.app
echo "deploy for mac OK"

rm -rf $path_linux
rm -rf $path_windows
rm -rf $path_mac

