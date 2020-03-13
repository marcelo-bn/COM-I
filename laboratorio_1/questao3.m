clear all
close all
clc

% Frequencia e periodo de amostragem
fs = 10e3;
Ts = 1/fs;

% Tempo final do sinal
tempo_final = 10000*Ts;

% Vetor tempo
t = 0:Ts:tempo_final-Ts;

% Vetor frequencia
f_passo =  1/tempo_final;
f = -fs/2:f_passo:(fs/2)-f_passo;   

% Ruido com distribuicao normal
ruido = randn(1,10000);

% Transformada de Fourier do ruido
TF_ruido = fftshift(fft(ruido));

% Graficos referentes ao ruido
figure(1)

subplot(311)
hist(ruido,100,'g');
xlim([-4 4])
title('Histograma de um ruído com distribuição normal')

subplot(312)
plot(t,ruido,'r')
title('Ruído no domínio do tempo')

subplot(313)
plot(f,abs(TF_ruido)/fs,'m')
xlim([-5000 5000])
title('Ruído no domínio da frequência')

% Autocorrelacao do ruido
[R, l] = xcorr(ruido, 30, 'biased');
figure(2)
stem(l,R,'g')
title('Função autocorrelação do ruído')

% Filtro passa-baixa (ordem 50 (ordem maior latencia maior), freq. normalizada)
filtro = fir1(50,(1000*2)/fs); 
figure(3)
freqz(filtro) % Resposta em freq.
title('Filtro passa-baixa com frequência de corte de 2kHz')

% Realizando a filtragem do filtro
ruido_filtro = filter(filtro,1,ruido);
RUIDO_filtro = fftshift(fft(ruido_filtro));

% Graficos do ruido apos o filtro
figure(4)

subplot(311)
hist(ruido_filtro, 100,'g')
xlim([-1.5 1.5])
title('Histograma do ruído filtrado')

subplot(312)
plot(t,ruido_filtro,'r')
title('Ruído filtrado no domínio do tempo')

subplot(313)
plot(f,abs(RUIDO_filtro),'m')
title('Ruído filtrado no domínio da frequência')

% Autocorrelacao do ruido
[R, l] = xcorr(ruido_filtro, 30, 'biased');
figure(2)
stem(l,R,'g')
title('Função autocorrelação do ruído após passagem pelo filtro ')
