% % 1- Realice un programa que genere una señal OFDM en el dominio del 
% % tiempo, usando los parámetros que se muestran en las filas 1 a 4 de la
% % siguiente tabla.
% Parámetros
close all; clear;
df = 1500;
Tu = 1 / 1000;
Nc = 16;
Ts = 1 / 6e3;
fs = 1 / Ts;
N = 16;
modulo = 3840;
% Senal de datos ¿En un segundo?
x = randi([0 1], 1, N);
x(x == 0) = -1;
% Número de muestras por símbolo = 6 ya que Tu / Ts = 6
x_s = repelem(x, Tu / Ts);
buffer = reshape(x_s, [Tu / Ts, N])';
salida = zeros(N, Tu / Ts);
t = 0:Ts:Tu - Ts;
for n = 1:N
    coefs = exp(1i * 2 * pi * df * (n - 1) * t);
    salida(n,:) = buffer(n,:) .* coefs;
end
x_t = sum(salida);

% % 2- Grafique la magnitud de la señal generada.
% t = 0:Ts:1 - Ts;

% t = 0:Ts:1 - Ts;
plot(t, abs(x_t)); title('Señal x generada'); xlabel('t'); ylabel('x(t)');

% % 3- Utilice la IFFT para crear las muestras de x(t) a partir de los bits
% % utilizados en la actividad 1, es decir, genere la señal xn.
% Afortunadamente, 6000 es divisible entre 16 (375 veces), por lo que no
% será necesario usar ceros de relleno
figure;
% subplot(2,1,1)
x=abs(sum(salida));
N = 6;

fact = (Tu / Ts) / N;
t_nn = 0:Ts * fact:Tu - Ts * fact;
plot(t_nn, x);
% N = modulo
% N = Tu / Ts;
N = 16;
fourier = N * ifft(buffer(:,1),N);
hold on;
fact = (Tu / Ts) / N;
t_nn = 0:Ts * fact:Tu - Ts * fact;
plot(t_nn,abs(fourier));
legend('Exponencial N = 6','IFFT, N = 16');
xlabel('f'); ylabel('x(f)')
title('x_n');

               
figure;
T = 1/fs;             % Sampling period       
L = fs;             % Length of signal
t = (0:L-1) * T;        % Time vector
n = 2^nextpow2(L);
f = fs*(0:(n/2))/n;
for m = 1:N
    hold on
    Y = Ts * fft(salida(m,:),n);
%     pause(1)
%     fx=(n_/Fs).*[-fs/2:fs/2-1];
    fx = 0:(fs/n):2 *(fs/2-fs/n) + (fs/n);
    plot(fx,abs(fftshift(Y)))
end
xlabel('f'); ylabel('x(f)')
title('Espectro de x(t)');


% Ahora con diferentes muestras
NN = [8 20 32 64];
figure;  hold on;
for n = 1:length(NN)
    fact = (Tu / Ts) / NN(n);
    t_nn = 0:Ts * fact:Tu - Ts * fact;
    fourier_nn = Nc * ifft(buffer(:,1),NN(n));
    plot(t_nn,abs(fourier_nn))
end
x=abs(sum(salida));
N = 6;

fact = (Tu / Ts) / N;
t_nn = 0:Ts * fact:Tu - Ts * fact;
plot(t_nn, x);

N = 16;
fourier = N * ifft(buffer(:,1),N);
fact = (Tu / Ts) / N;
t_nn = 0:Ts * fact:Tu - Ts * fact;
plot(t_nn,abs(fourier));
xlabel('t'); ylabel('x(t)')
title('Ejercicio 6');
legend('IFFT, N = 8', 'IFFT, N = 20', 'IFFT, N = 32', 'IFFT, N = 64', ...
       'Exponencial N = 6','IFFT, N = 16');
 
