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
A1 = 6;
A2 = 2;
A3 = 4;

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
title('a = 6sen(2pi1000t)')

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
title('b = 2sen(2pi3000t)')

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
title('c = 4sen(2pi5000t)')

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
axis([-6000 6000 0 1.2*A3])
xlabel('Frequência (Hz)')
title('Sinal [s] domínio da frequência')

% Densidade espectral de potência
figure(2)
pwelch(s,[],[],[],fs,'onesided')

% Potência média do sinal s(t)
pot_comput = ((norm(s)).^2)/length(t)
pot_teorica = sum(s.^2)/length(s)    







