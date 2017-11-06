# Latência e jitter


<p align="justify"> As Tabelas apresentam a média e o intervalo de confiança da latência e do jitter respectivamente, coletados durante os experimentos. Em conexões utilizando o protocolo
TCP, foram apresentados todos os resultados para cada variação na quantidade de instâncias, levando em consideração ainda como estão alocadas. Já para as conexões utilizando o UDP,
apenas os resultados dos experimentos entre instâncias alocadas no mesmo compute node são apresentados.

<p align="justify">Os cenários utilizando Linux Bridge com VXLAN obtiveram menores taxas de latência em conexões unidirecionais, sendo superior às demais configurações apenas quando 4
e 8 instâncias são utilizadas em diferentes nodes com tráfego TCP, e com 4 e 8 instâncias no mesmo node com fluxos UDP.

<p align="justify">Em conexões bidirecionais usando tráfego TCP, foram alcançados resultados equivalentes aos de conexões unidirecionais, a única diferença identificada foi em experimentos
com 8 instâncias no mesmo compute node. A maioria dos resultados em conexões bidirecionais UDP, o uso de Linux Bridge com VXLAN exibiu menores taxas de latência.
Na maioria dos resultados, a variação do atraso teve menores médias em experimentos utilizando Open vSwitch com GRE, tanto em conexões unidirecionais como
bidirecionais.


