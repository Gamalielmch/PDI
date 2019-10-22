%% K means Algorithm for Gray Image
function [b,kr] = kmeans_image_gray(im,nk,ki)
%%input
%% im gray scale image
%% nk number of class
%% ki initial centers for nk class
if size(im,3)>1
    if size(im,3)>3
        im=im(:,:,1:3);
        im=rgb2gray(im);
    else
        im=rgb2gray(im);
    end
end
color=lines(nk);
[x,y]=imhist(im);
data=double(im(:));
% % fig1=figure;
% % if isempty(ki)
% %     imshow(im)
% %     for i=1:nk
% %         h = impoint(gca,[]);
% %         position = wait(h);
% %         ki(i)=im(ceil(position(2)),ceil(position(1)));
% %     end
% % end
%% close(fig1)
ki = randi(254,[1,nk]);
kr=ki;
dist=10;
% b=uint8(zeros(size(data)));
ite=0;
ma=max(x);
fig2=figure;
plot(y,x,'k')
hold on
for i=1:nk
    plot([ki(i), ki(i)],[0,1.1*ma], 'color',color(i,:))
end
hold off
while dist>1e-5 || ite>200
    for i=1:length(data)
        dis=abs(data(i)-ki);
        [~,lo]=min(dis);
        b(i)=lo;
    end
    
    for i=1:nk
        [~,pos]=find(b==i);
        ki(i)=mean(data(pos));
    end
    
    dist=sum(abs(kr-ki));
    kr=ki;
    ite=ite+1;
    plot(y,x,'k')
    hold on
    for i=1:nk
        plot([ki(i), ki(i)],[0,1.1*ma], 'color',color(i,:))
    end
    hold off
    pause(1)
end

b=reshape(b,size(im));
is=im;
for i=1:size(im,1)
    for j=1:size(im,2)
        is(i,j)= round(ki(b(i,j)));
    end
end

figure,imshow(uint8(is))




ite
