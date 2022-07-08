#!/usr/bin/env bash

# ----------------------------- VARIÁVEIS ----------------------------- #
URL_CODE="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
URL_DOTNET="https://dot.net/v1/dotnet-install.sh"

DIRETORIO_DOWNLOADS_DEV="$HOME/Downloads/programas/dev"

# -- Em busca --
# Net Core*
# VS CODE*
# OK DBEAVER Community*
# DOCKER* (package/repository: https://computingforgeeks.com/install-docker-and-docker-compose-on-linux-mint-19/)
# Postman*
# MOCKOON* (download/install)
# MYSQL WORKBENCH*
# --------------

PROGRAMAS_APT=(
  git
  filezilla
  vim
  htop
  virtualbox
  virtualbox-ext-pack
  virtualbox-guest-additions-iso
  rdesktop
  nodejs
  code
  sublime-text
  libnss3-tools
  # virt-manager - alternativa ao virtualbox
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
#sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y

#wget -nc "$URL_WINE_KEY"
#sudo apt-key add winehq.key
#sudo apt-add-repository "deb $URL_PPA_WINE bionic main"


# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS_DEV"
wget -O code.deb "$URL_CODE" -P "$DIRETORIO_DOWNLOADS_DEV"
wget "$URL_DOTNET" -P "$DIRETORIO_DOWNLOADS_DEV"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS_DEV/*.deb

## Instalando o dotnet
.$DIRETORIO_DOWNLOADS_DEV/dotnet-install.sh -c Current

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_APT[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

## Instalando pacotes Flatpak ##
flatpak install com.getpostman.Postman -y
flatpak install com.microsoft.Teams -y
flatpak install io.dbeaver.DBeaverCommunity -y


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