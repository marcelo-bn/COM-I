clc
close all
clear all

Am = 1;                                 % Amplitude do sinal 
Ac = 1;                                 % Amplitude da portadora
Ao = 2;                                 % Amplitude AM DSB
fm = 1000;                              % Frequência do sinal
fc = 10000;                             % Frequência da portadora
N = 200;                                % Fator de superamostragem
fs = N*fm;                              % Frequência de amostragem
num_periodos = 1000;                    % Número de períodos
t_final = num_periodos*(1/fm);          % Dois períodos
Ts = 1/fs;                              % Tempo de amostragem 
t = 0:Ts:t_final;                       % Vetor tempo

% Sinal a ser modulado e portadora
m = Am*cos(2*pi*fm.*t);
c = Ac*cos(2*pi*fc.*t);
m_dsb = Ao + m;

% Modulacao AM DSB SC e AM DSB
s_AM_DSB_SC = m.*c;
s_AM_DSB = m_dsb.*c;

% Potencia dos sinais
P_AM_DSB_SC = ((norm(s_AM_DSB_SC)).^2)/length(t);
P_AM_DSB = ((norm(s_AM_DSB)).^2)/length(t);

%% Sinais originais e modulados no domínio do tempo
figure(1)
subplot(5,1,1)
plot(t,m,'r')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal m(t)')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

subplot(5,1,2)
plot(t,m_dsb,'y')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal m(t) + Ao')
axis([0 t_final/200 -1 4])  

subplot(5,1,3)
plot(t,c,'g')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('Sinal c(t)')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

subplot(5,1,4)
plot(t,s_AM_DSB_SC,'k')
ylabel('Amplitude')
xlabel('Tempo (s)')
title('AM DSB SC')
axis([0 t_final/200 -1.5*Am 1.5*Am])  

subplot(5,1,5)
plot(t,s_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
title('AM DSB')
axis([0 t_final/200 -5*Am 5*Am])  

f_passo = 1/t_final;                   
f = -fs/2:f_passo:fs/2; 

M = fftshift(fft(m)/length(m));
C = fftshift(fft(c)/length(c));
S_AM_DSB_SC = fftshift(fft(s_AM_DSB_SC)/length(s_AM_DSB_SC));
S_AM_DSB = fftshift(fft(s_AM_DSB)/length(s_AM_DSB));

%% Sinais originais e modulados no domínio da frequencia
figure(2)
subplot(4,1,1)
plot(f,abs(M),'r');
axis([-2*fm 2*fm 0 0.8]);
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal M(f)')

subplot(4,1,2)
plot(f,abs(C),'g');
axis([-2*fc 2*fc 0 0.8]);
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('Sinal C(f)')

subplot(4,1,3)
plot(f,abs(S_AM_DSB_SC),'k');
axis([-2*fc 2*fc 0 0.5]);
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('AM DSB SC')

subplot(4,1,4)
plot(f,abs(S_AM_DSB));
axis([-2*fc 2*fc 0 1.5]);
ylabel('Amplitude')
xlabel('Frequencia (Hz)')
title('AM DSB')

%% Demodulacao do sinal AM DSB SC 
m1 = s_AM_DSB_SC.*c;

filtro = fir1(50,(2*1500)/fs);
sinal_final = filter(filtro,1,m1);

M1 = fftshift(fft(m1)/length(m1));
SINAL_FINAL = fftshift(fft(sinal_final)/length(sinal_final));

figure(3)
subplot(4,1,1)
plot(t,m1,'g')
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('Sinal m1(t)')

subplot(4,1,2)
plot(f,abs(M1),'g');
ylabel('Amplitude')
xlabel('Frequência (Hz)')
axis([-2.2*fc 2.2*fc 0 0.5]);
title('Sinal m1(t) no dominio da frequencia')

subplot(4,1,3)
plot(t,sinal_final,'r');
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am])  
title('Sinal m(t) demodulado')

subplot(4,1,4)
plot(f,abs(SINAL_FINAL),'r');
ylabel('Amplitude')
xlabel('Frequência (Hz)')
axis([-2000 2000 0 0.5]);
title('Sinal m(t) demodulado no domenio da frequencia')

figure(4)
freqz(filtro)
title('Filtro passa-baixa com frequencia de corte de 1.5kHz')

%% Alterando o fator modulante na modulacao AM DSB
u = [0.25 0.5 0.75 1 1.5];

% Sinais AM DSB com diferentes fator de modulacao
s1_AM_DSB = Ac*(1+u(1)*m).*c;
s2_AM_DSB = Ac*(1+u(2)*m).*c;
s3_AM_DSB = Ac*(1+u(3)*m).*c;
s4_AM_DSB = Ac*(1+u(4)*m).*c;
s5_AM_DSB = Ac*(1+u(5)*m).*c;

figure(5)
subplot(5,1,1)
plot(t,s1_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('AM DSB com u = 0.25')

subplot(5,1,2)
plot(t,s2_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('AM DSB com u = 0.50')

subplot(5,1,3)
plot(t,s3_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('AM DSB com u = 0.75')

subplot(5,1,4)
plot(t,s4_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('AM DSB com u = 1')

subplot(5,1,5)
plot(t,s5_AM_DSB)
ylabel('Amplitude')
xlabel('Tempo (s)')
axis([0 t_final/200 -1.5*Am 1.5*Am]) 
title('AM DSB com u = 1.5')