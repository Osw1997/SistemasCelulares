% Modelo COST231

% COORDENADA ESTACIÓN BASE:	19.511949,-99.127858
% PAEZ ORTEGA OSWALDO EMMANUEL	19.516765,-99.126846

% Cantidad de puntos propuestos en el mapa
puntos = 1;
% Puntos a analizar son 12, cada uno a una distancia uniforme (45 metros)
dist = 45 / 1e3;

dist2base = 1:puntos;
dist2base = dist2base .* dist;
% Linea de vista según mi ubicacion
LineaVista = [false];
% Altura en metros de los edificios (suposición)
h = (9 + 8 +8 +8) / 4;
% Ancho de la calle (km)
w = [2];
% Distancia promedio entre edificios
b = [(8 + 7 + 3) / 3] ;
% Angulo de la calle respecto a la linea de vista
phi = [88];
% % Parámetros
% Altura estación base
Heb = 12;
%Altura de la antena movil 
Hm = 1.7;
%Potencia de transmicion
Pt = 33;
%Ganacia de la antena transmisora
Gt = 9;
%Ganancia de la antena receptora
Gr = 3;
% Como se puede usar una frecuencia de 800 a 2e3 MHz, yo escojo a 2e3 MHz
F = 1800;
% Vectores necesarios
Lb = zeros(1,puntos);
Lf = zeros(1,puntos);
Lrts = zeros(1,puntos);
Lmsd = zeros(1,puntos);
P_rx = zeros(1,puntos);
for m = 1:puntos
    % Si hay linea de vista, se aplica la siguiente ecuación
    if LineaVista(m)
        Lb(m) = 42.6 + 20*log10(F) + 26*log10(dist2base(m));
    % Si no, las siguientes
    else
        Lf(m) = 32.44 + 20*log10(F) + 20*log10(dist2base(m));
        %Perdida Lori
        Lori = L_ori(phi(m));
        % Perdida Lrts
        Lrts(m) = -16.9 - 10 * log10(w(m)) + 10 * log(F) + ...
                   20 * log10(h - Hm) + Lori;
        % Perdida Lbsh
        Lbsh = L_bsh(Heb,h);
        % Factor Ka
        ka = Ka(dist2base(m), Heb, h);
        % Factor kd
        [kd, kf] = Kd(Heb,h,F);
        % Perdida Lmsd
        Lmsd(m) = Lbsh + ka + kd * log10(dist2base(m)) + kf * log10(F) -...
                  9*log10(b(m));
        % Perdida Lb, en funcion de los resultados anteriores
        Lb(m) = L_b(Lf(m), Lrts(m), Lmsd(m));
    end
    % Se calcula la potencia redibida
    P_rx(m) = Pt + Gt - Lb(m) - Gr 
end

% figure
% plot(dist2base,P_rx, 'linewidth', 3)
% title('Potencia recibida en funcion de la distancia (kilómetros)')
% ylabel('Potencia[km]')
% xlabel('Distancia a punto [km]')
% grid on; axis([min(dist2base) max(dist2base) min(P_rx) max(P_rx)]);

function ka = Ka(dist2base, hb, h)
    if hb > h
        ka = 54;
    elseif hb <= h && dist2base >= 500
        ka = 54 - 0.8 * (hb - h);
    elseif hb <= h && dist2base < 500
        ka = 54 - 0.8 * (hb - h) * (dist2base / 0.5);
    end
end

function [kd, kf] = Kd(hb,h,f)
    if hb > h
        kd = 18;
        kf = -4 + 0.7 * (f / 925 - 1);
    else 
        kd = 18 - 15 * (hb - h) / h;
        kf = -4 + 1.5 * (f / 925 - 1);
    end
end

function Lbsh = L_bsh(hb,h)
    if hb > h
        Lbsh = -18 * log10(1 + hb - h);
    else 
        Lbsh = 0;
    end
end

function Lori = L_ori(phi)
    if phi > 0 && phi < 35
        Lori = -10 + 0.354*phi;
    elseif phi > 35 && phi < 55
        Lori = 2.5 + 0.075 * (phi - 35);
    else
        Lori = 4.0 - 0.114 * (phi - 55);
    end
end

function Lb = L_b(Lf, Lrts, Lmsd)
    if Lrts + Lmsd > 0
        Lb = Lf + Lrts + Lmsd;
    elseif Lrts + Lmsd < 0
        Lb = Lf;
    end
end


