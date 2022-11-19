slash = "/";
dash = "_";
path = "/Users/mac/Documents/Juan Manuel/UR/2022-2/Señales/git/Proyecto-Procesamiento-de-Senales/";
img = "imagenes/";
color = ["amarilla", "verde"];
luz = ["/Artificial", "/Natural", "_luz_artificial", "_luz_natural"];
flash = [" con Flash/", "/", "_si_flash_", "_no_flash_"];
direc = ["abajo", "arriba", "frente", "atras"];

for x=1:1:length(color)
    for y=1:1:length(luz)-2
        for z=1:1:length(flash)-2
            for h=1:1:length(direc)
                %x+y+z+h
                
                route = strcat(path, img, color(x), luz(y), flash(z));
                access = strcat(color(x), luz(y + 2), flash(z + 2), direc(h));
                image = strcat(route, access, ".jpeg");
                I = imread(image);
                size(I);
                e1 = [I(1,1,1) I(1,1,2) I(1,1,3)];
                e2 = [I(1,size(I, 2),1) I(1,size(I, 2),2) I(1,size(I, 2),3)];
                e3 = [I(size(I,1),1,1) I(size(I,1),1,2) I(size(I,1),1,3)];
                e4 = [I(size(I,1),size(I,2),1) I(size(I,1),size(I,2),2) I(size(I,1),size(I,2),3)];
                
                E = [e1;e2;e3;e4];
                avg = mean(E,1) - 65;
                %Se separa la naranja del fondo (con cierto porcentaje de
                %error
                for i=1:1:size(I,1)
                    for j=1:1:size(I,2)
                        if I(i,j,1) > avg(1)
                            if I(i,j,2) > avg(2)
                                if I(i,j,3) > avg(3)
                                    I(i,j,1) = 0;
                                    I(i,j,2) = 0;
                                    I(i,j,3) = 0;
                                end
                            end
                        end
                    end
                end
                %Se separan los componentes RGB antes de realizar el vector
                comp_rojo = [];
                comp_verde = [];
                comp_azul = [];
                
                for i=1:1:size(I,1)
                    for j=1:1:size(I,2)
                        if I(i,j,1) > 0 && I(i,j,2) > 0 && I(i,j,3) > 0
                                    comp_rojo = [comp_rojo, I(i,j,1)];
                                    comp_verde = [comp_verde, I(i,j,2)];
                                    comp_azul = [comp_azul, I(i,j,3)];
                        end
                    end
                end
                
                %Se crea el vector que servirá como señal
                [a,b] = size(comp_rojo);
                tamano_intervalo = floor(b/1024);
                comp_rojo_1024 = [];
                comp_verde_1024 = [];
                comp_azul_1024 = [];
                
                for i=1:1:1024
                    if tamano_intervalo * (i + 1) - 1 < b
                        comp_rojo_1024 = [comp_rojo_1024, mean(comp_rojo(i*tamano_intervalo:i*tamano_intervalo+(tamano_intervalo-1)))];
                        comp_verde_1024 = [comp_verde_1024, mean(comp_verde(i*tamano_intervalo:i*tamano_intervalo+(tamano_intervalo-1)))];
                        comp_azul_1024 = [comp_azul_1024, mean(comp_azul(i*tamano_intervalo:i*tamano_intervalo+(tamano_intervalo-1)))];
                    else
                        comp_rojo_1024 = [comp_rojo_1024, mean(comp_rojo(i*tamano_intervalo:b))];
                        comp_verde_1024 = [comp_verde_1024, mean(comp_verde(i*tamano_intervalo:b))];
                        comp_azul_1024 = [comp_azul_1024, mean(comp_azul(i*tamano_intervalo:b))];
                    end
                end
                
                vector_rgb = [comp_rojo_1024,comp_verde_1024,comp_azul_1024];

                % Aplicación del algorimo FFT
                ftt=fft(vector_rgb);%transformada rápida de fourier

                % Creación del eje de frecuencia
                w=1;%frecuencia fundamental
                f=w/(2*pi);%frecuencia en Hz
                fm=1000*f;%frecuencia de muestreo
                t=0:1:3072;%eje de tiempo
                ll=length(t);
                factorr=ll/2;
                delta=(fm/(2*factorr));%delta de frecuencias
                freq_vector=[0:1:length(t)-2]*delta;%vector de frecuencias
                fourier = abs(ftt)/factorr;

                umbral = 0.005*fourier(1);
                for i = 1:1:size(ftt, 2)
                    ftt(i);
                    if fourier(i) < umbral
                        ftt(i) = ftt(i)*0;
                    end
                end
                new = strcat(route, "mats/", access);
                save(new,"ftt");
            end
        end
    end
end
