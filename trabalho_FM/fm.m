clear all
close all
clc

% Frequencias dos sinais
fm = 1000;
fc = 10000;
 

% Fator de amostragem 
N = 200;

% Frequencia de amostragem
fs = N*fm;

% Numero de periodos
num_p = 1000;

% Tempo final
tempo_final = num_p*(1/fm);

% Periodo de amostragem
Ts = 1/fs;

% Vetor tempo
t = 0:Ts:tempo_final;

% Vetor frequencia
f_passo =  1/tempo_final;
f = -fs/2:f_passo:fs/2;    

% Amplitudes dos sinais
Am = 1;
Ac = 1;

% Índice de modulacao 
beta = 5;

% Sinais
a = Am*cos(2*pi*fm.*t);
c = Ac*cos(2*pi*fc.*t);
FM = Ac*cos(2*pi*fc.*t + beta*sin(2*pi*fm.*t));

FM_fft = fftshift(fft(FM))/length(FM);

% Graficos no dominio da frequencia
figure(1)
subplot(311)
plot(t,a,'r')
axis([0 tempo_final/500 -Am-1 Am+1])
title('Sinal modulante')

subplot(312)
plot(t,c,'b')
axis([0 tempo_final/500 -Am-1 Am+1])
title('Sinal portadora')
ylabel('Amplitude')

subplot(313)
plot(t,FM,'m')
axis([0 tempo_final/500 -Am-1 Am+1])
title('Sinal modulado FM')
xlabel('Tempo')

% Sinal FM no dominio da frequencia
figure(2)
plot(f,FM_fft)
axis([-2*fc 2*fc -0.5*Am 0.5*Am])
title('Sinal modulado FM domínio da frequência')
xlabel('Frequência (Hz)')
ylabel('Amplitude')





