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

% % Hexágonos aledaños
% plotHex = plot(pgon0); hold on;
% plotHex = plot(pgon1);
% plotHex = plot(pgon2);
% plotHex = plot(pgon3);
% plotHex = plot(pgon4);
% plotHex = plot(pgon5);
% plotHex = plot(pgon6);
% plotHex.FaceColor = [0 1 0];
% grid on;
% Números aleatorios
a = centro0(1) - distXhex * 4; b = centro0(1) + 4 * distXhex;
N = 10000;
rx = a + (b-a).*rand(1,N);
a = centro0(2) - distXhex * 4; b = centro0(2) + 4 * distXhex;
ry = a + (b-a).*rand(1,N);

indxValidos = isinterior(pgon0, rx, ry) | isinterior(pgon1, rx, ry) | ...
              isinterior(pgon2, rx, ry) | isinterior(pgon3, rx, ry) | ...
              isinterior(pgon4, rx, ry) | isinterior(pgon5, rx, ry) | ...
              isinterior(pgon6, rx, ry);
          
puntosValidos = [rx(indxValidos);
                 ry(indxValidos)];          
totalPuntos = sum(indxValidos);
% % totalPuntos = sum(isinterior(pgon, rx, ry));
% plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'g.'); hold on;
% xlabel('X[m]'); ylabel('Y[m]');
% title('Distribución de usuarios en 7 celdas');

% Parámetros
Ptx = 10 * log10(10e3);
Gtx = 12;
Grx = 2;
alf = 4;
% Desviación estándar
ds = 4;

% Matriz de resultados
radioBases = 7;
PTX = zeros(radioBases, totalPuntos);

% Distribucion LogNormal
pd = makedist('Lognormal','mu',0,'sigma',1);


for m = 1:radioBases
    % Vector de distancias a la radio base
    dist = sqrt((puntosValidos(1,:) - CENTRO(m,1)).^2 + ...
                (puntosValidos(2,:) - CENTRO(m,2)).^2);
    for n = 1:totalPuntos
        LD = 10 * alf * log10(dist(n));
        LS = ds * randn(1);
%         LS = random(pd);
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
totalCoordB0 = puntosValidos(:,mejorB0Indx);
coordB0 = puntosValidos(:,mejorB0Indx(1:10))';




% % % Practica 7
% Hexagonos interferencia
centro1_ = [distXhex, 3 * radio];
centro2_ = [-distXhex, 3 * radio];
centro3_ = [-2 * distXhex, 0];
centro4_ = [-distXhex, -3 * radio];
centro5_ = [distXhex, -3 * radio];
centro6_ = [2 * distXhex, 0];
CENTRO_ = [centro1_;
           centro2_;
           centro3_;
           centro4_;
           centro5_;
           centro6_];
      
pgon1_ = getPol(centro1_, radio, angulo);
pgon2_ = getPol(centro2_, radio, angulo);
pgon3_ = getPol(centro3_, radio, angulo);
pgon4_ = getPol(centro4_, radio, angulo);
pgon5_ = getPol(centro5_, radio, angulo);
pgon6_ = getPol(centro6_, radio, angulo);

plotHex = plot(pgon0); hold on;
plotHex = plot(pgon1_); 
plotHex = plot(pgon2_);
plotHex = plot(pgon3_);
plotHex = plot(pgon4_);
plotHex = plot(pgon5_);
plotHex = plot(pgon6_);

% % Se calcula la potencia de interferencia por cada radiobase tipo A
totalPuntosB0 = length(mejorB0Indx);
vectorSINR = zeros(1, totalPuntosB0);
PK = zeros(6, totalPuntosB0);
N0 = 1e-10; % Watts
% for m = 1:6
%     % Vector de distancias a la radio base tipo A
%     dist = sqrt((totalCoordB0(1,:) - CENTRO_(m,1)).^2 + ...
%                 (totalCoordB0(2,:) - CENTRO_(m,2)).^2);
%     for n = 1:totalPuntosB0
%         LD = 10 * alf * log10(dist(n));
%         LS = random(pd);
%         PK(m,n) = Ptx + Gtx + Grx - LD - LS;
%     end
% end

for n = 1:totalPuntosB0
    for m = 1:6
        % Vector de distancias a la radio base tipo A
        dist = sqrt((totalCoordB0(1,n) - CENTRO_(:,1)).^2 + ...
                    (totalCoordB0(2,n) - CENTRO_(:,2)).^2);
        LD = 10 * alf * log10(dist(m));
%         LS = random(pd);
        LS = ds * randn(1);
        PK(m,n) = Ptx + Gtx + Grx - LD - LS;
    end
    % Se calcula la SINR por cada puntos
%     sumInterf = sum(PK(:,n));
%     interfLineal = 10^((sumInterf - 30) / 10);
    interfLineal = sum(10.^((PK(:,n) - 30) / 10));
    potLineal = 10^((mejorB0Pot(n) - 30) / 10);
%     N0Lineal = 10^((N0 - 30) / 10);
    N0Lineal = 0;
    vectorSINR(n) = potLineal / (N0Lineal + interfLineal);
end


plotHex = plot(pgon0); hold on; 
plotHex.FaceColor = [0 1 0];
grid on;
% plotHex = plot(puntosValidos(1,:), puntosValidos(2,:), 'g.');
plot(puntosValidos(1,mejorB0Indx), puntosValidos(2,mejorB0Indx), 'k*');
xlabel('X[m]'); ylabel('Y[m]');
title('Puntos que perciben con mayor potencia al EB0');

figure
h = histogram(vectorSINR,'Normalization','probability', 'NumBins', 5000);
% figure
% h = histogram(vectorSINR');

function geo = getPol(centro, radio, angulo)
    puntVertices = centro(:) + [(radio*2/sqrt(3)) * cos(0:angulo:2*pi-angulo);
                                (radio*2/sqrt(3)) * sin(0:angulo:2*pi-angulo)];
    geo = polyshape(puntVertices');
end