#bash
#deploy the game to binary executables in deployments directory
necesary_files="GameFrameWork GameScreens Resources Utils main.lua conf.lua"

path_deploy=../RenegadeKlingonDeploy
path_linux=../RenegadeKlingonDeploy/linux
path_windows=../RenegadeKlingonDeploy/windows
path_mac=../RenegadeKlingonDeploy/mac
path_act=`pwd`


test() {
    "$@"
    status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1";
	exit 10;
    fi
}

checkout() {

	test cd $path_deploy
	test git checkout $1
	test cd $path_act
}

commit_push() {

	test cd $path_deploy
	message=`date`
	message=" auto_deploy script deploying for "$1" "$message
	git commit -a --message="$message"

	# ls github_pass.txt 1>/dev/null 2>/dev/null

	# status=$?
	#  if [ $status -ne 0 ]; then
 #        git push
 #    else
 #    	git push<github_pass.txt
 #    fi
 	git push
 	
	test cd $path_act
}

merge_push_master()
{
	#MERGE IT ALL ON MASTER BRANCH
	test cd $path_deploy
	test git checkout master
	test git merge linux
	test git merge windows
	test git merge mac
	git push
	test cd $path_act

}

#lets deploy a .love for LINUX
echo "deploying for linux..."
checkout linux
rm $path_linux/*
test zip  $path_linux/RenegadeKlingon.zip -r $necesary_files
test mv $path_linux/RenegadeKlingon.zip $path_linux/RenegadeKlingon.love
test cp $path_linux/RenegadeKlingon.love ./RenegadeKlingon.love
commit_push linux
echo "deploy for linux OK"

# # lets deploy a .exe for WINDOWS
echo "deploying for windows..."
checkout windows
rm $path_windows/*
test cp ./RenegadeKlingon.love $path_windows/game.love
test cp -R ../RenegadeKlingonDeploy/love-0.8.0-win-x86/* $path_windows/
test cat $path_windows/love.exe $path_windows/game.love > $path_windows/RenegadeKlingon.exe
test rm $path_windows/*.love $path_windows/love.exe
commit_push windows
echo "deploy for windows OK"

# #lets deploy a .app for MAC OSX
checkout mac
rm -rf $path_mac/*
test cp -R ../RenegadeKlingonDeploy/love.app $path_mac/RenegadeKlingon.app
test cp ./RenegadeKlingon.love $path_mac/RenegadeKlingon.app/Contents/Resources/
test sed -i 's/>org.love2d.love</>com.with2balls.RenegadeKlingon</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test sed -i 's/>LÖVE</>RENEGADEKLINGON</g' $path_mac/RenegadeKlingon.app/Contents/Info.plist
test cd $path_mac
test zip RenegadeKlingon.osx.zip -r ./RenegadeKlingon.app
test cd $path_act
test rm -rf $path_mac/RenegadeKlingon.app
commit_push mac
echo "deploy for mac OK"

echo "merging all in master an doing push..."
merge_push_master
echo "all OK"

