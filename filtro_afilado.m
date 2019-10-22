close all
[filename,path]=uigetfile({'*.jpg;*.png;*.bmp;*.tiff;*.tif;*.jfif'},'Select the MATLAB code file');
I=imread([path,filename]);
if size(I,3)==3
    I=rgb2gray(I);
end
I=im2double(I);

% It=double(I);

%%%% Derivadas y gradiente
Idx=[I(:,2:end) I(:,1)]-I;
Idy=[I(2:end,:);I(1,:)]-I;
Gd= sqrt(Idx.^2+Idy.^2);
figure
imshow(mat2gray([Idx, Idy, Gd]))


%%% Laplaciano
a=0.5;
w= 3*[a/(1+a), (1-a)/(1+a), a/(1+a); (1-a)/(1+a), -4/(1+a), (1-a)/(1+a); a/(1+a), (1-a)/(1+a), a/(1+a)];
cb=(size(w,1)-1)/2;
b=size(w,2);
Ia=[zeros(cb,size(I,2));I;zeros(cb,size(I,2))];
Ia=[zeros(size(I,1)+2*cb,cb),Ia,zeros(size(I,1)+2*cb,cb)];
If=zeros(size(Ia));
for i=1:size(Ia,1)-b
    for j=1:size(Ia,2)-b
        Itemp=Ia(i:i+b-1,j:j+b-1);
        If(i+b,j+b)= sum(sum(Itemp.*w));
    end
end
If=If(cb+1:end-cb,cb+1:end-cb);
%imwrite(Ir,'fign.jpg')
figure, imshow(mat2gray(If))


%% filtro LoG
w=3;
cb=(w-1)/2;
covari=[1.4, 1;1.4, 1]; 
vari=1.4; 
[x,y]=meshgrid(-cb:cb,-cb:cb);
wlog=zeros(w,w);
o=1;
for i=-cb:cb
    p=1;
    for j=-cb:cb
      wlog(o,p)= (-1./(pi*vari^4)) * (1-((i.^2+j.^2)./(2*vari^2))) * (exp(-(i.^2+j.^2)./(2*vari^2)));
      p=p+1;
    end
    o=o+1;
end

cb=(size(wlog,1)-1)/2;
b=size(wlog,2);
Ia=[zeros(cb,size(I,2));I;zeros(cb,size(I,2))];
Ia=[zeros(size(I,1)+2*cb,cb),Ia,zeros(size(I,1)+2*cb,cb)];
If=zeros(size(Ia));
for i=1:size(Ia,1)-b
    for j=1:size(Ia,2)-b
        Itemp=Ia(i:i+b-1,j:j+b-1);
        If(i+b,j+b)= sum(sum(Itemp.*wlog));
    end
end
If=If(cb+1:end-cb,cb+1:end-cb);
%imwrite(Ir,'fign.jpg')
figure, imshow(mat2gray(If),[])
