function []=transformacion()
I=imread('onion.png');



%% %%%% traslación  x
%%%%
t=[1 0 20; 0 1 -25; 0 0 1];
I=rgb2gray(I);
In=uint8(zeros(size(I)));
for i=1:size(I,1)
    for j=1:size(I,2)
        n=t*[i,j,1]';
        if n(1)>1 && n(2)>1
            In(n(1),n(2))=I(i,j)';
        end
    end
end

figure
imshow(I)
figure
imshow(In)

%% %%%% rotación
close all
th=80*pi/180;
t=[cos(th) -sin(th) 0; sin(th) cos(th) 0; 0 0 1];
cx=size(I,1);
cy=size(I,2);
In=uint8(zeros(size(I)));

for i=1:size(I,1)
    for j=1:size(I,2)
        try
        n=t*[i,j,1]'+[cx,cy,1]';
        if n(1)>1 && n(2)>1
            In(round(n(1)),round(n(2)))=I(i,j);
        end
        catch
            i
        end
    end
end

figure
imshow(I)
figure
imshow(In)



q=input('enter the angle the image to be rotated');
F=[cos(q) sin(q) 0;-sin(q) cos(q) 0;0 0 1];
K=maketform('affine',F);
L=imtransform(I,K,'FillValue',[158;120;100]);
figure(1),imshow(L)
end