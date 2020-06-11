close all
clear all
clc

% Sistema 1:
% Transmissão utilizando sinalização NRZ unipolar 
% com amplitude de 1V e 2V, ambos sem a utilização
% de filtro casado

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
A1 = 1;
A2 = 2;
% Limiares
limiar1 = A1/2;
limiar2 = A2/2;
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
info_uni_1 = info.*A1;
info_uni_2 = info.*A2;

% Filtro formatador
filtro_NRZ = ones(1,N); 

% Superamostragem
info_up_uni_1 = upsample(info_uni_1,N); 
info_up_uni_2 = upsample(info_uni_2,N); 

% Filtragem para formatar o sinal
sinal_tx_uni_1 = filter(filtro_NRZ,1,info_up_uni_1);
sinal_tx_uni_2 = filter(filtro_NRZ,1,info_up_uni_2);


for SNR = 0 : SNR_max
    % Canal AWGN para diferentes valores de SNR
    sinal_rx_uni_1 = awgn(sinal_tx_uni_1,SNR);
    sinal_rx_uni_2 = awgn(sinal_tx_uni_2,SNR);
    
    % Sinal detectado
    sinal_det_sem_FC_uni_1 = sinal_rx_uni_1(N/2:N:end);
    sinal_det_sem_FC_uni_2 = sinal_rx_uni_2(N/2:N:end);
    
    % Estimativa de erro
    info_est_sem_FC_uni_1 = sinal_det_sem_FC_uni_1 > limiar1;
    info_est_sem_FC_uni_2 = sinal_det_sem_FC_uni_2 > limiar2;
    
    % Probabilidade de erro 
    Pb_uni_1(SNR+1) = sum(xor(info,info_est_sem_FC_uni_1))/length(info);
    Pb_uni_2(SNR+1) = sum(xor(info,info_est_sem_FC_uni_2))/length(info);
    
end

% Plotando BER
figure(1)
semilogy([0:SNR_max],Pb_uni_1);
hold on;
semilogy([0:SNR_max],Pb_uni_2);
xlabel('SNR');
ylabel('Probabilidade de Erro de Bit'); 
legend('Unipolar 1V','Unipolar 2V');







