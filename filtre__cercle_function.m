
function [Im_filtre_cercle] = filtre_cercle(ImageRef,R0)



F_fftshif_fft2=fftshift(fft2(ImageRef));
%calcul de la taille de l'image;
M=size(F_fftshif_fft2,1);
N=size(F_fftshif_fft2,2);
%filter_circle=zeros(M,N);
filter_circle_filter_circle_pass_bas=zeros(M,N);
M2=round(M/2);
N2=round(N/2);
for i=1:M
    for j=1:N
    if(sqrt((i-M2)^2+(j-N2)^2)<=(R0))
        filter_circle_filter_circle_pass_bas(i,j)=1;
    end
    end
end

for i=1:M
for j=1:N
G_filter_circle(i,j)=F_fftshif_fft2(i,j)*filter_circle_filter_circle_pass_bas(i,j);
end
end

g_filter_circle_filter_circle_pass_bas=ifft2(G_filter_circle);
Im_filtre_cercle=abs(g_filter_circle_filter_circle_pass_bas);

end

