% % Realice un programa de MATLAB en el que:
% a.- Se distribuyan puntos uniformemente en un hex�gono
% de 1,000 m de radio.
clear; close all;
centro = [1e3, 1e3]; % [x, y]
vertices = 6;
radio = 1e3;
% angulo = (360 / puntos) * (2 * pi) / 360;
angulo = 2 * pi / vertices;
% Inicializa primer punto de figura
theta = 0;
% x_vector = zeros(1,vertices);
% y_vector = zeros(1,vertices);
% for n = 1:vertices
%     x_vector(n) = centro(1) + radio * cos(theta);
%     y_vector(n) = centro(2) + radio * sin(theta);
%     theta = theta + angulo;
% end
puntVertices = centro(:) + [radio * cos(0:angulo:2*pi-angulo);
                            radio * sin(0:angulo:2*pi-angulo)];
pgon = polyshape(puntVertices');
% N�meros aleatorios
a = centro(1) - radio; b = centro(1) + radio;
N = 10000;
rx = a + (b-a).*rand(1,N);
a = centro(2) - radio; b = centro(2) + radio;
ry = a + (b-a).*rand(1,N);
puntosValidos = [rx(isinterior(pgon, rx, ry));
                 ry(isinterior(pgon, rx, ry))];
totalPuntos = sum(isinterior(pgon, rx, ry));
% Hex�gono
plotHex = plot(pgon);
plotHex.FaceColor = [0 1 0];
% Puntos v�lidos
hold on;
plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'k.');
grid on;
title(['Hex�gono con ',num2str(totalPuntos),' puntos v�lidos - Centro [1Km, 1Km]']);
xlabel('x[m]'); ylabel('y[m]');

% b.- Para cada punto, calcule la potencia recibida de acuerdo a
% expresi�n de la diapositiva 10. Suponga que el transmisor es una estaci�n
% base (EB) en el centro del hex�gono. Note que el t�rmino ?0 es una
% v.a. gaussiana con media cero y desviaci�n est�ndar ??, por lo que este
% t�rmino cambia en cada ejecuci�n del programa.
Ptx = 30;
Gtx = 10;
Grx = 10;
alf = 2;
f = 900 * 10^6;

% Distancia del centro a cada punto v�lido
% distPunto = sqrt(sum(puntosValidos' - centro)');
dist = sqrt((puntosValidos(1,:) - centro(1)).^2 + ...
            (puntosValidos(2,:) - centro(2)).^2);
        
% Media
media = 0;
% Desviaci�n est�ndar
sigma = sqrt(sum((dist - media).^2) / length(dist));
       
LD = zeros(1,totalPuntos);
LE = zeros(1,totalPuntos);
Prx = zeros(1,totalPuntos);

corridas = 10; 
vectorPot = zeros(1,corridas);
vectorDist = zeros(1,corridas);
vectorLD = zeros(1,corridas);
vectorLS = zeros(1,corridas);

for m = 1:corridas
%     % N�meros aleatorios
%     a = centro(1) - radio; b = centro(1) + radio;
%     N = 10000;
%     rx = a + (b-a).*rand(1,N);
%     a = centro(2) - radio; b = centro(2) + radio;
%     ry = a + (b-a).*rand(1,N);
%     puntosValidos = [rx(isinterior(pgon, rx, ry));
%                      ry(isinterior(pgon, rx, ry))];
%     totalPuntos = sum(isinterior(pgon, rx, ry));
%     % Distancia del centro a cada punto v�lido
%     dist = sqrt((puntosValidos(1,:) - centro(1)).^2 + ...
%                 (puntosValidos(2,:) - centro(2)).^2);
%     % Desviaci�n est�ndar
%     sigma = sqrt(sum((dist - media).^2) / length(dist));
%     
    min = Inf;
    for n = 1:totalPuntos
        % P�rdida por distancia
        LD(n) = 10 * alf * log10(dist(n));
        % P�rdida por ensombrecimiento.
%         LE(n) = 1/(sqrt(2*pi) * sigma) * exp(-(dist(n)-media)^2 / (2*sigma^2));
        LE(n) = sigma * randn(1);
        Prx(n) = Ptx + Gtx + Grx - LD(n) - LE(n);
        if Prx(n) < min
            min = Prx(n);
            vectorPot(m) = min;
            vectorDist(m) = dist(n);
            vectorLD(m) = LD(n);
            vectorLS(m) = LE(n);
        end
    end
end

% c.- Despu�s de ejecutar el programa identifique el punto donde se haya
% rec   ibido la potencia m�s baja y reporte: potencia recibida, distancia a
% la EB, p�rdidas por distancia y p�rdidas por ensombrecimiento. Reporte
% estos valores para 10 corridas (en una tabla).
% �Qu� concluye de estos resultados?
vectorPot;
vectorDist;
vectorLD;
vectorLS;
% % d .-Muestre la potencia recibida en los puntos del hex�gono como
% % un mapa de calor (ana�logo a la primera figura de la diapositiva 14).
% se normaliza la  potencia
normPot = Prx ./ max(abs(Prx));
% caxis([-1 1])
% plot3(puntosValidos(1,:), puntosValidos(2,:),normPot, '.');
figure;
scatter3(puntosValidos(1,:), puntosValidos(2,:),normPot,100,normPot);
title('Mapa de calor con LOS para el hex�gono de 1Km de radio.')
colorbar;
xlabel('x[m]'); ylabel('y[m]'); zlabel('Potencia - normalizada');

% % histograma de potencia
figure;
h = histogram(Prx);
title('Histograma de potencia');
xlabel('P_{rx}[dBm]'); ylabel('No. muestras');