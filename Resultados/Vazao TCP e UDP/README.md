# Vazão TCP e UDP

<p align="justify">Em todos os experimentos realizados entre instâncias pertencentes ao mesmo compute node, as taxas de transferência em conexões UDP foram maiores quando comparadas com conexões TCP. Os resultados obtidos foram ainda mais significativos em experimentos bidirecionais.

As Tabelas com os resultados no mesmo compute node, mostram um comparativo entre a média da vazão TCP e UDP, levando em consideração a variação na quantidade de conexões simultâneas. É possível observar que em conexões unidirecionais a única tecnologia que apresentou maior diferença na média entre fluxos TCP e o UDP foi Open vSwitch com VXLAN, quando utilizou 8 instâncias. A média UDP obtida foi em torno de 20% a mais quando se comparada com a média TCP.

Em experimentos bidirecionais, a maior diferença entre as médias TCP e UDP também foi ocasionada utilizando Open vSwitch com VXLAN. Diferente dos experimentos de conexões unidirecionais, os maiores resultados foram em testes com 2 instâncias, onde a diferença foi de 43% a mais.

Já as Tabelas com os resultados entre compute nodes diferentes, apresentam o comportamento do tráfego apenas com fluxos TCP. É possível observar que não houve grandes diferenças entre conexões unidirecionais e bidirecionais, e os resultados atingidos foram semelhantes. O uso de Open vSwitch com VXLAN obteve maiores taxas de vazão na maioria dos resultados, e também demonstrou melhor desempenho quando utilizado um maior número de instâncias.

Os gráficos apresentam uma visão geral do desempenho de cada tecnologia para melhor compreensão dos resultados.


</p>
