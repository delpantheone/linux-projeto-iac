#!/usr/bin/bash

# Verificar se o usuário é root

if [[ $(id -u $(whoami)) -gt 0 ]]; then
	echo "Esse script requer permissões administrativas para que seja executado"
	exit 0
fi

if [[ $# -eq 0 ]]; then
	# Criação de diretórios

	for d in publico adm ven sec; do
		rm -rf "/$d"
		mkdir -p "/$d"
		chown root "/$d" # Garante que o root será o dono do diretório
	done

	# Criação de grupos

	for grp in GRP_ADM GRP_VEN GRP_SEC; do
		groupdel $grp 2>/dev/null
		groupadd $grp
	done

	# Criação de usuários

	for user in carlos maria joao debora sebastiana roberto josefina amanda rogerio; do
		userdel -r $user 2>/dev/null
		useradd -p $(mkpasswd --method=sha-512 "senha123") $user
	done

	# Associação USUÁRIO-GRUPO

	for user in carlos maria joao; do
		usermod -G GRP_ADM $user
	done

	for user in debora sebastiana roberto; do
		usermod -G GRP_VEN $user
	done

	for user in josefina amanda rogerio; do
		usermod -G GRP_SEC $user
	done

	# Definição de permissões

	chown root:GRP_ADM "/adm"
	chown root:GRP_VEN "/ven"
	chown root:GRP_SEC "/sec"

	for d in adm ven sec; do
		chmod 770 "/$d"
	done

	chmod 777 "/publico" # Permissão total

	printf "Infraestrura criada\n\n"
	printf "Usuários adicionados:\n\ncarlos\nmaria\njoao\ndebora\nsebastiana\nroberto\njosefina\namanda\nrogerio\n\n"
	printf "Grupos adicionados:\n\nGRP_ADM\nGRP_VEN\nGRP_SEC\n\n"
	printf "Diretórios adicionados:\n\n/adm\n/ven\n/sec\n\n"
	printf "A senha padrão desses usuários é: senha123\n\n"
	printf "Para apagar todos esses dados basta repetir o comando adicionando um argumento qualquer\n"
	printf "Exemplo: sudo ./iac.sh d\n"
fi

# Remoção completa das alterações

if [[ $# -gt 0 ]]; then
	# Usuários
	for user in carlos maria joao debora sebastiana roberto josefina amanda rogerio; do
		userdel -r $user 2>/dev/null
	done
	# Grupos
	for grp in GRP_ADM GRP_VEN GRP_SEC; do
		groupdel $grp 2>/dev/null
	done
	# Diretórios
	for d in adm ven sec; do
		rm -rf "/$d"
	done

	echo "Todos os usuários, grupos e diretórios foram removidos do sistema"
fi
