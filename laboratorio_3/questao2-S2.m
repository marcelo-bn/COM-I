close all
clear all
clc

% Sistema 2
% Transmissão utilizando sinalização 
% NRZ unipolar com amplitude de 1V, 
% com e sem filtro casado.

% Niveis de transmissao
M = 2;
% Fator de superamostragem
N = 5; 
% Fator SNR (dB)
SNR_max = 18;
% Taxa de transmissao (bits/s)
Rb = 1e4;
% Periodo da taxa
Tb = 1/Rb;
% Amplitudes
A = 1;
% Limiares
limiar = A/2;
% Frequencia de amostragem
Fs = N*Rb;
% Passo tempo
passo_tempo = 1/(Fs);
% Tempo final 
t_final = 1;
% Eixo tempo
t = [0:passo_tempo:t_final-passo_tempo];

% Informacao
info = randint(1,Rb*t_final);
info_uni_1 = info.*A;

% Filtro formatador
filtro_NRZ = ones(1,N); 

% Superamostragem
info_up_uni_1 = upsample(info_uni_1,N); 

% Filtragem para formatar o sinal
sinal_tx_uni_1 = filter(filtro_NRZ,1,info_up_uni_1);

% Filtro Casado
filtro_casado_rx = fliplr(filtro_NRZ);


for SNR = 0 : SNR_max
    % Canal AWGN para diferentes valores de SNR
    sinal_rx_uni_1 = awgn(sinal_tx_uni_1,SNR);
  
    % Sinal detectado SEM filtro casado
    sinal_det_sem_FC_uni_1 = sinal_rx_uni_1(N/2:N:end);
    
    % Sinal detectado COM filtro casado 
    sinal_rx_filtrado = filter(filtro_casado_rx,1,sinal_rx_uni_1)/N;
    sinal_det_com_FC_uni_1 = sinal_rx_filtrado(N:N:end);
    
    % Estimativa de erro
    info_est_sem_FC_uni_1 = sinal_det_sem_FC_uni_1 > limiar;
    info_est_com_FC_uni_1 = sinal_det_com_FC_uni_1 > limiar;
    
    % Probabilidade de erro 
    Pb_sem_FC_uni_1(SNR+1) = sum(xor(info,info_est_sem_FC_uni_1))/length(info);
    Pb_com_FC_uni_1(SNR+1) = sum(xor(info,info_est_com_FC_uni_1))/length(info);
end

% Plotando BER
figure(1)
semilogy([0:SNR_max],Pb_sem_FC_uni_1);
hold on;
semilogy([0:SNR_max],Pb_com_FC_uni_1);
xlabel('SNR');
ylabel('Probabilidade de Erro de Bit'); 
legend('Sem Filtro Casado','Com Filtro Casado');







