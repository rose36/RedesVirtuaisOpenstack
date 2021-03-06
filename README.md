# Redes Virtuais Openstack

<p align="justify">As VLANs (Virtual Local Area Network), ou redes locais virtuais, visam fornecer o isolamentodo tráfego de rede entre os usuários pertencentes à mesma arquitetura física.   Nos últimos anos, a computação em nuvem despontou como um dos maiores avanços da tecnologia da informação e revolucionou a gestão de recursos computacionais em ambientes empresariais e acadêmicos. Com a popularidade da computação em nuvem, surgiu a necessidade de ampliar o suporte a múltiplos inquilinos pertencentes a redes logicamente independentes, fomentando o advento da virtualização de redes. Diversos estudos com plataformas de nuvem vêm sendo realizados, buscando aperfeiçoar as técnicas de virtualização de redes existentes, apontando amelhor solução para cada ambiente proposto. Nesse cenário, o OpenStack se tornou propulsor, ganhando cada vez mais novos adeptos por sua natureza aberta e atualmente ser considerado um dos maiores orquestradores de nuvem. O OpenStack possibilita a implementação de modelos flexíveis de redes, atendendo às necessidades de grandes centros de dados que utilizam técnicas de sobreposição de redes para fornecer infraestruturas escaláveis.  Com o intuito de avaliar o desempenho das tecnologias de virtualização de redes suportadas pela plataforma OpenStack, este trabalho visa comparar o desempenho de redes virtuais utilizando os protocolos de tunelamento VXLAN e GRE, com Linux Bridge e Open vSwitch. Para avaliar o desempenho e escalabilidade da infraestrutura de nuvem, foram analisadas métricas como vazão, taxa de perda de pacotes, latência e jitter para fluxos de conexão TCP e UDP usando a ferramenta de geração e medição de tráfego Uperf. Com os experimentos, foi possível constatar que cenários utilizando Open vSwitch com VXLAN obtiveram maiores taxas de vazão entre compute nodes diferentes, mostrando também maiores taxas de perda de pacotes. No entanto, Linux Bridge com VXLAN apresentou menores taxas de latência e jitter na maioria dos resultados.


### Configuração do ambiente

Passo 1:
<p align="justify">Substituir as configurações dos arquivos ml2_conf.ini, openvswitch_agent.ini ou linuxbridge_agent.ini nos nodes controller e compute;

Passo 2:
<p align="justify">Alterar arquivos dhcp_agent.ini, l3_agent.ini para usar o agente OVS ou o agente Linux Bridge;

Passo 3:
<p align="justify">Apagar toda base de dados existente do OVS para implantações usando o OVS como mecanismo de acesso:

```
$ service openvswitch-switch stop
```
```
$ rm -rf /var/log/openvswitch/*
```
```
$ rm -rf /etc/openvswitch/conf.db
```
```
$ service openvswitch-switch start
```
```
$ ovs-vsctl show #Este comando deverá retornar apenas o ID do OVS e sua versão
```
Passo 4:

Adicionar bridge:
Configurações usando o OVS:
```
$ sudo ovs-vsctl add-br <nome_bridge>
```
```
$ sudo ovs-vsctl add-port <nome_bridge>
```
Configurações usando Linux Bridge:
```
$ sudo brctl addbr <nome_bridge>
```
```
$ sudo brctl addif <nome_bridge>
```
```
$ sudo ifconfig up
```
```
$ sudo brctl show
```

Passo 5:
Redefinir o banco de dados Neutron da seguinte maneira:
```
$ mysql -u root -p #Em seguida inserir a senha do mysql
```
```
$ drop database neutron;
```
```
$ create database neutron;
```
```
$ GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senha_neutron'; #Substituir senha_neutron pela senha atribuida na configuração
```
```
$ GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senha_neutron'; #Substituir senha_neutron pela senha atribuida na configuração
```
```
$ quit
```
```
$ sudo su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
```

Passo 6:
Reiniciar os serviços neutron-server e os agentes:

```
$ service neutron-server restart
```
Em configurações utilizando o OVS:
```
$ service neutron-openvswitch-agent restart
```
```
$ service openvswitch-switch restart
```
Em configurações utilizando Linux Bridge:
```
$ service neutron-linuxbridge-agent restart
```

Passo 7:
<p align="justify">Usar o script criacao-automatizada-openstack.sh para criação de redes, subredes, roteadores e instâncias.

Passo 8: 
<p align="justify">Liberar ICMP, SSH, fluxos TCP e UDP no security group.

Passo 9:
<p align="justify">Realizar criação de instâncias para validar o ambiente.

<p align="justify">Dica: É possível definir senhas padronizadas para não precisar acessar as máquinas por chaves (Sugestão útil apenas para ambientes de testes)

- Criar arquivo userdata.txt com as seguintes informações:
```
#cloud-config
password: <senha_desejada>
chpasswd: { expire: False }
ssh_pwauth: True
```


### Experimentos 

Passo 1:
<p align="justify">Usar script uperf-install.sh para instalação e configuração do uperf e realizar a instalação do iperf em experimentos com fluxos UDP entre compute nodes diferentes.

Passo 2: 
<p align="justify">Utilizar o script uperf.sh para a geração de tráfego e os profiles criados para conexões unidirecionais e bidirecionais. 
<p align="justify">OBS: O script uperf.sh utiliza o script do ping.sh que é disparado ao iniciar o experimento. Após a finalização de cada experimento, teremos como saída a latência, o jitter, taxa de perda de pacotes e a vazão.

<p align="justify">Apenas para experimentos entre nodes diferentes com fluxos UDP, será necessário utilizar o script iperf.sh para geração de tráfego controlado.





## Autora

Roseli da Rocha Barbosa

Mestranda em Ciência da Computação na Universidade Federal de Pernambuco 

Graduada em Redes de Computadores na Universidade Federal do Ceará

CV: http://lattes.cnpq.br/7517028268889889
