function [label_im,vec_mean] = kmeans_3
[file, path]=uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'},'Load image','C:\Users\Usuario\Documents\MATLAB\PDI');
I=imread([path,file]);
[x,y,~]=size(I);

I1=double(I(:,:,1));
I2=double(I(:,:,2));
I3=double(I(:,:,3));
k=8;

m=randi(256,[3,k]);

%m=zeros(3,k);
% fig=figure;
% imshow(I)
% for i=1:k
%     imshow(I)
%     h = imfreehand;
%     position = wait(h);
%     BW = poly2mask(position(:,1), position(:,2), x, y);
%     m(1,i)= mean(I1(BW==1));
%     m(2,i)= mean(I2(BW==1));
%     m(3,i)= mean(I3(BW==1));
% end
%close(fig)

I1=I1(:);
I2=I2(:);
I3=I3(:);
d=zeros(length(I1),k);
for ite=1:30
    for i=1:k
        d(:,i)=sqrt((I1-m(1,i)).^2 + (I2-m(2,i)).^2 + (I3-m(3,i)).^2  );
    end
    [~,d]=min(d,[],2);
    for i=1:k
        m(1,i)=mean(I1(d==i));
        m(2,i)=mean(I2(d==i));
        m(3,i)=mean(I3(d==i));
    end
    
end
Ie1=rgb2gray(I);
Ie2=Ie1;
Ie3=Ie1;


I1=I(:,:,1);
I2=I(:,:,2);
I3=I(:,:,3);

k=[2,3,4];
for j=1:length(k)
Ie1(d==k(j))=I1(d==k(j));
Ie2(d==k(j))=I2(d==k(j));
Ie3(d==k(j))=I3(d==k(j));
imshow(reshape([Ie1,Ie2,Ie3],[x,y,3]))
end

Ie1(:,:,2)=Ie2;
Ie1(:,:,3)=Ie3;
imshow([I,Ie1])
i


