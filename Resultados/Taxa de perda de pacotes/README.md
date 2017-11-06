# Taxa de perda de pacotes

<p align="justify"> As maiores taxas de perda de pacotes no mesmo compute node ocorreram nos experimentos unidirecionais, onde cenários utilizando Linux Bridge com VXLAN obtiveram
maiores taxas. Os resultados mais significativos foram em experimentos com 8 instâncias, tendo aproximadamente 6% de pacotes perdidos. Tal valor representa 93% a mais de perda em
experimentos usando Open vSwitch com VXLAN, e 84% a mais se comparado a Open vSwitch com GRE. Em experimentos bidirecionais, praticamente não teve perda de pacotes, apenas
quando foi utilizado Linux Bridge com VXLAN com 8 instâncias.

