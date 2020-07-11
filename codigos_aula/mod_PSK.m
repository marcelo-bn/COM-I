clear all
close all
clc

% Aula dia 23/06

M = 4;
SNR_Max = 15;

info = randint(1,100000,M);
%info_mod = exp(j*2*pi*info/M);
info_mod = pskmod(info, M);

for SNR = 0 : SNR_Max
    info_rec = awgn(info_mod, SNR);
    info_det = pskdemod(info_rec, M);
    [num_err(SNR+1), SER(SNR+1)] = symerr(info, info_det);
end

semilogy([0:SNR_Max],SER)
xlabel('SNR')
ylabel('Taxa de Erro de Simbolo (SER)')
title('Desempenho de erro de simbolo para o M-PSK')


