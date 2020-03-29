clear all
close all
clc

% Frequencias dos sinais modulantes e portadoras
fm_1 = 1000;
fm_2 = 2000;
fm_3 = 3000;  
fc_1 = 10000;
fc_2 = 12000;
fc_3 = 14000;

% Fator de amostragem 
N = 200;

% Frequencia de amostragem
fs = N*fm_1;

% Numero de periodos
num_p = 1000;

% Tempo final
tempo_final = num_p*(1/fm_1);

% Periodo de amostragem
Ts = 1/fs;

% Vetor tempo
t = 0:Ts:tempo_final;

% Vetor frequencia
f_passo =  1/tempo_final;
f = -fs/2:f_passo:fs/2;    

% Sinais modulantes e portadoras
Am = cos(2*pi*fm_1.*t);
Bm = cos(2*pi*fm_2.*t);
Cm = cos(2*pi*fm_3.*t);
Ac = cos(2*pi*fc_1.*t);
Bc = cos(2*pi*fc_2.*t);
Cc = cos(2*pi*fc_3.*t);

% Transformada de Fourier normalizada dos sinais
AM = (fftshift(fft(Am)))/length(Am);
BM = (fftshift(fft(Bm)))/length(Bm);
CM = (fftshift(fft(Cm)))/length(Cm);
AC = (fftshift(fft(Ac)))/length(Ac);
BC = (fftshift(fft(Bc)))/length(Bc);
CC = (fftshift(fft(Cc)))/length(Cc);

%% Sinais modulantes e portadoras no dominio do tempo
figure(1)
subplot(6,1,1)
plot(t,Am,'r')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Am = cos(2pi1000t)')
axis([0 tempo_final/200 -1.5 1.5])  

subplot(6,1,2)
plot(t,Bm,'g')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Bm = cos(2pi2000t)')
axis([0 tempo_final/200 -1.5 1.5])  

subplot(6,1,3)
plot(t,Cm,'k')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Cm = cos(2pi3000t)')
axis([0 tempo_final/200 -1.5 1.5])  

subplot(6,1,4)
plot(t,Ac)
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Ac = cos(2pi10000t)')
axis([0 tempo_final/200 -1.5 1.5])  

subplot(6,1,5)
plot(t,Bc)
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Bc = cos(2pi12000t)')
axis([0 tempo_final/200 -1.5 1.5])  

subplot(6,1,6)
plot(t,Cc)
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Cc = cos(2pi14000t)')
axis([0 tempo_final/200 -1.5 1.5])  

%% Sinais modulantes e portadoras no dominio da frequencia
figure(2)
subplot(6,1,1)
plot(f,abs(AM),'r')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Am')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])   

subplot(6,1,2)
plot(f,abs(BM),'g')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Bm')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])   

subplot(6,1,3)
plot(f,abs(CM),'k')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Cm')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])     

subplot(6,1,4)
plot(f,abs(AC))
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Ac')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])       

subplot(6,1,5)
plot(f,abs(BC))
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Bc')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])    

subplot(6,1,6)
plot(f,abs(CC))
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Cc')
axis([-1.2*fc_3 1.2*fc_3 -0.8 0.8])   

%% Emissor

% Primeira etapa: Filtros PB
% Filtro Passa-Baixa 1.5kHz
fpb_1 = [zeros(1,98500) ones(1,3001) zeros(1,98500)];
% Filtro Passa-Baixa 2.5kHz
fpb_2 = [zeros(1,97500) ones(1,5001) zeros(1,97500)];
% Filtro Passa-Baixa 3.5kHz
fpb_3 = [zeros(1,96500) ones(1,7001) zeros(1,96500)];

% Filtrando os sinais modulantes
filtro1_AM = abs(AM).*fpb_1;
filtro1_BM = abs(BM).*fpb_2;
filtro1_CM = abs(CM).*fpb_3;

% Segunda etapa: Modulacao
% Modulando os sinais com suas portadoras
modulado_A_tempo = (ifft(ifftshift(filtro1_AM)).*length(filtro1_AM)).*Ac;
modulado_B_tempo = (ifft(ifftshift(filtro1_BM)).*length(filtro1_BM)).*Bc;
modulado_C_tempo = (ifft(ifftshift(filtro1_CM)).*length(filtro1_CM)).*Cc;

