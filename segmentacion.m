I = imread("imagenes/amarilla/Natural/amarilla_luz_natural_no_flash_abajo.jpeg");
imshow(I);
size(I);
e1 = [I(1,1,1) I(1,1,2) I(1,1,3)];
e2 = [I(1,size(I, 2),1) I(1,size(I, 2),2) I(1,size(I, 2),3)];
e3 = [I(size(I,1),1,1) I(size(I,1),1,2) I(size(I,1),1,3)];
e4 = [I(size(I,1),size(I,2),1) I(size(I,1),size(I,2),2) I(size(I,1),size(I,2),3)];

E = [e1;e2;e3;e4];
avg = mean(E,1) -50;

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

imshow(I);