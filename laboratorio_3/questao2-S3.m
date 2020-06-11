close all
clear all
clc

% Sistema 3
% Transmissão utilizando sinalização NRZ 
% unipolar e bipolar, ambos com a utilização 
% de filtro casado;

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
% Limiar
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
info_unipolar = info * A;
info_bipolar = (info*2)-A;

% Filtro formatador
filtro_NRZ = ones(1,N); 

% Superamostragem
info_up_unipolar = upsample(info_unipolar,N); 
info_up_bipolar = upsample(info_bipolar,N); 

% Filtragem para formatar o sinal
sinal_tx_unipolar = filter(filtro_NRZ,1,info_up_unipolar);
sinal_tx_bipolar = filter(filtro_NRZ,1,info_up_bipolar);

% Filtro Casado
filtro_casado_rx = fliplr(filtro_NRZ);


for SNR = 0 : SNR_max
    % Canal AWGN para diferentes valores de SNR
    sinal_rx_unipolar = awgn(sinal_tx_unipolar,SNR);
    sinal_rx_bipolar = awgn(sinal_tx_bipolar,SNR);
  
    % Filtrando os sinais
    sinal_rx_filtrado_uni = filter(filtro_casado_rx,1,sinal_rx_unipolar)/N;
    sinal_rx_filtrado_bi = filter(filtro_casado_rx,1,sinal_rx_bipolar)/N;
    
    % Sinal detectado COM filtro casado 
    sinal_det_com_FC_uni = sinal_rx_filtrado_uni(N:N:end);
    sinal_det_com_FC_bi = sinal_rx_filtrado_bi(N:N:end);
    
    % Estimativa de erro
    info_est_com_FC_uni = (sinal_det_com_FC_uni > limiar);
    info_est_com_FC_bi = (sinal_det_com_FC_bi > limiar);
    
    % Probabilidade de erro 
    Pb_com_FC_uni(SNR+1) = sum(xor(info,info_est_com_FC_uni))/length(info);
    Pb_com_FC_bi(SNR+1) = sum(xor(info,info_est_com_FC_bi))/length(info);
end

% Plotando BER
figure(1)
semilogy([0:SNR_max],Pb_com_FC_uni);
hold on;
semilogy([0:SNR_max],Pb_com_FC_bi);
xlabel('SNR');
ylabel('Probabilidade de Erro de Bit'); 
legend('NRZ Unipolar','NRZ Bipolar');







