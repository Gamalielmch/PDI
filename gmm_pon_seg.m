k=3; %%% Número de modelos
mu=linspace(30,200,k); %% medias iniciales equi-espaciadas
sgm=5*ones(1,k); %%% desviación estándar inicial de 5.
phi_k=ones(1,k)/k;   %% ponderación inicial igual.
ite=100; %% iteraciones
I=imread('C:\Users\Usuario\Documents\MATLAB\mediacal_images\train\XR_FOREARM\patient00660\study1_negative\image2.png');
%I=imread('C:\Users\Usuario\Documents\MATLAB\PDI\lena.jfif');
if size(I,3)>1
I=rgb2gray(I);
end
imshow(I)
h = imrect;
pos = wait(h);
I2=I(pos(2):pos(2)+pos(4),pos(1):pos(1)+pos(3));
imshow(I2)
I2=double(I2);
[a,b]=size(I2);
mu=zeros(1,k);
sgm=mu;
for i=1:nm
    h = imfreehand;
    p = wait(h);
    bw = poly2mask(p(:,1),p(:,2),a,b);
    mu(i)=mean(I2(bw==1));
    sgm(i)=std(I2(bw==1));
    setColor(h,'yellow')
end

Iv=double(I2(:));
[y,x]=imhist(uint8(I2));
y=y/sum(y);
color=lines(k+2);
gama=zeros(length(Iv),k);
fig=figure;
set(fig,'unit','normalized')
set(fig,'position',[0.1, 0.1, .8,.8]);
uistack(fig,'top')
for i=1:ite
    suma=sum(phi_k.*normpdf(Iv(:),mu,sgm),2);
    for o=1:k
    gama(:,o)=(phi_k(o)*normpdf(Iv(:),mu(o),sgm(o)))./ suma ;
    end
    g=zeros(k,256);
     plot(x,y,'Color',color(k+2,:))
    hold on
    for o=1:k
        phi_k(o)=sum(gama(:,o))/length(Iv);
        mu(o)= (gama(:,o)'*Iv(:))/sum(gama(:,o));
        sgm(o)= sqrt((gama(:,o)'*((Iv(:)-mu(o)).^2))/sum(gama(:,o)));
        g(o,:)=(phi_k(o)*normpdf(0:255,mu(o),sgm(o)));
        plot(0:255,g(o,:),'Color',color(o,:),'LineStyle','--')
    end
   
    plot(0:255,sum(g,1),'Color',color(o+1,:))
    hold off
    title(['Mezcla de Modelos Gaussianos de la Image.', ' Iteración: ', num2str(i)])
    drawnow
    pause(0.1)
end
g=zeros(size(I2,1),size(I2,2),k);
for o=1:k
g(:,:,o)=(phi_k(o)*normpdf(I2,mu(o),sgm(o)));
end
[~,labels]=max(g,[],3);
imshow(mat2gray(labels))
%     for j=1:length(Iv)
%         for o=1:k
%             gama(j,o)= (phi_k(o)*normpdf(Iv(j),mu(o),sgm(o)))/ sum(phi_k(:).*normpdf(Iv(j),mu(:),sgm(:)));
%         end
%     end
