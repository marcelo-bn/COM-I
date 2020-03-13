clc
close all
clear all

Am = 1;                                 % Amplitude do sinal 
Ac = 1;                                 % Amplitude da portadora
fm = 1000;                              % Frequência do sinal
fc = 10000;                             % Frequência da portadora
N = 200;                                % Fator de superamostragem
fs = N*fm;                              % Frequência de amostragem
num_periodos = 1000;                    % Número de períodos
t_final = num_periodos*(1/fm);          % Dois períodos
Ts = 1/fs;                              % Tempo de amostragem 
t = 0:Ts:t_final;                       % Vetor tempo

%% Modulação
m = Am*cos(2*pi*fm.*t);
c = Ac*cos(2*pi*fc.*t);
s_AM_DSB_SC = m.*c;

figure(1)
subplot(3,1,1)
plot(t,m,'r')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal m(t)')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

subplot(3,1,2)
plot(t,c,'g')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal c(t)')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

subplot(3,1,3)
plot(t,s_AM_DSB_SC,'k')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('AM DSB SC')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

f_passo = 1/t_final;                   
f = -fs/2:f_passo:fs/2; 

M = fftshift(fft(m)/length(m));
C = fftshift(fft(c)/length(c));
S_AM_DSB_SC = fftshift(fft(s_AM_DSB_SC)/length(s_AM_DSB_SC));

figure(2)
subplot(3,1,1)
plot(f,abs(M),'m');
axis([-2*fm 2*fm 0 0.8]);
ylabel('Amplitude')
xlabel('Frequência (Hz)')
title('Sinal M(f)')

subplot(3,1,2)
plot(f,abs(C),'g');
axis([-2*fc 2*fc 0 0.8]);
ylabel('Amplitude')
xlabel('Frequência (Hz)')
title('Sinal C(f)')

subplot(3,1,3)
plot(f,abs(S_AM_DSB_SC),'k');
axis([-2*fc 2*fc 0 0.5]);
ylabel('Amplitude')
xlabel('Frequência (Hz)')
title('AM DSB SC')

%% Demodulação
m1 = s_AM_DSB_SC.*c;

filtro = fir1(50,(2*1500)/fs);
sinal_final = filter(filtro,1,m1);

figure(3)
subplot(3,1,1)
plot(t,m1,'c')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('Sinal m1(t)')

subplot(3,1,2)
stem(filtro,'b')
title('Filtro PB')

subplot(3,1,3)
plot(t,sinal_final,'r');
axis([0 t_final/200 -1.5*Am 1.5*Am])  
title('Sinal m(t) demodulado')

