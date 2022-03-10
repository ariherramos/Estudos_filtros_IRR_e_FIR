%% Projeto de filtro Passa faixa
clc;
clear all;

%% Parametros do projeto:
fr1=700;
fp1=900;
fp2=1200;
fr2=1400;
fs=8000;

or1=(2*pi*fr1)/fs;
op1=(2*pi*fp1)/fs;
or2=(2*pi*fr2)/fs;
op2=(2*pi*fp2)/fs;

lbt1=op1-or1;
lbt2=or2-op2;                           % ambas larguras de banda de transição possuem o mesmo tamanho

%% Determinando a frequencia de corte:
oc1=(op1+or1)/2;
oc2=(op2+or2)/2;

%% Reposta ao Impulso
%  Banda de Rejeição de -55dB
%  Janela de Blackman

M=ceil(11*pi/(op1-or1));                % qualquer largura serve para este caso
M= M + 1;                               % filtro tipo 1: simetrico (M ímpar) 
N=(M-1)/2; 

n=0:M-1;

h= (oc1/pi)*sin(oc1*(n-N))./(oc1*(n-N)) - (oc2/pi)*sin(oc2*(n-N))./(oc2*(n-N));
h(N+1)= (oc1-oc2)/pi; 

h=h(:);                                 % vetor coluna
W=blackman(M);

%% Resposta ao impulso
hf=h.*W;

og = linspace(0, pi, 10024);
H  = freqz(hf, 1, og);
f  = linspace(0,fs/2,10024);            % frequencia analogica

save('filtro_passa_faixa.mat', 'hf');

%% Plotando o filtro digital
f1 = figure;
a1 = axes;

plot(og, 20*log10(abs(H)));
