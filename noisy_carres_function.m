function [g_noisy_pass_bas_carree] = noisy_carres_function(ImageRef,D0)
D0_filtre_pass_bas=D0-1;
%D0_filtre_pass_bas=input('Entrer la valeur de D0 pour le filtre pass bas: ');
%charge;
F_fftshif_fft2=fftshift(fft2(ImageRef));
%calcul de la taille de l'image;
M=size(F_fftshif_fft2,1);
N=size(F_fftshif_fft2,2);
P=size(F_fftshif_fft2,3);
H1_filtre_pass_bas=10.*ones(M,N);
%D0=2;
M2=round(M/2);
N2=round(N/2);
H1_filtre_pass_bas(M2-D0_filtre_pass_bas:M2+D0_filtre_pass_bas,N2-D0_filtre_pass_bas:N2+D0_filtre_pass_bas)=1;
for i=1:M
for j=1:N
G_filtre_pass_bas(i,j)=F_fftshif_fft2(i,j)*H1_filtre_pass_bas(i,j);
end
end
g_noisy_pass_bas_carree=abs(ifft2(G_filtre_pass_bas));




end


