close all
clear all

clc

fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageRef= C{1};




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %  
%                         filter_gaussian_pass_bas                        % 
%                                                                         %     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D0=1:50:2000;

for k=1:173



%https://fr.wikipedia.org/wiki/Filtre_de_Gauss
%}

sigma_frequenciel(k)=D0(k);
%sigma_frequenciel=input('la fct gaussienne a 2D est : g(x,y)=(1/(2*pi*(sigma)^2))*exp(-(x^2+y^2)/(2*(sigma)^2)).Entré la valeur de sigma(positive): ');
sigma_spacial(k)=(352/(2*pi*sigma_frequenciel(k)));
%sigma_spacial=(172/sigma_frequenciel);
w_gaussian=fspecial('gaussian',[350 352],sigma_spacial(k));
FTM=fftshift(fft2(w_gaussian));
Module_TF=abs(FTM);





F_fftshif_fft2_ImageRef=fftshift(fft2(ImageRef));
abs_F_fftshif_fft2_ImageRef=abs(F_fftshif_fft2_ImageRef);
M=size(F_fftshif_fft2_ImageRef,1);
N=size(F_fftshif_fft2_ImageRef,2);

for i=1:M
for j=1:N
G___filtre_gaussien(i,j)=F_fftshif_fft2_ImageRef(i,j)*Module_TF(i,j);
end
end
g_filter_gaussien_pass_bas=ifft2(fftshift(G___filtre_gaussien));





figure(k)


ImRef=imagesc(g_filter_gaussien_pass_bas);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title(['image filtré par un filtre gaussien (pour segma= ',num2str(sigma_frequenciel(k)),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');

saveas(figure(k),sprintf('Figure_l_image_filtre_par_filtre_gaussien_pass_bas_pour_sigma=%d.png',k)); % will create


close all
end

