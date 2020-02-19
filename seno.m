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
y = A*sin(2*pi*fm.*t)+(A/3)*sin(2*pi*3*fm.*t)+(A/5)*sin(2*pi*5*fm.*t)+(A/7)*sin(2*pi*7*fm.*t);
plot(t,y,'r');
axis([0 t_final/200 -1.5*A 1.5*A])      % Janela de visualização até o primeiro período 

subplot(3,1,2)
Y = fft(y)/length(y);                   % Transformada de Fourier (Dividindo o sinal pelo comprimento do vetor
plot(abs(fftshift(Y)),'g');             % Módulo e deslocamento da janela de visualização

subplot(3,1,3)
f_passo = 1/t_final;                    % t_final é responsável por limitar o sinal
f = -fs/2:f_passo:fs/2;                 % Eixo da frequência
plot(f,abs(fftshift(Y)),'m');
axis([-9*fm 9*fm 0 1.5*A]);





