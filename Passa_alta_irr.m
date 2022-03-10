clear;
clc;

%% Parametros de Projeto (Filtro Passa-Alta)
fs = 8000;

Rp = -0.2;
Rr = -60;

fr = 800;
fp = 1000;

wr = 2*pi*fr;
wp = 2*pi*fp;

%% Filtro Digital Equivalente
Or = wr/fs;
Op = wp/fs;

%% Filtro Analogicoa com Freq. Pré DIstorcida
p_wr = 2*fs*tan(Or/2);
p_wp = 2*fs*tan(Op/2);

%% Filtro Prototipo (Passa-Baixa Normalizado)
n_wp = 1;
n_wr = p_wp/p_wr;

%% Ordem da funçao chebyshev II
N = acosh(sqrt( (10^(-Rr/10) - 1) / (10^(-Rp/10) -1))) / (acosh(n_wr/n_wp));
N = ceil(N);

[z, p, k] = cheb2ap(N, -Rr);   %%Tipo 2:N e -Rr
n_num = k*poly(z);
n_den = poly(p);


w = linspace(0, 3, 1e4); 
H = freqs(n_num, n_den, w);
%%figure; plot(w, 20*log10(abs(H))); grid on;

%% Filtro Passa-ALta (com Freq. Pré DIstorcida)
[num, den] = lp2hp(n_num, n_den, p_wp);

% w = linspace(0, 2*pi*900, 1e4); 
% H = freqs(num, den, w);
% figure; plot(w/(2*pi), 20*log10(abs(H))); grid on;

%% Filtro Digital
[z_num, z_den] = bilinear(num, den, fs);

Og = linspace(0, pi, 1e4);
H = freqz(z_num, z_den, Og);
figure; plot(Og, 20*log10(abs(H))); grid on;

save('filtro_passa_alta_irr.mat', 'z_num', 'z_den');