clc 
close all

info = randi([0 1],1,100e3)*2-1;
info_format = rectpulse(info,100);
var = 0.001;
ruido = sqrt(var)*randn(1,length(info_format));       % Alterando a variância do ruído (SNR)
r = info_format + ruido;

Rx = xcorr(info_format);                              % Autocorrelação
Gx = fft(Rx);                                         % Densidade espectral de potência
Gx = fftshift(Gx);
figure(1)
plot(abs(Gx));
title('Densidade Espectral de Potência (W/Hz)')

figure(2)
plot(r)
xlim([0 1000])
title('Sinal com ruído')
