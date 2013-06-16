#bash
#deploy the game to binary executables in deployments directory

#lets deploy a .love fot LINUX
rm ./deployments/linux/RegenageKlingon.love
zip  RenegadeKlingon.zip -r .
mv RenegadeKlingon.zip ./deployments/linux/RegenageKlingon.love