clc
close all

A = 6;
fm = 1000;                              % Frequência do seno
N = 200;                                % Fator de superamostragem
fs = N*fm;                              % Frequência de amostragem
num_periodos = 250;                     % Número de períodos
t_final = num_periodos*(1/fm);          % Dois períodos
Ts = 1/fs;                              % Tempo de amostragem 
t = 0:Ts:t_final;                       % Vetor tempo

subplot(5,1,1)
y = (A/2)*cos(2*pi*fm.*t)+A*cos(2*pi*2*fm.*t);
plot(t,y,'r');
axis([0 t_final/200 -1.5*A 1.5*A])      % Janela de visualização até o primeiro período 

subplot(5,1,2)
Y = fft(y)/length(y);                   % Transformada de Fourier (Dividindo o sinal pelo comprimento do vetor
Y = fftshift(Y);
plot(abs(Y),'g');                       % Módulo e deslocamento da janela de visualização

subplot(5,1,3)
f_passo = 1/t_final;                    % t_final é responsável por limitar o sinal
f = -fs/2:f_passo:fs/2;                 % Eixo da frequência
plot(f,abs(Y),'m');
axis([-9*fm 9*fm 0 1.5*A]);

filtro_PB = [zeros(1,24625) ones(1,751) zeros(1,24625)];
Y_filtro = abs(Y).*filtro_PB;

subplot(5,1,4)
plot(f,filtro_PB)
ylim([0,1.5])
xlim([-10e3 10e3])
title('Filtro PB')

subplot(5,1,5)
plot(f,Y_filtro)
title('Sinal Filtrado')

