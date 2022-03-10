%% Projeto de filtro Passa Alta
clc;
clear all;

%% Parametros do projeto:
fr=800;
fp=1000;
fs=8000;
or=(2*pi*fr)/fs;
op=(2*pi*fp)/fs;

%% Determinando a frequencia de corte:
oc=(op+or)/2

%% Reposta ao Impulso
%  Banda de Rejeição de -60dB
%  Janela de Blackman
M=ceil(11*pi/(op-or));
M= M + 1;                               % filtro tipo 1: simetrico (M ímpar) 
N=(M-1)/2; 

n=0:M-1;

h=-(sin(oc*(n-N))./((n-N)*pi));         % vetor linha
h(N+1)=1-oc/pi;  
h=h(:);                                 % vetor coluna
W=blackman(M);

%% Resposta ao impulso
hf=h.*W;
og=linspace(0,pi,2400);
H=freqz(hf,1,og);                        % calcula a reposta em frequencia

f=linspace(0,fs/2,2400);                 % frequencia analogica

%% Salvando o Filtro
save('filtro_passa_alta','hf');

%% Plotando o filtro digital
f1=figure;
a1=axes;
plot(og, 20*log10(abs(H)));
