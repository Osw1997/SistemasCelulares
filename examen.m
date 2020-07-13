
resultado = OVSF(1, 1)

% % Se define una funci�n recursiva que genere los c�digos OVSF
function M = OVSF(sf, C)
    if sf >= 0
        M = [OVSF(sf - 1, [C +C]);
             OVSF(sf - 1, [C not(C)])];
    else
        M = C;
    end
end
