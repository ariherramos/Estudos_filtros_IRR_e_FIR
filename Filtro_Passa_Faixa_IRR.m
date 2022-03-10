clear;
clc;

%% Projeto do Filtro
Rp = -0.25;
Rr = -55;

fs = 8000;

fr1 = 700;
fp1 = 900;
fp2 = 1200;
fr2 = 1400; 

wr1 = 2*pi*fr1;
wp1 = 2*pi*fp1;
wp2 = 2*pi*fp2;
wr2 = 2*pi*fr2;

%Filtro Digital Equivalente
or1 = wr1/fs;
op1 = wp1/fs;
op2 = wp2/fs;
or2 = wr2/fs;

% Frequencia Analogica Pre-Distorcida
p_wr1 = 2*fs*tan(or1/2);
p_wp1 = 2*fs*tan(op1/2);
p_wp2 = 2*fs*tan(op2/2);
p_wr2 = 2*fs*tan(or2/2);

% Simetria Geometrica
if (p_wp1*p_wp2 > p_wr1*p_wr2)
    p_wr1 = p_wp1*p_wp2/p_wr2;
else
    p_wp2 = p_wr1*p_wr2/p_wp1;
end

% Requisitos de Projeto do Filtro Prototipo (Normalizado)
p_wo = sqrt(p_wp1*p_wp2);
B = p_wp2 - p_wp1;

n_wp = 1;
n_wr = (p_wr2^2 - p_wo^2)/(p_wr2*B);

N = log10( (10^(-0.1*Rp) - 1)/(10^(-0.1*Rr) - 1) )/(2*log10(n_wp/n_wr));
N = ceil(N);

n_wc = n_wp/nthroot(10^(-0.1*Rp) - 1, 2*N);

% Filtro Prototipo (Normalizado)
[z, p, k] = buttap(N);
n_num = k*poly(z);
n_den = poly(p);

% w = linspace(0, 3, 1e4);
% H = freqs(n_num, n_den, w);
% figure; plot(w, 20*log10(abs(H))); grid on;

[n_num, n_den] = lp2lp(n_num, n_den, n_wc);

w = linspace(0, 3, 1e4);
H = freqs(n_num, n_den, w);
%%figure; plot(w, 20*log10(abs(H))); grid on;

% Filtro Passa-Faixa
[num, den] = lp2bp(n_num, n_den, p_wo, B);

w = linspace(0, 2*pi*1400, 1e4);
H = freqs(num, den, w);
%%figure; plot(w/(2*pi), 20*log10(abs(H))); grid on;

%Filtro Digital
[z_num, z_den] = bilinear(num, den, fs);

Og = linspace(0, pi, 1e4);
H = freqz(z_num, z_den, Og);

f = linspace(0, fs/2, 1e4);

figure; plot(Og, 20*log10(abs(H))); grid on;
save('filtro_passa_faixa_irr.mat', 'z_num', 'z_den');
