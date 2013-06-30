#bash
#deploy the game to binary executables in deployments directory

necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"
path_linux=../RenegadeKlingonDeploy/linux
path_windows=../RenegadeKlingonDeploy/windows
path_mac=../RenegadeKlingonDeploy/mac
path_act=`pwd`


#lets deploy a .love for LINUX
rm $path_linux/*
zip  $path_linux/RenegadeKlingon.zip -r $necesary_files
mv $path_linux/RenegadeKlingon.zip $path_linux/RenegadeKlingon.love

#lets deploy a .exe for WINDOWS
rm $path_windows/*
cp $path_linux/RenegadeKlingon.love $path_windows/game.love
cp -R ../RenegadeKlingonDeploy/love-0.8.0-win-x86/* $path_windows/
cat $path_windows/love.exe $path_windows/game.love > $path_windows/RenegadeKlingon.exe
rm $path_windows/*.love $path_windows/love.exe

#lets deploy a .app for MAC OSX
rm -rf $path_mac/*
cp -R ../RenegadeKlingonDeploy/love.app $path_mac/RenegadeKlingon.app
cp $path_linux/RenegadeKlingon.love $path_mac/RenegadeKlingon.app/Contents/Resources/
sed -i 's/>org.love2d.love</>com.with2balls.RenegadeKlingon</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
sed -i 's/>LÖVE</>RENEGADEKLINGON</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
cd $path_mac
zip RenegadeKlingon.osx.zip -r ./RenegadeKlingon.app
cd $path_act
rm -rf $path_mac/RenegadeKlingon.app
