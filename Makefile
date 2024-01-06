APP_IMAGE_TOOL:=/usr/local/bin/appimagetool

.SILENT:

build: check_appimagetool
	go build -o demo_app
	rm -rf AppDir
	mkdir -p AppDir/usr/local/bin
	mv demo_app AppDir/usr/local/bin/
	echo "#!/bin/bash" > AppDir/AppRun
	echo 'exec "$$(dirname "$$0")/usr/local/bin/demo_app" "$$@"' >> AppDir/AppRun
	chmod +x AppDir/AppRun
	echo "[Desktop Entry]" > AppDir/demo_app.desktop
	echo "Name=DemoApp" >> AppDir/demo_app.desktop
	echo "Exec=demo_app %U" >> AppDir/demo_app.desktop
	echo "Icon=icon" >> AppDir/demo_app.desktop
	echo "Type=Application" >> AppDir/demo_app.desktop
	echo "Categories=Utility;" >> AppDir/demo_app.desktop
	cp icon.png AppDir
	appimagetool AppDir

check_appimagetool:
ifeq (,$(wildcard $(APP_IMAGE_TOOL)))
	wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O app.AppImage
	chmod +x app.AppImage
	sudo mv app.AppImage $(APP_IMAGE_TOOL)
endif
