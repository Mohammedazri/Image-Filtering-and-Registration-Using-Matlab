function [ImTrans] = fct_Im_Tran(ImageRef)
f=ImageRef;
X=input('Entrer la valeur de translation suivant x\n');
Y=input('Entrer la valeur de translation suivant y\n');
deltar = Y;
deltac = X;
phase= 0;
[nr,nc]=size(f);
Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
[Nc,Nr] = meshgrid(Nc,Nr);
g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
ImTrans=abs(g);
end

