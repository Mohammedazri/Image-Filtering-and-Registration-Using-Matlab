function [g_filter_gaussien_pass_bas] = filtre_gaussine(ImageRef,sigma_frequenciel)


sigma_spacial=(352/(2*pi*sigma_frequenciel));
%sigma_spacial=(172/sigma_frequenciel);

M=size(ImageRef,1);
N=size(ImageRef,2);
w_gaussian=fspecial('gaussian',[M N],sigma_spacial);
FTM=fftshift(fft2(w_gaussian));
Module_TF=abs(FTM);

F_fftshif_fft2_ImageRef=fftshift(fft2(ImageRef));
%abs_F_fftshif_fft2_ImageRef=abs(F_fftshif_fft2_ImageRef);
M=size(F_fftshif_fft2_ImageRef,1);
N=size(F_fftshif_fft2_ImageRef,2);

for i=1:M
for j=1:N
G___filtre_gaussien(i,j)=F_fftshif_fft2_ImageRef(i,j)*Module_TF(i,j);
end
end
g_filter_gaussien_pass_bas=ifft2(fftshift(G___filtre_gaussien));

end

