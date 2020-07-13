% % Realice un programa de MATLAB en el que:
% a.- Se distribuyan puntos uniformemente en un hexágono
% de 1,000 m de radio.
clear; close all;
centro = [1e3, 1e3]; % [x, y]
vertices = 6; 
radio = 5e3;
% angulo = (360 / puntos) * (2 * pi) / 360;
angulo = 2 * pi / vertices;
% Inicializa primer punto de figura
puntVertices = centro(:) + [radio * cos(0:angulo:2*pi-angulo);
                            radio * sin(0:angulo:2*pi-angulo)];
pgon = polyshape(puntVertices');
% Números aleatorios
a = centro(1) - radio; b = centro(1) + radio;
N = 10000;
rx = a + (b-a).*rand(1,N);
a = centro(2) - radio; b = centro(2) + radio;
ry = a + (b-a).*rand(1,N);
puntosValidos = [rx(isinterior(pgon, rx, ry));
                 ry(isinterior(pgon, rx, ry))];
totalPuntos = sum(isinterior(pgon, rx, ry));
% Hexágono
plotHex = plot(pgon);
plotHex.FaceColor = [0 1 0];
% Puntos válidos
hold on;
plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'g.');
grid on;
title(['Hexágono con ',num2str(totalPuntos),' puntos válidos - Centro [1Km, 1Km]']);
xlabel('x[m]'); ylabel('y[m]');

% b.- Para cada punto, calcule la potencia recibida de acuerdo a
% expresión de la diapositiva 10. Suponga que el transmisor es una estación
% base (EB) en el centro del hexágono. Note que el término ?0 es una
% v.a. gaussiana con media cero y desviación estándar ??, por lo que este
% término cambia en cada ejecución del programa.
Ptx = 10 * log10(10e3);
Gtx = 12;
Grx = 2;
alf = 4;
f = 900 * 10^6;

% Distancia del centro a cada punto válido
% distPunto = sqrt(sum(puntosValidos' - centro)');
dist = sqrt((puntosValidos(1,:) - centro(1)).^2 + ...
            (puntosValidos(2,:) - centro(2)).^2);
        
% Desviación estándar
sigma = 7;
% Media
media = 0;
% Vector de resultados
LD = zeros(1,totalPuntos);
LS = zeros(1,totalPuntos);
Prx = zeros(1,totalPuntos);

corridas = 1; 
vectorPot = zeros(1,corridas);
vectorDist = zeros(1,corridas);
vectorLD = zeros(1,corridas);
vectorLS = zeros(1,corridas);


probsOut = zeros(1,3);
m = 1;
for radio = 3e3:1e3:5e3
    vertices = 6;
    angulo = 2 * pi / vertices;
    puntVertices = centro(:) + [radio * cos(0:angulo:2*pi-angulo);
                                radio * sin(0:angulo:2*pi-angulo)];
    pgon = polyshape(puntVertices');
    % Números aleatorios
    a = centro(1) - radio; b = centro(1) + radio;
    N = 10000;
    rx = a + (b-a).*rand(1,N);
    a = centro(2) - radio; b = centro(2) + radio;
    ry = a + (b-a).*rand(1,N);
    puntosValidos = [rx(isinterior(pgon, rx, ry));
                     ry(isinterior(pgon, rx, ry))];
    totalPuntos = sum(isinterior(pgon, rx, ry));
       
    % Vector de distancias a la radio base
    dist = sqrt((puntosValidos(1,:) - centro(1)).^2 + ...
            (puntosValidos(2,:) - centro(2)).^2);
    LD = zeros(1,totalPuntos);
    LS = zeros(1,totalPuntos);
    Prx = zeros(1,totalPuntos);
    for n = 1:totalPuntos
        % Pérdida por distancia
        LD(n) = 10 * alf * log10(dist(n));
        % Pérdida por ensombrecimiento.
%         LS(n) = 1/(sqrt(2*pi) * sigma) * exp(-(dist(n) - media)^2 / (2*sigma^2));
        LS(n) = sigma * randn(1);
        Prx(n) = Ptx + Gtx + Grx - LD(n) - LS(n);
    end
%     % Sensibilidad del receptor
    S = -100;
    usersOut = sum(Prx < S);
% %     probOut = usersOut / totalPuntos;
    probsOut(m) = usersOut / totalPuntos;
    m = m + 1;
end
% probsOut
figure;
plot(3:6, probsOut, 'LineWidth', 2)
title('Probabilidad Outage Vs Radio');
xlabel('Distancia [Km]'); ylabel('P_{outage}');
grid on;



% % % Ahora con sigmas variables
probsOutSigma = zeros(1,7);
m = 1;
for sigma = 6:12
    LD = zeros(1,totalPuntos);
    LS = zeros(1,totalPuntos);
    Prx = zeros(1,totalPuntos);
    for n = 1:totalPuntos
        % Pérdida por distancia
        LD(n) = 10 * alf * log10(dist(n));
        % Pérdida por ensombrecimiento.
%         LS(n) = 1/(sqrt(2*pi) * sigma) * exp(-(dist(n) - media)^2 / (2*sigma^2));
        LS(n) = sigma * randn(1);
        Prx(n) = Ptx + Gtx + Grx - LD(n) - LS(n);
    end
%     % Sensibilidad del receptor
    S = -100;
    usersOut = sum(Prx < S);
% %     probOut = usersOut / totalPuntos;
    probsOutSigma(m) = usersOut / totalPuntos;
    m = m + 1;
end
% probsOut
figure;
plot(6:12, probsOutSigma, 'LineWidth', 2)
title('Probabilidad Outage Vs Desv. estándar');
xlabel('Desv. estándar [dB]'); ylabel('P_{outage}');
grid on;


% % % Ahora con potencia variable
probsOutPot = zeros(1,6);
sigma = 7;
m = 1;
for Ptx = 6:2:16
    LD = zeros(1,totalPuntos);
    LS = zeros(1,totalPuntos);
    Prx = zeros(1,totalPuntos);
    for n = 1:totalPuntos
        % Pérdida por distancia
        LD(n) = 10 * alf * log10(dist(n));
        % Pérdida por ensombrecimiento.
%         LS(n) = 1/(sqrt(2*pi) * sigma) * exp(-(dist(n) - media)^2 / (2*sigma^2));
        LS(n) = sigma * randn(1);
        Prx(n) = 10 * log10(Ptx * 10^3) + Gtx + Grx - LD(n) - LS(n);
    end
%     % Sensibilidad del receptor
    S = -100;
    usersOut = sum(Prx < S);
% %     probOut = usersOut / totalPuntos;
    probsOutPot(m) = usersOut / totalPuntos;
    m = m + 1;
end

figure;
plot(6:2:16, probsOutPot, 'LineWidth', 2)
title('Probabilidad Outage Vs Potencia');
xlabel('Potencia [W]'); ylabel('P_{outage}');
grid on;
