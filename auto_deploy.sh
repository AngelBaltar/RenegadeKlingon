#bash
#deploy the game to binary executables in deployments directory

necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"


#lets deploy a .love for LINUX
rm ../RenegadeKlingonDeploy/linux/*
zip  RenegadeKlingon.zip -r $necesary_files
mv RenegadeKlingon.zip ../RenegadeKlingonDeploy/linux/RenegadeKlingon.love

#lets deploy a .exe for WINDOWS
rm ../RenegadeKlingonDeploy/windows/*
cp ../RenegadeKlingonDeploy/linux/RenegadeKlingon.love ../RenegadeKlingonDeploy/windows/game.love
cp -R ../RenegadeKlingonDeploy/love-0.8.0-win-x86/* ../RenegadeKlingonDeploy/windows/
cat ../RenegadeKlingonDeploy/windows/love.exe ../RenegadeKlingonDeploy/windows/game.love > ../RenegadeKlingonDeploy/windows/RenegadeKlingon.exe
rm ../RenegadeKlingonDeploy/windows/*.love
rm ../RenegadeKlingonDeploy/windows/love.exe