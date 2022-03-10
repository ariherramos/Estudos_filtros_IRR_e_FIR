clear;
clc;

%Carregar filtro
load('filtro_passa_alta_irr.mat');

% sinal de entrada
fs=8000;
f0=1050;


n=0:500;
xn=cos(2*pi*f0*n/fs);

%sinal filtrado

y=filter(z_num,z_den,xn);

%resultado
figure;
plot(n,xn); hold on;
plot(n,y,'k');