%% Testador de Filtros

clear;
clc;

%%teste do filtro->carrega o arquivo
load('filtro_passa_alta');
%% sinal de entrada

f0=1000;             %%testar com 800, 900, 1000
fs=8000;

n=0:2400; 

x=cos(2*pi*f0*n/fs); 

%%filtragem
y=filter(hf,1,x);

f1=figure;a1=axes;
plot(x,'b');hold on; plot(y,'k');