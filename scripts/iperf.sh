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

		echo "Aguardando conexão com o cliente..."		

                iperf -s -u




echo "================================================"
 ;;

	2)


		echo "Quantas vezes deseja executar o experimento?"
		read qtd

                echo "Informe o endereço do host remoto(servidor): "
		read hostRemoto

		echo "Informe a taxa de transferência desejada: "
                read taxaTransferencia

                echo "Informe a duração do experimento em segundos: "
                read duracao

				for (( cont1=1; cont1 <= $qtd; cont1++ ))
                		do


					echo "Executando experimento $cont1..."

					#Chama o script que realiza o ping passando por parâmetro a duração e o ip do host remoto digitado

					./ping.sh $duracao $hostRemoto > saida1 &

                                        #Executa como cliente
                       			iperf -c $hostRemoto -u -t $duracao -b $taxaTransferencia



					#Aplica o sed na saída do ping para usar como separador padrão a barra, com o resultado é aplicado o awk pegando o campo da latência e o jitter durante a execução do experimento
					sed 's, ,/,g' saida1 | tail -1 > saidaSed1
				        latenciaDurante=$(cat saidaSed1 | awk -F "/" '{print $8}')
					jitterDurante=$(cat saidaSed1 | awk -F "/" '{print $10}')



					#Aplica o sed na saída do ping usando o pipe como separador padrão, com o resultado é aplicado o awk pegando o campo com a taxa de perda de pacotes
					sed "s/[[:space:]]\+/|/g"  saida1 | tail -2 > saidaPerdaFinal
	                                taxaPerda=$(cat saidaPerdaFinal | awk -F "|" '{print $6}')



					echo "$latenciaDurante	$jitterDurante	$taxaPerda" >> resultado

				done	

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
