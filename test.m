load('/Users/mac/Documents/Juan Manuel/UR/2022-2/Señales/git/Proyecto-Procesamiento-de-Senales/imagenes/amarilla/Natural/mats/amarilla_luz_natural_no_flash_abajo.mat', "ftt")
inv = ifft(ftt);
plot(inv)