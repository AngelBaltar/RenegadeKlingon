#bash
#deploy the game to binary executables in deployments directory

necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"


#lets deploy a .love fot LINUX
rm ../RenegadeKlingonDeploy/linux/RegenageKlingon.love
zip  RenegadeKlingon.zip -r $necesary_files
mv RenegadeKlingon.zip ../RenegadeKlingonDeploy/linux/RegenageKlingon.love