# UDP entre compute nodes diferentes

<p align="justify">
A ideia inicial era realizar os mesmos número e tipos de experimentos para cada configuração, levando em consideração a alocação das VMs. No entanto, ao realizar experimentos
gerando fluxos UDP entre compute nodes diferentes, foi identificada uma instabilidade na rede a ponto de impedir a comunicação entre as instâncias, o que inviabilizou a execução
dos experimentos. Após pesquisar na literatura pelo problema ocorrido, constatou-se que o experimento com UDP estava gerando tráfego como um ataque de negação de serviço, conhecido
como UDP Flood Attack, podendo ser iniciado quando se envia um grande número de pacotes UDP para portas aleatórias de um determinado host remoto.

Com a descoberta, um novo experimento foi realizado para investigar se o problema afetava também redes virtuais de diferentes clientes do OpenStack, que deveriam ser isoladas. O
novo cenário possuía duas redes privadas com instâncias alocadas entre compute nodes diferentes. O problema persistiu mesmo utilizando apenas uma conexão para
cada rede privada. Constatou-se que quando um dos clientes gera muito tráfego UDP, é possível congestionar e criar instabilidade nos compute nodes envolvidos na comunicação, a ponto de
afetar outros clientes.

Diante do problema detectado, um novo experimento foi planejado com UDP, mas usando a ferramenta Iperf, que permite controlar a taxa de geração de tráfego. Foram avaliadas
apenas conexões unidirecionais, com taxas de transferências de 100(Mb/s), 150(Mb/s) e 200(Mb/s). A escolha desses valores foi baseada nos resultados obtidos nos experimentos
usando o TCP.

</p>
