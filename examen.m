
resultado = OVSF(1, 1)

% % Se define una función recursiva que genere los códigos OVSF
function M = OVSF(sf, C)
    if sf >= 0
        M = [OVSF(sf - 1, [C +C]);
             OVSF(sf - 1, [C not(C)])];
    else
        M = C;
    end
end
