#!/bin/bash
x="teste"
menu ()
{
while true $x != "teste"
do
clear
echo "================================================"
echo "CRIAÇÃO DE CENÁRIOS OPENSTACK"
echo "Autora: Roseli da Rocha Barbosa"
echo ""
echo "1)Criação de redes"
echo""
echo "2)Criação de roteadores"
echo ""
echo "3)Adicionar interface ao roteador"
echo""
echo "4)Criação de intâncias"
echo ""
echo "5)Sair"
echo ""
echo "================================================"

echo "Digite a opção desejada:"
read x
echo "Opção informada ($x)"
echo "================================================"

case "$x" in


	1)
		echo "Escolha  sua opção: 1 - Provider Networks 2 - Self-Service (private) Networks:"
		read op
		echo "Opção informada ($op)"
	
		if [ $op == "1" ]
		then
	
			echo "Digite o nome da rede: "
			read nome
			echo "Digite o tipo da rede: "
			read tipo

			echo "Criando a rede..."

			neutron net-create $nome --provider:network_type $tipo
			neutron net-update $nome --router:external --shared

		elif [ $op == "2" ]
		then
			echo "Digite o nome da rede: "
	        	read nome2
	        	echo "Digite o tipo da rede: "
	        	read tipo2
	
			echo "Criando a rede..."

			neutron net-create $nome2 --provider:network_type $tipo2

			echo "Digite o nome da subnet : "
	        	read subnet2
			echo "Digite o endereço do DNS: "
			read dns2
			echo "Digite o endereço de rede (ex: 10.10.20.0/20): "
			read rede2
	
			neutron subnet-create --name $subnet2 --ip-version 4 --dns-nameserver $dns2 $nome2 $rede2 
	
			echo "Rede e subrede criadas com sucesso!!!"
		else
			echo "Opção inválida!!!"
		fi

      sleep 5

echo "================================================"
 ;;
	2)
	echo "Digite o nome do roteador: "
	read roteador
	echo "Criando o roteador..."
	neutron router-create $roteador

	echo "Roteador $roteador criado com sucesso!!!"

	sleep 5
echo "================================================"
 ;;
	3)
		echo "Digite o nome da rede:"
		read interfaceRede

		echo "O roteador é o gateway padrão? 1 - Sim 2 - Não"
		read gatewayPadrao

         	if [ $gatewayPadrao == "1" ]
                then
                	neutron router-gateway-set router $interfaceRede
                elif [ $gatewayPadrao == "2" ]
                then
                	neutron router-interface-add router $interfaceRede
                else
                        echo "Opção inválida!!!"

                fi

echo "================================================"
 ;;
	4)
		echo "--------------------------------------------------"
		echo "|   	          FLAVOR                        |"
		echo "--------------------------------------------------"

		openstack flavor list
         
	 	echo "Digite o flavor desejado: "
	 	read flavor

		echo "--------------------------------------------------"
		echo "|   	          IMAGE                        |"
		echo "--------------------------------------------------"

	 	openstack image list

		echo "Digite o nome da imagem desejada: "
	 	read imagem

		echo "--------------------------------------------------"9
		echo "|   	        NETWORK                        |"
		echo "--------------------------------------------------"
		
		openstack network list
	 
		echo "Digite o nome da rede ou id que essa instância irá pertencer: "
		read nomeRede

		echo "--------------------------------------------------"
		echo "|   	     SECURITY GROUP                    |"
		echo "--------------------------------------------------"

		openstack security group list
			 
		echo "Digite o nome do Security Group: "
		read securityGroup
	        
		echo "--------------------------------------------------"
		echo "|   	         KEYPAIR                       |"
		echo "--------------------------------------------------"
		
		openstack keypair list		

		echo "Digite o nome do par de chaves: "
	 	read chave
	 
		echo "Digite o nome que será atribuído a instância que será criada: "
	        read nomeInstancia

         	openstack server create --flavor $flavor --image $imagem --nic net-id=$nomeRede --user-data=./userdata.txt --security-group $securityGroup --key-name $chave $nomeInstancia

		echo "Instância $nomeInstancia criada com sucesso!!!"

	 sleep 5
echo "================================================"
 ;;
	5)
		echo "saindo..."
		sleep 5
		clear;
		exit;
echo "================================================"
;;

*)
		echo "Opção inválida!"
esac
done

}
menu
