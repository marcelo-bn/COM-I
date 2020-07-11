clear all
close all
clc

#* Parâmetros iniciais *
M = 2; #Transmissão binária
Fs = 50e3; #Frequência de amostragem
Ts = 1/Fs; #Período de amostragem
Rb = 2e3; #Taxa de transmissão
Tb = 1/Rb; #Duração do bit
N = Fs/Rb; #Fator de superamostragem. Neste script N tem que ser inteiro!
A = 1; #Nível de amplitude do pulso
fc = 8e3;
filtro_tx = ones(1,N);

#* Definição do eixo tempo *
periodo_tx = 4; #Período de transmissão em segundos
t = [0:Ts:periodo_tx-Ts];

info_bin = randint(1,Rb*periodo_tx,M);
info_up = upsample(info_bin, N);
info_bb = filter(filtro_tx,1,info_up);
phi_c = 0;
phi_psk = (2*pi*info_bb)/M;
phi_fsk = 0;
phi_ask = 0;

c_t = A*sin(2*pi*fc*t);
sinal_psk = A*sin(2*pi*fc*t + phi_psk);
sinal_fsk = A*sin(2*pi*fc*t.*(info_bb) + phi_fsk);
sinal_ask = A*(info_bb).*sin(2*pi*fc*t + phi_ask);

subplot(511)
plot(t,info_bb)
xlim([0 10*Tb])
ylim([-2*A 2*A])
title('Forma de onda transmitida')
subplot(512)
plot(t,c_t)
xlim([0 10*Tb])
ylim([-2*A 2*A])
title('Sinal Portadora')
subplot(513)
plot(t, sinal_psk)
xlim([0 10*Tb])
ylim([-2*A 2*A])
title('Modulacao PSK')
subplot(514)
plot(t, sinal_fsk)
xlim([0 10*Tb])
ylim([-2*A 2*A])
title('Modulacao FSK')
subplot(515)
plot(t, sinal_ask)
xlim([0 10*Tb])
ylim([-2*A 2*A])
title('Modulacao ASK')
