clc
clear all
close all
n_sym = 1000;
var_sym = 5; 
SNR = 130;
M = 2;
info = pam(n_sym,M,var_sym);    
N = 20;
info_up = upsample(info, N);
filtro_NRZ = ones(1,N); 
filtro_tx = hamming(1*N); # variar para ver ISI
canal = [0.5 1 -0.6];
filtro_canal = upsample(canal,N);

pam_rect = filter(filtro_NRZ,1,info_up);               
info_tx = filter(filtro_tx,1,info_up);

% Passando pelo canal
pam_rx_out = filter(filtro_canal,1, pam_rect);
info_rx_out = filter(filtro_canal, 1, info_tx);

% AWGN
pam_rx = awgn(pam_rx_out,1,SNR);
info_rx = awgn(info_rx_out,1,SNR);

neye=5; % size of groups
c=floor(length(info_tx)/(neye*N)); % number of eyes to plot
xp=info_tx(n_sym*N-neye*N*c+1:n_sym*N);  

c_rect=floor(length(pam_rect)/(neye*N));    
xp_rect=pam_rect(n_sym*N-neye*N*c+1:n_sym*N); 

neye=5; % size of groups
c=floor(length(info_tx)/(neye*N)); % number of eyes to plot
xp_rx=info_rx(n_sym*N-neye*N*c+1:n_sym*N);  

c_rect=floor(length(pam_rect)/(neye*N));    
xp_rect_rx=pam_rx(n_sym*N-neye*N*c+1:n_sym*N); 

figure(1)
t_sym = [1/N:1/N:length(info_tx)/N];
subplot(411)
plot(t_sym, pam_rect)
xlim([0 20])
ylim([-3.5 3.5])
subplot(412)
plot(t_sym, info_tx);
xlim([0 20]) 
ylim([-3.5 3.5])
[h,w] = freqz(filtro_tx);
subplot(413)
semilogy(w/pi,abs(h))
subplot(414)
plot(filtro_tx)

figure(2)
subplot(211)
plot(reshape(xp,neye*N,c))       
title('Eye diagram for hamming pulse shape')
subplot(212)
plot(reshape(xp_rect,neye*N,c))      
title('Eye diagram for rect pulse shape')

figure(3)
subplot(211)
plot(t_sym, info_tx)
xlim([0 20]) 
ylim([-3.5 3.5])
subplot(212)
plot(t_sym, info_rx)
xlim([0 20]) 
ylim([-3.5 3.5])

figure(4)
subplot(211)
plot(reshape(xp_rx,neye*N,c))       
title('Eye diagram for hamming pulse shape')
subplot(212)
plot(reshape(xp_rect_rx,neye*N,c))      
title('Eye diagram for rect pulse shape')

pulso_dist = filter(filtro_canal, 1, filtro_tx);
figure(5)
plot(pulso_dist)
hold on
plot(filtro_tx)


