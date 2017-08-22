# Redes Virtuais Openstack

Autora: Roseli da Rocha Barbosa
Data: 21/08/2017

#=======================================================================#
# Configuração do ambiente                                              #
#=======================================================================#

#Passo 1:
Substituir as configurações dos arquivos ml2_conf.ini, openvswitch_agent.ini ou linuxbridge_agent.ini nos nodes controller e compute;

#Passo 2:
Alterar arquivos dhcp_agent.ini, l3_agent.ini para usar o agente OVS ou o agente Linux Bridge; 

#Passo 3: 
Apagar toda base de dados existente do OVS para implantações usando o OVS como mecanismo de acesso:

$ service openvswitch-switch stop

$ rm -rf /var/log/openvswitch/*

$ rm -rf /etc/openvswitch/conf.db 

$ service openvswitch-switch start

$ ovs-vsctl show #Este comando deverá retornar apenas o ID do OVS e sua versão

#Passo 4:
Adicionar bridge:

- Configurações usando o OVS:

$ sudo ovs-vsctl add-br <nome_bridge>

$ sudo ovs-vsctl add-port <nome_bridge> <interface>

- Configurações usando Linux Bridge

$ sudo brctl addbr <nome_bridge>

$ sudo brctl addif <nome_bridge> <interface>

$ sudo ifconfig <nome bridge> up

$ sudo brctl show

#Passo 5:

Redefinir o banco de dados Neutron da seguinte maneira:

$ mysql -u root -p #Em seguida inserir a senha do mysql

$ drop database neutron;

$ create database neutron;

$ GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'senha_neutron'; #Substituir senha_neutron pela senha atribuida na configuração

$ GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'senha_neutron'; #Substituir senha_neutron pela senha atribuida na configuração

$ quit

$ sudo su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

#Passo 6 

Reiniciar os serviços neutron-server e os agentes:

$ service neutron-server restart

- Em configurações utilizando o OVS:

$ service neutron-openvswitch-agent restart

$ service openvswitch-switch restart

- Em configurações utilizando Linux Bridge:

$ service neutron-linuxbridge-agent restart

#Passo 7

Usar o script criacao-automatizada-openstack.sh para criação de redes, subredes, roteadores e instâncias.

#Passo 8:

Liberar ICMP, SSH, fluxos TCP e UDP no security group.

#Passo 9:

Realizar criação de instâncias para validar o ambiente.

Dica: É possível definir senhas padronizadas para não precisar acessar as máquinas por chaves (Sugestão útil apenas para ambientes de testes)

- Criar arquivo userdata.txt com as seguintes informações:
#cloud-config
password: <senha_desejada>
chpasswd: { expire: False }
ssh_pwauth: True





#=======================================================================#
# Experimentos                                                          #
#=======================================================================#

#Passo 1:
Usar script uperf-install.sh para instalação e configuração do uperf e realizar a instalação do iperf em experimentos com fluxos UDP entre compute nodes diferentes.

#Passo 2: 
Utilizar o script uperf.sh para a geração de tráfego e os profiles criados para conexões unidirecionais e bidirecionais. 
OBS: O script uperf.sh utiliza o script do ping.sh que é disparado ao iniciar o experimento. Após a finalização de cada experimento, teremos como saída a latência, o jitter, taxa de perda de pacotes e a vazão.

Apenas para experimentos entre nodes diferentes com fluxos UDP, será necessário utilizar o script iperf.sh para geração de tráfego controlado.

