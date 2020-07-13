% % %¨Práctica #2: Creación de códigos OVSF
clc; clear;
% Por defecto, C es igual a 1 para la generación de códigos OVSF
C = 1;
% % 2.- Códigos de mayor longitud son de 32 bits (N_max = 32)
N_max = 32;
% 4 usuarios de R_min -> N = 32 => k = log2(32) = 5
tasa_Rmin = 1;
N = N_max / tasa_Rmin;
% index_rmin = randperm(N,4);
% inicio = randperm(N,1);
% Para la misma profundidad => |ind_user1 - ind_user2 | >= 2
index_rmin = 1:2:7;
% Se comprueban que sean ortogonales
rutas_rmin = [];
for x = index_rmin
    rutas_rmin = [rutas_rmin; ruta_nodo(x, N)];
end
% ruta_Rmin = ruta_nodo(index_rmin', N)
% Por cuestiones analíticas 
M = OVSF(log2(N) - 1, C);
usuarios_rmin = M(index_rmin,:); 
% 2 usuarios de 2R_min -> N = N_max / 2 => k = log2(16) = 4
tasa_2Rmin = 2;
N = N_max / tasa_2Rmin; 
% users_2rmin = 1:2;
% index_2rmin = randperm(N,2);
% Para la cualquier profundidad => |ind_user1 - ind_user2 | >= 2^(Max_prof - actual_prof)
% Con base a la ruta de Rmin, la segunda columna de rutas_rmin son los
% padres que no deben ser usador puesto que son las que ya están ocupadas.
% --->> rutas_rmin(:,2)'
% por lo que los índices por ocupar empiezan, en este caso, en rutas_rmin(:,2) + 1
% además de que en este caso el espacio entre
index_2rmin = max(rutas_rmin(:,2)) + 2:2:max(rutas_rmin(:,2)) + 2 * 2;
% Se comprueban que sean ortogonales
rutas_2rmin = [];
for x = index_2rmin
    rutas_2rmin = [rutas_2rmin; ruta_nodo(x, N)];
end
M = OVSF(log2(N) - 1, C);
usuarios_2rmin = M(index_2rmin,:);
% 1 usuarios de 4R_min -> N = N_max / 4 => k = log2(16) = 4
tasa_4Rmin = 4;
N = N_max / tasa_4Rmin;
% index_4rmin = randperm(N,1);
index_4rmin = max(rutas_2rmin(:,2)) + 2:2:max(rutas_2rmin(:,2)) + 2 * 1
% Se comprueban que sean ortogonales
rutas_4rmin = [];
for x = index_4rmin
    rutas_4rmin = [rutas_4rmin; ruta_nodo(x, N)];
end
M = OVSF(log2(N) - 1, C);
usuarios_4rmin = M(index_4rmin,:);
% % % 3
% % a) Genere bits aleatorios para los 7 usuarios antes descritos y
% % disperse la información de cada uno con el código correspondiente.
% usuarios = randi([0 1], N_max, total_usuarios)';
% Caso Rmin
datos_rmin = randi([0 1], length(index_rmin), 1);
% cambio de 1 por -1 y 0 por 1
datos_rmin(datos_rmin == 1) = -1;
datos_rmin(datos_rmin == 0) = 1;
senalDispersaRmin = datos_rmin .* usuarios_rmin;
% Caso 2Rmin
datos_2rmin = randi([0 1], length(index_2rmin), 2);
% cambio de 1 por -1 y 0 por 1
datos_2rmin(datos_2rmin == 1) = -1;
datos_2rmin(datos_2rmin == 0) = 1;
senalDispersa2Rmin = [datos_2rmin(1,1) .* usuarios_2rmin(1,:) datos_2rmin(1,2) .* usuarios_2rmin(1,:);
                      datos_2rmin(2,1) .* usuarios_2rmin(2,:) datos_2rmin(1,2) .* usuarios_2rmin(2,:)];
% Caso 4Rmin
datos_4rmin = randi([0 1], length(index_4rmin), 4);
% cambio de 1 por -1 y 0 por 1
datos_4rmin(datos_4rmin == 1) = -1;
datos_4rmin(datos_4rmin == 0) = 1;
senalDispersa4Rmin = [];
for n = 1:tasa_4Rmin
    senalDispersa4Rmin = [senalDispersa4Rmin datos_4rmin(n) .* usuarios_4rmin];
