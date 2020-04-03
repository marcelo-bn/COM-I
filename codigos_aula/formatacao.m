clear all
close all
clc

A = 1;
f = 1000;
N = 100;
fs = N*f;   
num_periodos = 1000;
tempo_final = num_periodos*(1/f);
t = [0:1/fs:tempo_final/1000];
f_passo = 1/(tempo_final/1000);
eixo_f = [-fs/2:f_passo:fs/2];

% Sinal amostrado (ja pelo matlab)
y = A*sin(2*pi*f*t);

% Numero de bits d quantizador
k = 3;

% Numero de niveis de quantizacao
L = 2^k;

% Passo dos niveis
passo = 2*A/L;

% Dividindo o sinal pelo passo para
% Ampliar a escala do seno para se ter mais 
% inteiros e poder arredondar
y_aux = y./passo;

% Arredondando as amostras
y_round = round(y_aux);

% Ajustando a escala para os niveis serem
% de 0 até L. 
y_int = y_round + (L/2);

% Deixando a escala de 0 ate L-1
for i=1:length(y_int)
    if y_int(i) == L
        y_int(i) = L-1;
    end
end

% Seq. bin transmitida
y_bin = dec2bin(y_int); 

% Considerando que o receptor identificou 
% corretamente os bits. Reformatando o sinal
y_rec = bin2dec(y_bin);
y_rec2 = y_rec - (L/2);
y_rec3 = y_rec2*passo;


figure(1)
plot(t,y)
title('Sinal original')

figure(2)
plot(t,y_aux)
title('Sinal original dividido pelo passo')

figure(3)
plot(t,y_round)
title('Sinal com amostras arredondadas')

figure(4)
plot(t,y_int)
title('Sinal com amostras arredondadas deslocadas para cima L/2')

figure(5)
plot(t,y_rec)
title('Sinal recuperado')

figure(6)
plot(t,y_rec2)
title('Sinal com amostras arredondadas deslocadas para baixo L/2')

figure(7)
hold on 
plot(t,y_rec3)
plot(t,y)
title('Sinal multiplicado pelo passo e sinal original em vermelho')


% Frequencias que surgem devido a 
% quantizacao por isso se usa os 
% filtros passa faixa
Y = fftshift(fft(y))/length(y);
Y_rec3 = fftshift(fft(y_rec3))/length(y_rec3);

figure(8)
subplot(2,1,1)
plot(eixo_f,abs(Y))
title('Sinal original')
subplot(2,1,2)
plot(eixo_f,abs(Y_rec3))
title('Sinal recuperado')

% Quanto mais bits de quantizao 
% menos erro e menos frequencias indesejadas 
% ira ter o sinal 