modulado_A_freq = (fftshift(fft(modulado_A_tempo)))/length(modulado_A_tempo);
modulado_B_freq = (fftshift(fft(modulado_B_tempo)))/length(modulado_B_tempo);
modulado_C_freq = (fftshift(fft(modulado_C_tempo)))/length(modulado_C_tempo);

% Terceira etapa: Filtros PF
% Filtro Passa-Faixa 10k - 12kHz
fpf_1 = [zeros(1,88000) ones(1,2000) zeros(1,20001) ones(1,2000) zeros(1,88000)];
% Filtro Passa-Faixa 13k - 15kHz
fpf_2 = [zeros(1,85000) ones(1,2000) zeros(1,26001) ones(1,2000) zeros(1,85000)];
% Filtro Passa-Faixa 15k - 17kHz
fpf_3 = [zeros(1,83000) ones(1,2000) zeros(1,30001) ones(1,2000) zeros(1,83000)];

% Filtrando os sinais
filtro2_AM = abs(modulado_A_freq).*fpf_1;
filtro2_BM = abs(modulado_B_freq).*fpf_2;
filtro2_CM = abs(modulado_C_freq).*fpf_3;

% Quarta etapa: Multiplexacao
% Multiplexacao dos sinais
s_mult_freq = filtro2_AM + filtro2_BM + filtro2_CM;
s_mult_tempo = ifft(ifftshift(s_mult_freq)).*length(s_mult_freq);

figure(3)
subplot(2,1,1)
hold on
plot(f,filtro2_AM,'r')
plot(f,filtro2_BM,'g')
plot(f,filtro2_CM,'k')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal multiplexado no dominio da freq.')
axis([-20000 20000 -0.25 0.25]) 

subplot(2,1,2)
plot(t,s_mult_tempo)
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal multiplexado no dominio do tempo.')
axis([0 tempo_final/200 -3 3])  

%% Receptor

% Primeira etapa: Filtros Passa-Faixa
% FPF 10k - 12kHz
filtro3_AM = s_mult_freq.*fpf_1;
% FPF 13k - 15kHz
filtro3_BM = s_mult_freq.*fpf_2;
% FPF 15k - 17kHz
filtro3_CM = s_mult_freq.*fpf_3;

% Segunda etapa: Demodulacao
demodulado_A_tempo = (ifft(ifftshift(filtro3_AM)).*length(filtro3_AM)).*Ac; 
demodulado_B_tempo = (ifft(ifftshift(filtro3_BM)).*length(filtro3_BM)).*Bc;
demodulado_C_tempo = (ifft(ifftshift(filtro3_CM)).*length(filtro3_CM)).*Cc;

demodulado_A_freq  = (fftshift(fft(demodulado_A_tempo)))/length(demodulado_A_tempo);
demodulado_B_freq  = (fftshift(fft(demodulado_B_tempo)))/length(demodulado_B_tempo);
demodulado_C_freq  = (fftshift(fft(demodulado_C_tempo)))/length(demodulado_C_tempo);

% Terceira etapa: Filtro Passa-Baixa
% FPB 1.5kHz
filtro4_AM = demodulado_A_freq.*fpb_1;
% FPB 2.5kHz
filtro4_BM = demodulado_B_freq.*fpb_2;
% FPB 3.5kHz
filtro4_CM = demodulado_C_freq.*fpb_3;

figure(4)
subplot(3,1,1)
plot(f,filtro4_AM,'r')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Am recuperado (frequencia)')
axis([-4000 4000 -0.25 0.25]) 

subplot(3,1,2)
plot(f,filtro4_BM,'g')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Bm recuperado (frequencia)')
axis([-4000 4000 -0.25 0.25]) 

subplot(3,1,3)
plot(f,filtro4_CM,'k')
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal Cm recuperado (frequencia)')
axis([-4000 4000 -0.25 0.25]) 
