BUILD_PATH=./build
INSTALL_PATH=/usr/local/bin
MAN_PATH=/usr/share/man

install: build
	cp $(BUILD_PATH)/bin/* $(INSTALL_PATH)

man: man/*.1
	cp man/*.1 $(MAN_PATH)/man1/

uninstall:
	rm $(INSTALL_PATH)/git-zply-*

git-zply-commit: lib/utils.sh bin/git-zply-commit.sh
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-commit.sh > $(BUILD_PATH)/bin/git-zply-commit
	chmod +x $(BUILD_PATH)/bin/git-zply-commit

git-zply-diff: bin/git-zply-diff.py
	mkdir -p $(BUILD_PATH)/bin
	cp bin/git-zply-diff.py $(BUILD_PATH)/bin/git-zply-diff
	chmod +x $(BUILD_PATH)/bin/git-zply-diff

git-zply-fixup: bin/git-zply-fixup.py
	mkdir -p $(BUILD_PATH)/bin
	cp bin/git-zply-fixup.py $(BUILD_PATH)/bin/git-zply-fixup
	chmod +x $(BUILD_PATH)/bin/git-zply-fixup

git-zply-format: lib/utils.sh bin/git-zply-format.sh
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-format.sh > $(BUILD_PATH)/bin/git-zply-format
	chmod +x $(BUILD_PATH)/bin/git-zply-format

git-zply-refresh: lib/utils.sh bin/git-zply-refresh.sh
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-refresh.sh > $(BUILD_PATH)/bin/git-zply-refresh
	chmod +x $(BUILD_PATH)/bin/git-zply-refresh

git-zply-sync: lib/utils.sh bin/git-zply-sync.sh
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-sync.sh > $(BUILD_PATH)/bin/git-zply-sync
	chmod +x $(BUILD_PATH)/bin/git-zply-sync

build: git-zply-commit \
       git-zply-diff \
       git-zply-fixup \
       git-zply-format \
       git-zply-refresh \
       git-zply-sync

clean:
	rm -rf $(BUILD_PATH)
