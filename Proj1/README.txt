Convenção de LEDS:

Todos desligados -> Mostrar horário com alarmes desligados
LED1 -> Mostrar horário com alarme ligado
LED2 -> Mostrar horário do alarme (ligado ou desligado)
LED3 -> Acertar horário
LED4 -> Acertar horário do alarme


Convenção de chaves:

Chaves 1 e 3 pressionadas simultaneamente levam o relógio ao primeiro estado da lista
Se 10 segundos se passarem sem nada ser pressionado nos modos de acerto de horário, o relógio volta ao primeiro
Chave 3 faz o relógio passar para o próximo estado da lista, voltando ao estado inicial se estiver no último
Chave 2 avança hora/minuto quando relógio está em um dos estados de acerto de horário da lista

Funções extra:
Chave 1 volta hora/minuto quando relógio está em um dos estados de acerto de horário da lista
Segurar chaves 1 ou 2 durante o ajuste de horário avança/volta o horário continuamente
O apito do alarme não é um simples apito contínuo



Arquivos:
pindefs -> Definição dos pinos
state_manager -> Biblioteca para controlar o estado do relógio
time_manager -> Biblioteca para controlar os horários do relógio e do alarme
main -> Arquivo principal do programa. Detecta botões pressionados e utiliza as bibliotecas acima para tratar cada caso corretamente