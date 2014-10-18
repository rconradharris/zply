INSTALL_PATH=/usr/local/bin

install:
	cp bin/* $(INSTALL_PATH)

uninstall:
	rm $(INSTALL_PATH)/git-zply-*
