INSTALL_PATH=/usr/local/bin

install:
	cp git-* $(INSTALL_PATH)

uninstall:
	rm $(INSTALL_PATH)/git-zply-*
