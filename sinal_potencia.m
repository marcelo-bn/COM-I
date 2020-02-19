clc
close all

A = 6;
fm = 1000;                              % Frequência do seno
N = 200;                                % Fator de superamostragem
fs = N*fm;                              % Frequência de amostragem
num_periodos = 1000;                    % Número de períodos
t_final = num_periodos*(1/fm);          % Dois períodos
Ts = 1/fs;                              % Tempo de amostragem 
t = 0:Ts:t_final;                       % Vetor tempo

subplot(3,1,1)
y = cos(2*pi*fm*t) + 5*cos(2*pi*2*fm*t) + 2;
plot(t,y,'r');
axis([0 t_final/200 -1.5*A 1.5*A])      % Janela de visualização até o primeiro período 

subplot(3,1,2)
Y = fft(y)/length(y);                   % Transformada de Fourier (Dividindo o sinal pelo comprimento do vetor
plot(abs(fftshift(Y)),'g');             % Módulo e deslocamento da janela de visualização

subplot(3,1,3)
f_passo = 1/t_final;                    % t_final é responsável por limitar o sinal
f = -fs/2:f_passo:fs/2;                 % Eixo da frequência
plot(f,abs(fftshift(Y)),'m');           % O sinal é de potência pois é periódico
title('Sinal de potência (periódico)')
axis([-3000 3000 -4 4]);

pot_y = sum(y.^2)/length(y)             % Potência total do sinal



