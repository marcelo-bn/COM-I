clear all
close all
clc

% Niveis de transmisssao, no caso zero e um
M = 2; 
% Numero de amostras
N = 100; 
% Numero de bits (taxa)
Rb = 1e4;
% Tempo de taxa
Tb = 1/Rb;
% Frequencia de amostragem
Fs = N*Rb;
% Banda NRZ
BW = Rb;
% Passo tempo
passo_tempo = 1/(Rb*N);
% Tempo final 
t_final = 1;
% Eixo tempo
t = [0:passo_tempo:t_final-passo_tempo];
% Passo frequencia
passo_f = 1/t_final;
% Eixo frequencia
f = [-Fs/2:passo_f:Fs/2-passo_f];
% Amplitude
A = 2;
% Limiar
limiar = A/2;

% Ordem filtro
ordem_filtro = 20;
% Freq. corte
f_cut = 3*Rb;
% Filtro
filtro_Rx = fir1(ordem_filtro, (2*f_cut)/Fs);

% Filtro formatador
filtro_NRZ = ones(1,N); 
% Informacao
info = randint(1,Rb*t_final,M);
% Superamostragem
info_up = upsample(info,N); 
% Filtragem para formatar o sinal
sinal_tx_aux = conv(info_up,filtro_NRZ);
% Truncando N-1 amostras restantes da convolucao
sinal_tx = sinal_tx_aux(1:end-(N-1))*2*A-A; 

% Variancia do ruido
var_ruido = 20;
% Ruido
ruido = sqrt(var_ruido)*randn(1,length(sinal_tx));

% Sinal recebido com ruido
sinal_rx = sinal_tx + ruido;

% Processo Sem Filtro
% Subamostragem
sinal_det = sinal_rx(N/2:N:end);
% Comparando com o limiar
info_rec = sinal_det > limiar;

% Processo Com Filtro
% Filtragem do sinal recebido
sinal_rx_filter = filter(filtro_Rx, 1, sinal_rx);
% Subamostrando o sinal filtrado
sinal_det_filter = sinal_rx_filter(ordem_filtro:N:end);
% Comparando com um limiar
info_rec_filter = sinal_det_filter > limiar;

% Analisando erros
% Processo sem filtro
n_erro = sum(xor(info,info_rec));
Pb = n_erro/(Rb*t_final)
a1 = A; a2 = -A;
V_dif = a1 - a2;
sigma = std(ruido);
Pb_teorico = qfunc((a1-a2)/(2*sigma))
% Processo com filtro
n_erro_filtrado = sum(xor(info,info_rec_filter))
Pb_filtrado = n_erro_filtrado/(Rb*t_final)

% Analise em frequencia
Rx = xcorr(sinal_tx);
Gx1 = fftshift(fft(Rx));
SINAL_TX = fft(sinal_tx);
Gx2 = fftshift(abs(SINAL_TX).^2);

figure(1)
plot(t,sinal_tx)
xlim([0 10*Tb])
ylim([-3 3])
title('Sinal transmitido')

figure(2)
plot(t,sinal_rx)
xlim([0 10*Tb])
title('Sinal recebido com ruido')

figure(3)
plot(t,sinal_rx_filter)
xlim([0 10*Tb])
title('Sinal recebido com ruido filtrado')

figure(4)
hist(ruido,100)
title('Histograma do ruido')

figure(5)
hist(sinal_rx,100)
title('Histograma do sinal recebido com ruido')

figure(6)
hist(sinal_rx_filter,100)
title('Histograma do sinal recebido com ruido filtrado')


% figure(4)
% plot(info_hat)
% plot(sinal_rec)
% xlim([0 100])
% ylim([-2 2])
% title('Sinal detectado')
% plot(t(1:end-(ordem_filtro/2)+1),sinal_rx_filter(ordem_filtro/2:end),'k')
% hist(sinal_rx, 100)