end
figure(1)
chips = 1:N_max;
subplot(4,2,1);
plot(chips,senalDispersaRmin(1,:),'LineWidth',1);
title('Usuario 1 - Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
subplot(4,2,3);
plot(chips,senalDispersaRmin(2,:),'LineWidth',1);
title('Usuario 2 - Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
subplot(4,2,5);
plot(chips,senalDispersaRmin(3,:),'LineWidth',1);
title('Usuario 3 - Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
subplot(4,2,7);
plot(chips,senalDispersaRmin(4,:),'LineWidth',1);
title('Usuario5 - Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
% Usuarios 2Rmin
subplot(4,2,2);
plot(chips,senalDispersa2Rmin(1,:),'LineWidth',1);
title('Usuario 1 - 2Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
subplot(4,2,4);
plot(chips,senalDispersa2Rmin(2,:),'LineWidth',1);
title('Usuario 2 - 2Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);
% Usuario 4Rmin
subplot(4,2,[6 8]);
plot(chips,senalDispersa4Rmin(1,:),'LineWidth',1);
title('Usuario 1 - 4Rmin'); xlabel('n (chips)'); ylabel('S(n)');
axis([chips(1) chips(end) -1 1]);


% % b) Agregue ruido a las señales dispersas
% Se concatenan las señales resultantes
bloque = [senalDispersaRmin;
          senalDispersa2Rmin;
          senalDispersa4Rmin];
figure(2)
subplot(3,1,1)
plot(chips, bloque, 'LineWidth', 1);
title('Señales a transmitir'); xlabel('n (Chips)'); ylabel('S(n)');
axis([chips(1) chips(end) min(min(bloque)) max(max(bloque))]);
% Se agrega AWGN de 3dB
SNR = 3;
bloque_canal = awgn(bloque, SNR); bloque_canal = bloque;
% Se mezclan
mezcla_nonoise = sum(bloque_canal);
% dmezcla = sum(bloque_canal); 
mezcla = awgn(mezcla_nonoise, SNR);
subplot(3,1,2)
plot(chips, mezcla_nonoise, 'LineWidth', 1);
title('Señal mezclada sin AWGN'); xlabel('n (Chips)'); ylabel('S(n)');
axis([chips(1) chips(end) min(min(mezcla_nonoise)) max(max(mezcla_nonoise))]);

subplot(3,1,3)
plot(chips, mezcla, 'LineWidth', 1);
title('Señal mezclada con AWGN'); xlabel('n (Chips)'); ylabel('M(n)');
axis([chips(1) chips(end) min(mezcla) max(mezcla)]);

% % c) Dedisperse la señalmezclada e intente detectar el(los) bit(s)
% %    correspondiente(s). Compare los bits enviados con los recibidos.
% Recuperación de datos de Rmin
bitRmin = zeros(1,tasa_Rmin);
for n = 1:length(index_rmin)
    bitRmin(n) = sum((mezcla' .* usuarios_rmin(n,:)'));
end
% Recuperación de 2Rmin
% Se concatenan 2 veces el codigo y se multiplica por la mezcla
t = (repmat(usuarios_2rmin, 1, 2)' .* mezcla')';
bit2Rmin = [sum(t(1,1:16)) sum(t(1,17:32));
            sum(t(2,1:16)) sum(t(2,17:32))];
% Recuperación de 4Rmin
% Se concatenan 4 veces el codigo y se multiplica por la mezcla
t = (repmat(usuarios_4rmin, 1, 4)' .* mezcla')';
bit4Rmin = [sum(t(1:8)) sum(t(9:16)) sum(t(17:24)) sum(t(25:32))];
% Comparación de bits Tx vs Rx
bitRmin
datos_rmin'
bit2Rmin
datos_2rmin
bit4Rmin
datos_4rmin
% % d) Calcule en BER para cada tipo de usuario.
BER_Rmin = biterr(datos_rmin' > 0, bitRmin > 0) / length(datos_rmin);
BER_2Rmin = biterr(datos_2rmin > 0, bit2Rmin > 0) / length(datos_2rmin(:));
BER_4Rmin = biterr(datos_4rmin > 0, bit4Rmin > 0) / length(datos_4rmin(:));

fprintf("RMIN \t BER\n");
fprintf("1 \t %.2f\n", BER_Rmin);
fprintf("2 \t %.2f\n", BER_2Rmin);
fprintf("4 \t %.2f\n", BER_4Rmin);


% % Se define una función recursiva que genere los códigos OVSF
function M = OVSF(sf, C)
    if sf >= 0
        M = [OVSF(sf - 1, [C +C]);
             OVSF(sf - 1, [C -(C)])];
    else
        M = C;
    end
end

% % Se usa la siguiente función que retorna la ruta del actual nodo
function ruta = ruta_nodo(actual, profundidad)
    % 'd' servirá para saber cuántos niveles hay que ascender
    d = log2(profundidad) + 1;
    ruta = zeros(1,d);
    ruta(1) = actual;
    pointer = actual;
    for n = 2:d
        if mod(pointer,2) 
            ruta(n) = ceil(pointer / 2);
        else
            ruta(n) = floor(pointer / 2);
        end
        pointer = ruta(n);
    end
end