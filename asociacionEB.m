% % Asociación EB
% 1- Realice un programa que distribuya uniformemente puntos en un cluster
%  de 7 celdas: una celda central (a la que se le denominará celda 0) 
% rodeada por 6 celdas. Se sugiere distribuir unas pocas centenas 
% de usuarios por celda.
clear; close all;

vertices = 6; 
radio = 5e3;
angulo = 2 * pi / vertices;
distXhex = sqrt((2*radio)^2 - radio^2);
% Centros de hexagonos
factor = 2 / sqrt(3);
centro0 = [0, 0]; % [x, y]
centro1 = [0, 2 * radio];
centro2 = [-distXhex, radio];
centro3 = [-distXhex, -radio];
centro4 = [0, -2 * radio];
centro5 = [distXhex, -radio];
centro6 = [distXhex, radio];
CENTRO = [centro0;
          centro1;
          centro2;
          centro3;
          centro4;
          centro5;
          centro6];

pgon0 = getPol(centro0, radio, angulo);
pgon1 = getPol(centro1, radio, angulo);
pgon2 = getPol(centro2, radio, angulo);
pgon3 = getPol(centro3, radio, angulo);
pgon4 = getPol(centro4, radio, angulo);
pgon5 = getPol(centro5, radio, angulo);
pgon6 = getPol(centro6, radio, angulo);

% Hexágono
plotHex = plot(pgon0); hold on;
plotHex = plot(pgon1);
plotHex = plot(pgon2);
plotHex = plot(pgon3);
plotHex = plot(pgon4);
plotHex = plot(pgon5);
plotHex = plot(pgon6);
plotHex.FaceColor = [0 1 0];
grid on;
% Números aleatorios
a = centro0(1) - radio*4; b = centro0(1) + radio*4;
N = 10000;
rx = a + (b-a).*rand(1,N);
a = centro0(2) - radio*4; b = centro0(2) + radio*4;
ry = a + (b-a).*rand(1,N);

indxValidos = isinterior(pgon0, rx, ry) | isinterior(pgon1, rx, ry) | ...
              isinterior(pgon2, rx, ry) | isinterior(pgon3, rx, ry) | ...
              isinterior(pgon4, rx, ry) | isinterior(pgon5, rx, ry) | ...
              isinterior(pgon6, rx, ry);
          
puntosValidos = [rx(indxValidos);
                 ry(indxValidos)];          
totalPuntos = sum(indxValidos);
% totalPuntos = sum(isinterior(pgon, rx, ry));
hold on;
plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'g.');
xlabel('X[m]'); ylabel('Y[m]');
title('Distribución de usuarios en 7 celdas');

% Parámetros
Ptx = 10 * log10(10e3);
Gtx = 12;
Grx = 2;
alf = 4;
% Desviación estándar
ds = 0;

% Matriz de resultados
radioBases = 7;
PTX = zeros(radioBases, totalPuntos);

for m = 1:radioBases
    % Vector de distancias a la radio base
    dist = sqrt((puntosValidos(1,:) - CENTRO(m,1)).^2 + ...
                (puntosValidos(2,:) - CENTRO(m,2)).^2);
    for n = 1:totalPuntos
        LD = 10 * alf * log10(dist(n));
        LS = ds * randn(1);
        PTX(m,n) = Ptx + Gtx + Grx - LD - LS;
    end
end
% Vector de mejor radiobase por usuario
mejoresBases = mod(find((PTX == max(PTX(:,:)) == 1))', radioBases);
mejoresBases(mejoresBases == 0) = radioBases;
% Se extraen los resultados que sean de la base cero.
mejorB0Indx = find(mejoresBases == 1);
mejorB0Pot = PTX(1,mejorB0Indx);
% Coordenadas top 10.
coordB0 = puntosValidos(:,mejorB0Indx(1:10))';

figure;
plotHex = plot(pgon0); hold on; plot(pgon1); plot(pgon2); plot(pgon3);
plot(pgon4); plot(pgon5); plot(pgon6);
plotHex.FaceColor = [0 1 0];
grid on;
plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'g.');
xlabel('X[m]'); ylabel('Y[m]');
title('Puntos que perciben con mayor potencia al EB0');
hold on;
plot(puntosValidos(1,mejorB0Indx), puntosValidos(2,mejorB0Indx), 'k*');


function geo = getPol(centro, radio, angulo)
    puntVertices = centro(:) + [(radio*2/sqrt(3)) * cos(0:angulo:2*pi-angulo);
                                (radio*2/sqrt(3)) * sin(0:angulo:2*pi-angulo)];
    geo = polyshape(puntVertices');
end