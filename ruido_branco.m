clc 
close all
clear all

ruido = randn(1,100000);
mean(ruido)
var(ruido)
figure(1)
hist(ruido, 100)
Ex2 = sum((ruido.^2)/length(ruido))  % E[X^2] (Potência total) = E[X]^2 (DC) + VAR (AC) 

nova_media = ruido + 5;
mean(nova_media)
var(nova_media)
figure(2)
hist(nova_media, 100)
Ex2_novo = sum((nova_media.^2)/length(nova_media))

nova_var = sqrt(5)*ruido;
var(nova_var)



