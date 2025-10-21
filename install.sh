#!/data/data/com.termux/files/usr/bin/bash
# ==========================================
# My Termux Menu — installer & uninstaller
# By: Joni Wijaya Fathoni
# ==========================================

set -e

MENU_SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
MENU_DST_FILE="$HOME/.termux_menu.sh"
UPDATE_BIN="$PREFIX/bin/update"
BASHRC="$HOME/.bashrc"
BASHRC_BAK="$HOME/.bashrc.bak.jwf"

AUTOSTART_LINE='bash ~/.termux_menu.sh'

color() { printf "\e[%sm%s\e[0m" "$1" "$2"; }  # usage: color "1;32" "text"

uninstall() {
  echo
  echo "$(color '1;31' '🧹 Menghapus My Termux Menu...')"

  # Hapus autostart dari .bashrc
  if [ -f "$BASHRC" ]; then
    # remove all exact lines containing autostart
    tmp="$(mktemp)"
    grep -vxF "$AUTOSTART_LINE" "$BASHRC" > "$tmp" || true
    mv "$tmp" "$BASHRC"
  fi

  # Hapus file
  rm -f "$MENU_DST_FILE" "$UPDATE_BIN"

  echo "$(color '1;32' '✅ Uninstall selesai.')" 
  echo "Silakan tutup & buka Termux untuk memastikan semuanya bersih."
}

install_menu() {
  echo
  echo "$(color '1;32' '🧩 Menginstal My Termux Menu...')"

  # backup .bashrc sekali saja
  if [ -f "$BASHRC" ] && [ ! -f "$BASHRC_BAK" ]; then
    cp -f "$BASHRC" "$BASHRC_BAK"
    echo "Backup .bashrc → $BASHRC_BAK"
  fi

  # pasang perintah update
  mkdir -p "$PREFIX/bin"
  cp -f "$MENU_SRC_DIR/bin/update" "$UPDATE_BIN"
  chmod +x "$UPDATE_BIN"

  # salin menu
  cp -f "$MENU_SRC_DIR/menu.sh" "$MENU_DST_FILE"
  chmod +x "$MENU_DST_FILE"

  # tambah autostart 1 baris jika belum ada
  if ! grep -qxF "$AUTOSTART_LINE" "$BASHRC" 2>/dev/null; then
    echo "$AUTOSTART_LINE" >> "$BASHRC"
  fi

  echo
  echo "$(color '1;32' '✅ Instalasi selesai!')"
  echo "Restart Termux, atau jalankan: $(color '1;33' 'bash ~/.termux_menu.sh')"
  echo "Perintah update tersedia: $(color '1;32' 'update')"
}

case "$1" in
  uninstall|remove|delete)
    uninstall
    ;;
  ""|install)
    install_menu
    ;;
  *)
    echo "Usage: $(basename "$0") [install|uninstall]"
    exit 1
    ;;
esac
