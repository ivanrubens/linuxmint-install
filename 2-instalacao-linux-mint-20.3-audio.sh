#!/usr/bin/env bash


# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_MIXXX="ppa:mixxx/mixxx"
URL_YOUTUBETOMP3="https://www.mediahuman.com/download/YouTubeToMP3.amd64.deb"

DIRETORIO_DOWNLOADS_AUDIO="$HOME/Downloads/programas/audio"

PROGRAMAS_APT=(
  pavucontrol
  vlc
  lame
)


# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
# sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
sudo apt-add-repository "$PPA_MIXXX" -y


# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS_AUDIO"

# ATENÇÃO INSTALADOR GRANDE 2.2GB
# wget -c "$URL_YOUTUBETOMP3"        -P "$DIRETORIO_DOWNLOADS_AUDIO"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS_AUDIO/*.deb

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_APT[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# Instalar apt's de repositorios personalizados
sudo apt install mixxx -y

## Instalando pacotes Flatpak ##
flatpak install org.mixxx.Mixxx -y

## Instalando pacotes Snap ##


# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y


# --------------------------------- FIM ------------------------------------- #