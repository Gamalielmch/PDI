%%%%%%%%%%%%%%%%% Filtrado espacial
[filename,path]=uigetfile({'*.jpg;*.png;*.bmp;*.tiff;*.tif;*.jfif'},'Select the MATLAB code file');
I=imread([path,filename]);
if size(I,3)==3
    I=rgb2gray(I);
end
I=double(I);


In = imnoise(mat2gray(I),'gaussian',0,0.003); 

If=uint8(simple_nlm(double(In),3,2,1,10,0)*255);

%In= imnoise(mat2gray(I),'salt & pepper',0.02);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%        Filtro promedio      %%%%%%%%%
%%%  Ventana- Filtro debe de ser impar  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w=ones(3); 
w=w/sum(w(:));  %Promedio

w2=[20,20,20;20,1,20;20,20,20];  % promedio ponderado
w2=w2/sum(w2(:));
% agregar ceros
[a,b]=size(w);
ca=(a-1)/2;
cb=(b-1)/2;
Ir=In;
Ir=[zeros(cb,size(I,2));Ir;zeros(cb,size(I,2))];
Ir=[zeros(size(I,1)+2*cb,ca),Ir,zeros(size(I,1)+2*cb,ca)];

for i=1:size(Ir,1)-a
    for j=1:size(Ir,2)-b
        Ir(i+ca,j+cb)= sum(sum(w.*Ir(i:i+a-1,j:j+b-1)));
    end
end
Ir=Ir(ca+1:end-ca,cb+1:end-cb);
figure, imshow(uint8([I,In*255,Ir*255]))
% imtool(uint8(I))
% imtool(uint8(In*255))
% imtool(uint8(Ir*255))



%% Filtro estadístico mediana
I=imread([path,filename]);
if size(I,3)==3
    I=rgb2gray(I);
end
I=double(I);
In= imnoise(mat2gray(I),'salt & pepper',0.02);
a=3;
b=a;
Ir=In;
Ir=[zeros(cb,size(I,2));Ir;zeros(cb,size(I,2))];
Ir=[zeros(size(I,1)+2*cb,ca),Ir,zeros(size(I,1)+2*cb,ca)];
for i=1:size(Ir,1)-a
    for j=1:size(Ir,2)-b
        Irr=Ir(i:i+a-1,j:j+b-1);
        Ir(i+ca,j+cb)= median(Irr(:));
    end
end
Ir=Ir(ca+1:end-ca,cb+1:end-cb);
%imwrite(Ir,'fign.jpg')
figure, imshow(uint8([I,In*256,Ir*256]))


%%%%%%%%%%%%%%% Mejoramiento con filtro Laplaciano 

 f = imread('moon.tif');
w4 = fspecial('laplacian', 0); % Same as w in Example 3.9.
w8 = [1 1 1; 1 -8 1; 1 1 1];
f = im2double(f);
g4 = f -imfilter(f, w4, 'replicate');
g8 = f - imfilter(f, w8, 'replicate');
imshow(f)
figure, imshow(g4)
figure, imshow(g8)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I= double(imread('circles.png'));
I= imnoise(I,'salt & pepper',0.02);
figure
imshow(I)
for i=1:size(I,1)
    for j=1:size(I,2)
        e1=entropy(I);
        It=I;
        It(i,j)=1-I(i,j);
        e2=entropy(It);
        if e2<e1
            I=It;
        end
    end
end
figure, imshow(I)
