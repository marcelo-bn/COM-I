close all
clear all
clc

% Fator de superamostragem
N = 5; 
% Eb/No (dB)
EbNo_max = 18;
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

for ebno = 0 : EbNo_max
    % Canal AWGN para diferentes valores de SNR 
    sinal_rx_unipolar = awgn(sinal_tx_unipolar,ebno);
    sinal_rx_bipolar = awgn(sinal_tx_bipolar,ebno);
  
    % Filtrando os sinais
    sinal_rx_filtrado_uni = filter(filtro_casado_rx,1,sinal_rx_unipolar)/N;
    sinal_rx_filtrado_bi = filter(filtro_casado_rx,1,sinal_rx_bipolar)/N;
    
    % Sinal detectado COM filtro casado 
    sinal_det_com_FC_uni = sinal_rx_filtrado_uni(N:N:end);
    sinal_det_com_FC_bi = sinal_rx_filtrado_bi(N:N:end);
    
    % Estimativa de erro
    info_est_com_FC_uni = (sinal_det_com_FC_uni > limiar);
    info_est_com_FC_bi = (sinal_det_com_FC_bi > limiar);
    
    % Probabilidade de erro para SNR (Pratica)
    Pb_uni_prat(ebno+1) = sum(xor(info,info_est_com_FC_uni))/length(info);
    Pb_bi_prat(ebno+1) = sum(xor(info,info_est_com_FC_bi))/length(info);
    
    % Probabilidade de erro para Eb/No linearizada
    Pb_uni_teor(ebno+1) = qfunc(sqrt(10^(ebno/10)));
    Pb_bi_teor(ebno+1) =  qfunc(sqrt(2*10^(ebno/10)));
     
end

% Plotando BER
figure(1)
semilogy([0:EbNo_max],Pb_uni_teor);
hold on;
semilogy([0:EbNo_max],Pb_bi_teor);
xlabel('Eb / No');
ylabel('Probabilidade de Erro de Bit'); 
legend('NRZ Unipolar','NRZ Bipolar');
title('Análise Teórica');
hold off;

figure(2)
semilogy([0:EbNo_max],Pb_uni_prat);
hold on,
semilogy([0:EbNo_max],Pb_bi_prat);
xlabel('SNR');
ylabel('Probabilidade de Erro de Bit'); 
legend('NRZ Unipolar','NRZ Bipolar');
title('Análise Prática');


