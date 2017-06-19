#!/bin/bash
#Autora: Roseli da Rocha Barbosa

#####Instalação e configuração Uperf#####

sudo apt-get update -y

#1) Baixar os seguintes arquivos:

wget https://launchpad.net/~vmkononenko/+archive/ubuntu/uperf/+files/uperf_1.0.5-1ppa1.debian.tar.xz
wget https://launchpad.net/~vmkononenko/+archive/ubuntu/uperf/+files/uperf_1.0.5-1ppa1.dsc
wget https://launchpad.net/~vmkononenko/+archive/ubuntu/uperf/+files/uperf_1.0.5-1ppa1_amd64.deb
wget https://launchpad.net/~vmkononenko/+archive/ubuntu/uperf/+files/uperf_1.0.5.orig.tar.gz


#2) Atualizar os pacotes:

sudo apt-get update - y

#3) Instalar aplicações necessárias:

sudo apt-get install build-essential fakeroot dkms module-assistant dpkg-dev uuid-runtime autoconf automake libssl-dev dh-autoreconf python-all python-twisted-conch libtool debhelper python-qt4 python-zope.interface hardening-wrapper dpkg-dev -y

#4) Instale todas as dependências que estiverem faltando:

sudo dpkg -i uperf_1.0.5-1ppa1_amd64.deb

#5) Executar comando que cria o diretório e extrai o pacote:

dpkg-source -x uperf_1.0.5-1ppa1.dsc

#6) Acessar diretório criado e construir os .debs:

cd uperf-1.0.5

dpkg-buildpackage -rfakeroot -b
