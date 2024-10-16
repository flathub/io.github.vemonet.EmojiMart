OS := $(shell uname)
.PHONY: install sources flatpak bundle clean lint

install:
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub -y org.flatpak.Builder \
		org.gnome.Platform//47 org.gnome.Sdk//47 \
		runtime/org.freedesktop.Sdk.Extension.rust-stable/x86_64/24.08 \
		runtime/org.freedesktop.Sdk.Extension.node22/x86_64/24.08
	wget -N https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/master/cargo/flatpak-cargo-generator.py
	pip install "git+https://github.com/flatpak/flatpak-builder-tools.git#egg=flatpak_node_generator&subdirectory=node"
	pip install aiohttp toml

# org.freedesktop.Sdk.Extension.rust-nightly/x86_64/22.08

sources:
	python flatpak-cargo-generator.py -o cargo-sources.json ../EmojiMart/src-tauri/Cargo.lock
	flatpak-node-generator --no-requests-cache -r -o node-sources.json npm ../EmojiMart/package-lock.json

# flatpak-node-generator bug with package-lock v3, so we need to generate a v2 lock file: https://github.com/flatpak/flatpak-builder-tools/issues/366
# npm i --lockfile-version 2 --package-lock-only

# flatpak-node-generator -r -o node-sources.json yarn ../EmojiMart/yarn.lock
# Gen from Yarn not working: flatpak-node-generator --no-requests-cache -r -o node-sources.json yarn ../yarn.lock

flatpak:
	flatpak run org.flatpak.Builder --keep-build-dirs --user --install --force-clean build io.github.vemonet.EmojiMart.yml --repo=.repo

# flatpak run io.github.vemonet.EmojiMart --keep

lint:
	flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest io.github.vemonet.EmojiMart.yml
	flatpak run --command=flatpak-builder-lint org.flatpak.Builder repo .

bundle:
	flatpak build-bundle .repo io.github.vemonet.EmojiMart.flatpak io.github.vemonet.EmojiMart

bundle-ydotool:
	sed -i "s/- --device=dri/- --device=all/g" ./io.github.vemonet.EmojiMart.yml
	make flatpak
	make bundle
	sed -i "s/- --device=all/- --device=dri/g" ./io.github.vemonet.EmojiMart.yml

clean:
	rm -rf .flatpak-builder build/
# flatpak remove io.github.vemonet.EmojiMart -y --delete-data
