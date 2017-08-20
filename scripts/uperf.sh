#!/bin/bash

x="teste"
menu ()
{
while true $x != "teste"
do
clear
echo "================================================"
echo "AVALIAÇÃO DO AMBIENTE"
echo "Autora: Roseli da Rocha Barbosa"
echo ""
echo "1)Executar como servidor"
echo""
echo "2)Executar como cliente"
echo ""
echo "3)Sair"
echo""
echo "================================================"

echo "Digite a opção desejada:"
read x
echo "Opção informada ($x)"
echo "================================================"

case "$x" in


	1)

		echo "Quantas vezes deseja executar o experimento?"
		read qtd
		echo "O experimento será unidirecional ou bidirecional? Digite 1 - (c->s) 2 - (c<->s)"
		read escolha

			if [ $escolha == "1" ]
			then
				echo "Informe o endereço do host remoto(cliente): "
		                read hostRemoto
 
				echo "Informe a quantidade de threads que deseja executar:"
                		read qtdThread
                		echo "Informe o protocolo de deseja utilizar:"
                		read protocolo
                		echo "Informe o tamanho do buffer:"
                		read buffer
                		echo "Informe a duração de cada transação em segundos:"
                		read duracao
                		echo "Informe o tamanho da mensagem: "
                		read mensagem


				for (( cont1=1; cont1 <= $qtd; cont1++ ))
                		do

				       #Remove o perfil já utilizado e copia um novo perfil da pasta de backup

					rm workloads/servidorUnidirecional.xml
					cp workloads/backup/servidorUnidirecional.xml workloads

					#Faz a substituição dos parâmetros presentes no perfil para os valores digitados pelo usuário

					sed -i 's/remotehost=/remotehost='$hostRemoto'/g' workloads/servidorUnidirecional.xml
                			sed -i 's/nthreads=/nthreads=\"'$qtdThread'\"/g' workloads/servidorUnidirecional.xml
                			sed -i 's/protocol=/protocol='$protocolo'/g' workloads/servidorUnidirecional.xml
                			sed -i 's/wndsz=/wndsz='$buffer'/g' workloads/servidorUnidirecional.xml
                			sed -i 's/duration=/duration=\"'$duracao'\"/g' workloads/servidorUnidirecional.xml
		               		sed -i 's/size=/size='$mensagem'/g' workloads/servidorUnidirecional.xml




					#Chama o script que realiza o ping passando por parâmetro a duração e o ip do host remoto digitado

					./ping.sh $duracao $hostRemoto > saida1 &

					#Executa o experimento como master e joga a saída para o arquivo saidaUperf

					echo "Executando experimento $cont1..."

                        		./debian/uperf/usr/bin/uperf -m workloads/servidorUnidirecional.xml -a -e -p > saidaUperf

					#Aplica o sed na saída do ping para usar como separador padrão a barra, com o resultado é aplicado o awk pegando o campo da latência e o jitter durante a execução do experimento
					sed 's, ,/,g' saida1 | tail -1 > saidaSed1
				        latenciaDurante=$(cat saidaSed1 | awk -F "/" '{print $8}')
					jitterDurante=$(cat saidaSed1 | awk -F "/" '{print $10}')


					#Com a saída do Uperf é aplicado um grep para pegar a linha com os totais. Em seguida aplicado o pipe como separador padrão e utilizado o awk para pegar o resultado da taxa de transferência do experimento
					cat saidaUperf | grep master > saidaUperfThroughput
					sed "s/[[:space:]]\+/|/g" saidaUperfThroughput > saidaThroughputFinal
					taxaTransferencia=$(cat saidaThroughputFinal | awk -F "|" '{print $4}')

					#Aplica o sed na saída do ping usando o pipe como separador padrão, com o resultado é aplicado o awk pegando o campo com a taxa de perda de pacotes
					sed "s/[[:space:]]\+/|/g"  saida1 | tail -2 > saidaPerdaFinal
	                                taxaPerda=$(cat saidaPerdaFinal | awk -F "|" '{print $6}')


					#Após a execução do experimento é executado o script do ping novamente de acordo com a duração digitada, para que seja possível avaliar a diferença
					./ping.sh $duracao $hostRemoto > saida2
					sed 's, ,/,g' saida2 | tail -1 > saidaSed2
                        	        latenciaApos=$(cat saidaSed2 | awk -F "/" '{print $8}')
					jitterApos=$(cat saidaSed2 | awk -F "/" '{print $10}')

					echo "$latenciaDurante	$jitterDurante	$taxaTransferencia	$taxaPerda	$latenciaApos	$jitterApos" >> resultado


				done

			elif [ $escolha == "2" ]
			then
				echo "Informe o endereço do host remoto(cliente): "
		                read hostRemoto2

				echo "Informe a quantidade de threads que deseja executar:"
                		read qtdThread2
                		echo "Informe o protocolo de deseja utilizar:"
                		read protocolo2
                		echo "Informe o tamanho do buffer:"
                		read buffer2
                		echo "Informe a duração de cada transação em segundos:"
                		read duracao2
                		echo "Informe o tamanho da mensagem: "
                		read mensagem2


				for (( cont2=1; cont2 <= $qtd; cont2++ ))
                		do

					#Remove o perfil já utilizado e copia um novo perfil da pasta de backup
					rm workloads/servidorBidirecional.xml
                            	        cp workloads/backup/servidorBidirecional.xml workloads

					#Faz a substituição dos parâmetros presentes no perfil para os valores digitados pelo usuário
      		          		sed -i 's/remotehost=/remotehost='$hostRemoto2'/g' workloads/servidorBidirecional.xml
                			sed -i 's/nthreads=/nthreads=\"'$qtdThread2'\"/g' workloads/servidorBidirecional.xml
                			sed -i 's/protocol=/protocol='$protocolo2'/g' workloads/servidorBidirecional.xml
                			sed -i 's/wndsz=/wndsz='$buffer2'/g' workloads/servidorBidirecional.xml
	                		sed -i 's/duration=/duration=\"'$duracao2'\"/g' workloads/servidorBidirecional.xml
			                sed -i 's/size=/size='$mensagem2'/g' workloads/servidorBidirecional.xml



					#Chama o script que realiza o ping passando por parâmetro a duração e o ip do host remoto digitado
                   	               ./ping.sh $duracao2 $hostRemoto2 > saida1 &


					echo "Executando experimento $cont2..."
					#Executa o experimento como master e joga a saída para o arquivo saidaUperf
                          	       ./debian/uperf/usr/bin/uperf -m workloads/servidorBidirecional.xml -a -e -p > saidaUperf

					#Aplica o sed na saída do ping para usar como separador padrão a /, com o resultado é aplicado o awk pegando o campo da latência e o jitter durante a execução do experimento
                                	sed 's, ,/,g' saida1 | tail -1 > saidaSed1
                                        latenciaDurante2=$(cat saidaSed1 | awk -F "/" '{print $8}')
					jitterDurante2=$(cat saidaSed1 | awk -F "/" '{print $10}')

					#Com a saída do Uperf é aplicado um grep para pegar a linha com os totais. Em seguida aplicado o pipe como separador padrão e utilizado o awk para pegar o resultado da taxa de transferência do experimento
					cat saidaUperf | grep master > saidaUperfThroughput
					sed "s/[[:space:]]\+/|/g" saidaUperfThroughput > saidaThroughputFinal
					taxaTransferencia2=$(cat saidaThroughputFinal | awk -F "|" '{print $4}')


                                     	#Aplica o sed na saída do ping usando o pipe como separador padrão, com o resultado é aplicado o awk p$
                                        sed "s/[[:space:]]\+/|/g"  saida1 | tail -2 > saidaPerdaFinal
                                        taxaPerda2=$(cat saidaPerdaFinal | awk -F "|" '{print $6}')

					#Após a execução do experimento é executado o script do ping novamente de acordo com a duração digitada, para que seja possível avaliar a diferença
                                	./ping.sh $duracao2 $hostRemoto2 > saida2
                                	sed 's, ,/,g' saida2 | tail -1 > saidaSed2
					latenciaApos2=$(cat saidaSed2 | awk -F "/" '{print $8}')
					jitterApos2=$(cat saidaSed2 | awk -F "/" '{print $10}')

					echo "$latenciaDurante2	$jitterDurante2	$taxaTransferencia2	$taxaPerda2	$latenciaApos2	$jitterApos2" >> resultado

				done


			else
				echo "Opção inválida!!!"
			fi

	sleep 5
