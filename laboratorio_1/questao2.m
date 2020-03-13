clear all
close all
clc

% Frequencias dos sinais
f1 = 1000;
f2 = 3000;
f3 = 5000;      % Frequencia maxima do sinal 

% Fator de amostragem 
N = 20;

% Frequencia de amostragem
fs = N*f3;

% Numero de periodos
num_p = 1000;

% Tempo final
tempo_final = num_p*(1/f3);

% Periodo de amostragem
Ts = 1/fs;

% Vetor tempo
t = 0:Ts:tempo_final;

% Vetor frequencia
f_passo =  1/tempo_final;
f = -fs/2:f_passo:fs/2;    

% Amplitudes dos sinais
A1 = 5;
A2 = 5/3;
A3 = 1;

% Sinais
a = A1*sin(2*pi*f1.*t);
b = A2*sin(2*pi*f2.*t);
c = A3*sin(2*pi*f3.*t);
s = a + b + c;

% Transformada de Fourier normalizada dos sinais
A = (fftshift(fft(a)))/length(a);
B = (fftshift(fft(b)))/length(b);
C = (fftshift(fft(c)))/length(c);
S = (fftshift(fft(s)))/length(s);

% Plotando os gráficos
figure(1)
subplot(421)
plot(t,a,'r')
axis([0 tempo_final/100 -A1-1 A1+1])
ylabel('Amplitude')
xlabel('Tempo (s)')
title('a = 5sen(2pi1000t)')

subplot(422)
plot(f,abs(A),'r')
axis([-2*f1 2*f1 0 1.2*A1])
xlabel('Frequência (Hz)')
title('Sinal [a] domínio da frequência')

subplot(423)
plot(t,b,'b')
axis([0 tempo_final/100 -A2-1 A2+1])
ylabel('Amplitude')
xlabel('Tempo (s)')
title('b = (5/3)sen(2pi3000t)')

subplot(424)
plot(f,abs(B),'b')
axis([-2*f2 2*f2 0 1.2*A2])
xlabel('Frequência (Hz)')
title('Sinal [b] domínio da frequência')

subplot(425)
plot(t,c,'g')
axis([0 tempo_final/100 -A3-1 A3+1])
ylabel('Amplitude')
xlabel('Tempo (s)')
title('c = 1sen(2pi5000t)')

subplot(426)
plot(f,abs(C),'g')
axis([-6000 6000 0 1.2*A3])
xlabel('Frequência (Hz)')
title('Sinal [c] domínio da frequência')

subplot(427)
plot(t,s,'m')
axis([0 tempo_final/100 -A3-5 A3+5])
ylabel('Amplitude')
xlabel('Tempo (s)')
title('s = a + b + c')

subplot(428)
plot(f,abs(S),'m')
axis([-6000 6000 0 3])
xlabel('Frequência (Hz)')
title('Sinal [s] domínio da frequência')

% Filtro passa-baixa com frequencia de corte de 2kHz
filtro_PB = [zeros(1,9600) ones(1,801) zeros(1,9600)];
% Filtro passa-baixa com frequencia de corte de 4kHz
filtro_PA = [ones(1,9200) zeros(1,1601) ones(1,9200)];
% Filtro passa-faixa com banda de passagem 2 e 4kHz
filtro_PF = [zeros(1,9200) ones(1,400) zeros(1,801) ones(1,400) zeros(1,9200)];

% S atraves FPB
S_FPB = abs(S).*filtro_PB;
s_fpb = ifft(ifftshift(S_FPB)).*length(s);
% S atraves FPA
S_FPA = abs(S).*filtro_PA;
s_fpa = ifft(ifftshift(S_FPA)).*length(s);
% S atraves FPF
S_FPF = abs(S).*filtro_PF;
s_fpf = ifft(ifftshift(S_FPF)).*length(s);

% Plotando os graficos
figure(2)

% FPB e suas operacoes
subplot(331)
plot(f,filtro_PB,'m')
ylim([0 1.2]);
xlim([-3e3 3e3])
title('Filtro Passa-Baixa (2kHz)')
subplot(332)
plot(f,abs(S_FPB),'m')
ylim([0 3])
title('Sinal [S] após FPB (Freq.)')
subplot(333)
plot(t,real(s_fpb),'m')
xlim([0 tempo_final/20])
title('Sinal [S] após FPB (Tempo)')

% FPA e suas operacoes
subplot(334)
plot(f,filtro_PA,'g')
ylim([0 1.2]);
xlim([-8e3 8e3])
title('Filtro Passa-Alta (4kHz)')
subplot(335)
plot(f,abs(S_FPA),'g')
ylim([0 1])
title('Sinal [S] após FPA (Freq.)')
subplot(336)
plot(t,real(s_fpa),'g')
xlim([0 tempo_final/20])
title('Sinal [S] após FPA (Tempo)')

% FPF e suas operacoes
subplot(337)
plot(f,filtro_PF,'b')
ylim([0 1.2]);
xlim([-5e3 5e3])
title('Filtro Passa-Faixa (2-4kHz)')
subplot(338)
plot(f,abs(S_FPF),'b')
title('Sinal [S] após FPF (Freq.)')
subplot(339)
plot(t,real(s_fpf),'b')
xlim([0 tempo_final/20])
title('Sinal [S] após FPF (Tempo)')

