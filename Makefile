BUILD_PATH=./build
INSTALL_PATH=/usr/local/bin

install: build
	cp $(BUILD_PATH)/bin/* $(INSTALL_PATH)

uninstall:
	rm $(INSTALL_PATH)/git-zply-*

git-zply-commit: lib/utils.sh bin/git-zply-commit
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-commit > $(BUILD_PATH)/bin/git-zply-commit
	chmod +x $(BUILD_PATH)/bin/git-zply-commit

git-zply-diff: bin/git-zply-diff
	mkdir -p $(BUILD_PATH)/bin
	cp bin/git-zply-diff $(BUILD_PATH)/bin/git-zply-diff

git-zply-fixup: bin/git-zply-fixup
	mkdir -p $(BUILD_PATH)/bin
	cp bin/git-zply-fixup $(BUILD_PATH)/bin/git-zply-fixup

git-zply-format: lib/utils.sh bin/git-zply-format
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-format > $(BUILD_PATH)/bin/git-zply-format
	chmod +x $(BUILD_PATH)/bin/git-zply-format

git-zply-refresh: lib/utils.sh bin/git-zply-refresh
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-refresh > $(BUILD_PATH)/bin/git-zply-refresh
	chmod +x $(BUILD_PATH)/bin/git-zply-refresh

git-zply-sync: lib/utils.sh bin/git-zply-sync
	mkdir -p $(BUILD_PATH)/bin
	cat lib/utils.sh bin/git-zply-sync > $(BUILD_PATH)/bin/git-zply-sync
	chmod +x $(BUILD_PATH)/bin/git-zply-sync

build: git-zply-commit \
       git-zply-diff \
       git-zply-fixup \
       git-zply-format \
       git-zply-refresh \
       git-zply-sync

clean:
	rm -rf $(BUILD_PATH)
