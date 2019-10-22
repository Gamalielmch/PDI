clear
close all
I=imread('C:\Users\Usuario\Documents\MATLAB\PDI\subject05_80.jpg');
%I=imread('C:\Users\Usuario\Documents\MATLAB\PDI\lena.jfif');
%I=rgb2gray(I);
Iv=double(I(:));
[y,x]=imhist(I);
y=y/sum(y);
k=4; %%% Número de modelos
mini=min(Iv);
maxi=max(Iv);
ra=maxi-mini;
mu=linspace(mini+0.25*ra,maxi-0.25*ra,k); %% medias iniciales equi-espaciadas
sgm=5*ones(1,k); %%% desviación estándar inicial de 5.
phi_k=ones(1,k)/k;   %% ponderación inicial igual.
ite=100; %% iteraciones

color=lines(k+2);
gama=zeros(length(Iv),k);
fig=figure;
set(fig,'unit','normalized')
set(fig,'position',[0.1, 0.1, .8,.8]);
uistack(fig,'top')
for i=1:ite
    
    for ic=1:length(Iv)
        suma=0;
        for o=1:k
            suma=suma + phi_k(o)*  (1 / (sgm(o) * sqrt(2*pi))) * exp( -(Iv(ic)-mu(o))^2 / (2*sgm(o)^2) );
        end
        
        for o=1:k
            gama(ic,o)=(phi_k(o)*normpdf(Iv(ic),mu(o),sgm(o)))/ suma ;
        end
    end
    
%     suma=sum(phi_k.*normpdf(Iv(:),mu,sgm),2);
    
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

%     for j=1:length(Iv)
%         for o=1:k
%             gama(j,o)= (phi_k(o)*normpdf(Iv(j),mu(o),sgm(o)))/ sum(phi_k(:).*normpdf(Iv(j),mu(:),sgm(:)));
%         end
%     end
