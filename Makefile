INSTALL_PATH=/usr/local/bin

install:
	cp git-* $(INSTALL_PATH)

uninstall:
	rm $(INSTALL_PATH)/git-save-patch
	rm $(INSTALL_PATH)/git-diff-patch
	rm $(INSTALL_PATH)/git-zply-*
