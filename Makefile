INSTALL_PATH=/usr/local/bin

install:
	cp git-save-patch $(INSTALL_PATH)
	cp git-diff-patch $(INSTALL_PATH)
	cp git-fixup-patch $(INSTALL_PATH)
	cp git-zply-format $(INSTALL_PATH)
	cp git-zply-sync $(INSTALL_PATH)

uninstall:
	rm $(INSTALL_PATH)/git-save-patch
	rm $(INSTALL_PATH)/git-diff-patch
	rm $(INSTALL_PATH)/git-fixup-patch
	rm $(INSTALL_PATH)/git-zply-format
	rm $(INSTALL_PATH)/git-zply-sync
