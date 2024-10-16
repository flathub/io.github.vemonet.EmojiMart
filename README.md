# 🏪 Emoji Mart popup picker flatpak

Flatpak build config for [vemonet/EmojiMart](https://github.com/vemonet/EmojiMart) emoji picker.

## 🛠️ Development

Clone this repository, and the EmojiMart repository in the same folder:

```bash
git clone --recursive https://github.com/flathub/io.github.vemonet.EmojiMart
git clone https://github.com/vemonet/EmojiMart
cd flathub
```

Create and activate a virtual environment (for python dependencies used to generate sources):

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
make install
```

Generate `cargo-sources.json` and `node-sources.json`:

```bash
make sources
```

Build flatpak:

```bash
make flatpak
```

Try the built flatpak:

```bash
flatpak run io.github.vemonet.EmojiMart
```

> [!NOTE]
>
> To try building the flatpak from a local folder, checkout the `io.github.vemonet.EmojiMart.yml` file to uncomment a line

Open a shell inside the flatpak app to debug:

```bash
flatpak run --devel --command=sh io.github.vemonet.EmojiMart
```

In this shell use `emoji-mart` to start the app

Clean the cache:

```bash
make clean
```

Lint the repo with `flatpak-builder`:

```bash
make lint
```

## 📦 Update flatpak build

To update this repository:

* Make the changes in a separate branch, e.g. `dev`
* Send a PR to the `main` branch
* Checkout the build and response in the PR to see if everything works as expected

## 📋 Notes

Examples tauri to flathub:
* [v2] New documentation: https://github.com/tauri-apps/tauri-docs/pull/1760
* [v1] https://github.com/flathub/in.cinny.Cinny/blob/master/in.cinny.Cinny.yml
* [v1] https://github.com/hadess/flathub/blob/d4b53ff829e0917c5129294132f619e5f12d337c/io.github.neil_morrison44.pocket-sync.yaml
