clear all
close all
clc

% Informacao
info = [0 1 1 0 1 0 1 1 0 1 0]; 
% Fator de superamostragem
N = 200; 
% Fator SNR (dB)
SNR = 10;
% Taxa de transmissao (bits/s)
Rb = length(info);
% Frequencia de amostragem
Fs = N*Rb;
% Limiar
limiar = 0.5;
% Passo tempo
passo_tempo = 1/(Fs);
% Tempo final 
t_final = 1;
% Eixo tempo
t = [0:passo_tempo:t_final-passo_tempo];

%% Transmissor
filtro_NRZ = ones(1,N);
info_up = upsample(info, N);
sinal_tx = filter(filtro_NRZ, 1, info_up);

figure(1)
subplot(311)
stem(info)
title('Informacao a ser transmitida')
ylim([-0.2 1.2])
subplot(312)
stem(info_up)
ylim([-0.2 1.2])
xlim([0 2e3])
title('Informacao superamostrada')
subplot(313)
stem(filtro_NRZ)
ylim([-0.2 1.2])
title('Filtro NRZ')

figure(2)
plot(t,sinal_tx)
title('Forma de onda transmitida')
xlabel('Tempo (s)')
ylabel('Amplitude (V)');
ylim([-0.2 1.2])

%% Canal AWGN
sinal_rx = awgn(sinal_tx, SNR);

%% Deteccao SEM Filtro Casado
sinal_detectado_sem_FC = sinal_rx(N/2:N:end);
info_estimada_sem_FC = sinal_detectado_sem_FC > limiar;
num_err_sem_FC = sum(xor(info, info_estimada_sem_FC))

figure(3)
subplot(211)
plot(t,sinal_rx,'r')
title('Sinal recebido (sem filtro casado)')
xlabel('Tempo (s)')
ylabel('Amplitude (V)');
ylim([-1 2.2])

%% Deteccao COM Filtro Casado
filtro_casado_rx = fliplr(filtro_NRZ);
sinal_rx_filtrado = filter(filtro_casado_rx,1,sinal_rx)/N;

sinal_detectado_com_FC = sinal_rx_filtrado(N:N:end);
info_estimada_com_FC = sinal_detectado_com_FC > limiar;
num_err_com_FC = sum(xor(info, info_estimada_com_FC))

subplot(212)
plot(t,sinal_rx_filtrado, 'g')
title('Sinal recebido (com filtro casado)')
xlabel('Tempo (s)')
ylabel('Amplitude (V)');
ylim([-0.2 1.2])






