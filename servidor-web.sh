#!/usr/bin/bash

# Verificar se usuário é root

if [[ $(id -u $(whoami)) -gt 0 ]]; then
	echo "Esse script requer permissões administrativas para que seja executado"
	exit 0
fi

if [[ $# -eq 0 ]]; then
	# Instalar pacotes necessários

	apt-get update
	apt-get upgrade -y
	apt-get install apache2 unzip -y

	# Iniciar serviço do apache

	systemctl enable apache --now

	# Download do projeto

	cd /tmp
	wget "https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip"
	unzip -o main.zip
	cd linux-site-dio-main
	cp -r ./* /var/www/html/

	printf "O servidor apache foi configurado com êxito\n\n"
	printf "Para desfazer as alterações execute o script adicionando um parâmetro qualquer\n\n"
	printf "Exemplo: ./servidor-web.sh d\n\n"
	printf "Obs.: Isso apagará todos os arquivos da pasta /var/www/html/"
fi

# Desfazer todas as alterações

if [[ $# -gt 0 ]]; then
	systemctl disable apache --now
	apt remove apache2 unzip -y
	rm -rf /var/www/html/*
	rm -rf /tmp/*
	echo "Pacotes removidos: apache2, unzip"
	echo "Os arquivos da pasta /var/www/html/ foram apagados"
fi