echo "================================================"
 ;;

	2)
		echo "O experimento será unidirecional ou bidirecional? Digite 1 - (c->s) 2 - (c<->s)"
                read escolha2

                        if [ $escolha2 == "1" ]
                        then

				echo "Informe o endereço do host remoto(servidor): "
                		read hostRemoto3
                		echo "Informe a quantidade de threads que deseja executar:"
                		read qtdThread3
	  		        echo "Informe o protocolo de deseja utilizar:"
                		read protocolo3
                		echo "Informe o tamanho do buffer:"
                		read buffer3
                		echo "Informe a duração de cada transação em segundos:"
                		read duracao3
                		echo "Informe o tamanho da mensagem: "
                		read mensagem3


				#Remove o perfil já utilizado e copia um novo perfil da pasta de backup
				rm workloads/clienteUnidirecional.xml
                                cp workloads/backup/clienteUnidirecional.xml workloads

				#Faz a substituição dos parâmetros presentes no perfil para os valores digitados pelo usuário
                		sed -i 's/remotehost=/remotehost='$hostRemoto3'/g' workloads/clienteUnidirecional.xml
                		sed -i 's/nthreads=/nthreads=\"'$qtdThread3'\"/g' workloads/clienteUnidirecional.xml
                		sed -i 's/protocol=/protocol='$protocolo3'/g' workloads/clienteUnidirecional.xml
                		sed -i 's/wndsz=/wndsz='$buffer3'/g' workloads/clienteUnidirecional.xml
                		sed -i 's/duration=/duration=\"'$duracao3'\"/g' workloads/clienteUnidirecional.xml
                		sed -i 's/size=/size='$mensagem3'/g' workloads/clienteUnidirecional.xml

				echo "Aguardando conexão com o servidor..."
				#Executa o experimento como slave
                        	./debian/uperf/usr/bin/uperf -s workloads/clienteUnidirecional.xml -a -e -p

			elif [ $escolha2 == "2" ]
			then
				echo "Informe o endereço do host remoto(servidor): "
                		read hostRemoto4
                		echo "Informe a quantidade de threads que deseja executar:"
                		read qtdThread4
	  		        echo "Informe o protocolo de deseja utilizar:"
                		read protocolo4
                		echo "Informe o tamanho do buffer:"
                		read buffer4
                		echo "Informe a duração de cada transação em segundos:"
                		read duracao4
                		echo "Informe o tamanho da mensagem: "
                		read mensagem4


				#Remove o perfil já utilizado e copia um novo perfil da pasta de backup
				rm workloads/clienteBidirecional.xml
                                cp workloads/backup/clienteBidirecional.xml workloads

				#Faz a substituição dos parâmetros presentes no perfil para os valores digitados pelo usuário
                		sed -i 's/remotehost=/remotehost='$hostRemoto4'/g' workloads/clienteBidirecional.xml
                		sed -i 's/nthreads=/nthreads=\"'$qtdThread4'\"/g' workloads/clienteBidirecional.xml
                		sed -i 's/protocol=/protocol='$protocolo4'/g' workloads/clienteBidirecional.xml
                		sed -i 's/wndsz=/wndsz='$buffer4'/g' workloads/clienteBidirecional.xml
                		sed -i 's/duration=/duration=\"'$duracao4'\"/g' workloads/clienteBidirecional.xml
                		sed -i 's/size=/size='$mensagem4'/g' workloads/clienteBidirecional.xml

				echo "Aguardando conexão com o servidor..."
                                #Executa o experimento como slave
                       		./debian/uperf/usr/bin/uperf -s workloads/clienteBidirecional.xml -a -e -p



		else
			echo "Opção inválida !!!"

		fi

	sleep 5

echo "================================================"
 ;;

	3)
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
