function u = otsu2u(I)
n=imhist(I); 
N=sum(n); 
p=n/N;
i=0:255;
MT=dot(i,p);
mini=min(I(:));
maxi=max(I(:));
vari=0;
oo=1;
maximo=0;
for j=mini+1:maxi-1
    for l=j+1:(maxi-2)
        k1=sum(p(mini+1:j));
        m1=dot(i(mini+1:j),p(mini+1:j)) / k1 ;
        k2=sum(p(j+1:l));
        m2=dot(i(j+1:l),p(j+1:l)) / k2 ;
        k3=sum(p(l+1:maxi));
        m3= dot(i(l+1:maxi),p(l+1:maxi)) / k3  ;
        
        vari(oo)= k1*(m1-MT)^2 + k2*(m2-MT)^2 + k3*(m3-MT)^2;
          
          if vari(oo)>maximo
              u(1)=j;
              u(2)=l;
              maximo=vari(oo);
          end
          oo=oo+1;
    end
end
plot(vari)
figure
bar(i,p)
figure
imshow([I, uint8(I<=u(1))*255, uint8(I>u(1) &I<=u(2))*255, uint8(I>u(2))*255])