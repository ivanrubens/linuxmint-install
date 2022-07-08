#!/usr/bin/env bash

# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
PPA_SHUTTER="ppa:shutter/ppa"

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_SIMPLE_NOTE="https://github.com/Automattic/simplenote-electron/releases/download/v2.21.0/Simplenote-linux-2.21.0-amd64.deb"

DIRETORIO_DOWNLOADS="$HOME/Downloads/linuxmint-install"

PROGRAMAS_APT=(
  mint-meta-codecs
  # -- Dependencias Simplenote --
  gconf-defaults-service
  gconf-service
  gconf-service-backend
  gconf2
  gconf2-common
  libgconf-2-4
  # -- Desconhecidos --
  libgnutls30:i386
  libldap-2.4-2:i386
  libgpg-error0:i386
  libxml2:i386
  libasound2-plugins:i386
  libsdl2-2.0-0:i386
  libfreetype6:i386
  libdbus-1-3:i386
  libsqlite3-0:i386
  # -------------------
  nemo-dropbox
  libreoffice
  gimp
  inkscape
  notepadqq
  keepassx
  whatsapp-desktop
  skypeforlinux
  telegram-desktop
  gparted
  bleachbit
  vlc
  shutter
  epson-printer-utility
  printer-driver-escpr
  clamtk
  # flameshot [alternativa do 'shutter']
  # deja-dup [backup - alternativa ao nativo do linux mint]
  # -- Em busca --
  # teamviewer
  # snapd
  # NOTEPAD++
  # FOXIT
  # --------------
)

# EM CASO DE DUAL BOOT COM WINDOWS 
# Corrigir diferenças de tempo entre o Ubuntu e o Windows
# https://www.edivaldobrito.com.br/como-corrigir-diferencas-de-tempo-entre-o-ubuntu-e-o-windows-em-sistema-com-dual-boot/
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
# sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
sudo apt-add-repository "$PPA_SHUTTER" -y

wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"


# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_APT[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# Instalar apt's de repositorios personalizados
sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

## Instalando pacotes Flatpak ##
flatpak install org.freefilesync.FreeFileSync -y

## Instalando pacotes Snap ##
# sudo snap install nome_pacote --classic


# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y


## OBSERVAÇÃO/SHUTTER: 
#  - Adicionar nas configurações "Teclado" o atalho "PrintScreen" com o comando "shutter -s" ##
#  - Abrir o Shutter e configurar na aba 'Comportamento' a opção "Iniciar o Shutter ao autenticar-se"

# ------------------------------ FIM ---------------------------------------- #
