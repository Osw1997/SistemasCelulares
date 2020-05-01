% % Práctica - Tarea: Propagación en ambientes celulares
% Parámetros iniciales
close all;
G_tx = 13;
G_rx = 3;
ht = 30;
hr = 1.5;
F = 900e6;
P_tx = 10;
c = 299.8e6;
lambda = c / F;
% Vector 'd'
delta = 0.01;
d = delta:delta:100;
% Expresión que determina la potencia recibida aproximada
% Potencia en espacio libre
P_rx1 = 10 * log10(P_tx * G_tx * G_rx) - 20 * log10(F) - 20 * log10(d) + 147.552;
% Potencia en superficie reflejante
P_rx2 = 10 * log10 (P_tx * G_tx * G_rx) - 20 * log10(F) - 20 * log10(d) + ...
        10 * log10(sin(2 * pi * ht * hr ./ (lambda * d)) .^ 2) + 153.57;
% Potencia en superficie reflejante aproximada
P_rx3 = 10 * log10(P_tx * G_tx * G_rx) + 20 * (log10(ht) + log10(hr)) ...
        - 40 * log10(d);

% Se muestran las gráficas
semilogy(d, P_rx1);
xlabel('d [metros]'); ylabel('P_{Rx}(d)');
title('Potencia en espacio libre'); 
figure;
semilogy(d, P_rx2);
xlabel('d [metros]'); ylabel('P_{Rx}(d)');
title('Potencia en superficie reflejante');
figure;
semilogy(d, P_rx3);
xlabel('d [metros]'); ylabel('P_{Rx}(d)');
title('Potencia en superficie reflejante aproximada');

figure;
plot(d, P_rx1); hold on;
plot(d, P_rx2); hold on;
plot(d, P_rx3);
legend('Potencia en espacio libre', 'Potencia en superficie reflejante',...
        'Potencia en superficie reflejante aproximada')