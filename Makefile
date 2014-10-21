INSTALL_PATH=/usr/local/bin
MAN_PATH=/usr/share/man

install:
	cp bin/* $(INSTALL_PATH)

man: man/*.1
	cp man/*.1 $(MAN_PATH)/man1/

uninstall:
	rm $(INSTALL_PATH)/git-zply-*
	rm $(INSTALL_PATH)/git-refresh-patches
