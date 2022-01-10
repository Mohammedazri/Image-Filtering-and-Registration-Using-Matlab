close all
clear all

clc

%corrigrer
fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageRef= C{1};




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Affichage image réferent  selectioné%           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
subplot(3,3,1);
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %  
%                         filter_gaussian_pass_bas                        % 
%                                                                         %     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%https://fr.wikipedia.org/wiki/Filtre_de_Gauss
%}
sigma_frequenciel=input('la fct gaussienne a 2D est : g(x,y)=(1/(2*pi*(sigma)^2))*exp(-(x^2+y^2)/(2*(sigma)^2)).Entré la valeur de sigma(positive): ');
sigma_spacial=(352/(2*pi*sigma_frequenciel));
%sigma_spacial=(172/sigma_frequenciel);
j=size(ImageRef,1);
k=size(ImageRef,2);
w_gaussian=fspecial('gaussian',[j k],sigma_spacial);
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        affichage d  e l image traité                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(3,3,2);
ImRef=imagesc(g_filter_gaussien_pass_bas);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title(['image filtré (pour segma= ',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');



%___________affichage de filtre utilise_____

subplot(3,3,4);
%surf(filter_circle);colormap();colorbar;
%xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(diameter),')']);
Im_filter_gaussian=imagesc(Module_TF);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
%caxis([1121 4095]);
title(['Le filtre utilisé  (avec sigma=',num2str(sigma_frequenciel),')']);

xlabel('FXpixel'); 
ylabel('FYpixel');



subplot(3,3,5);
surf(Module_TF);colormap();colorbar;
view([0,0]);
title(['Le filtre utilisé l''intensité en fct de FXpixel (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');




%________________substraction entre l image refernent est filtre__

Soustraction_filter_gaussian=ImageRef-g_filter_gaussien_pass_bas;


subplot(3,3,3)
im_Soustraction_filter_gaussian=imagesc(Soustraction_filter_gaussian);
colormap('gray') %couleur gris
colorbar % barre des intensités image
caxis([-50 50]);
title(['Soustraction entre l''image filtré t et l''image referen  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');


%_______________________________________________________________________________
g=abs(G___filtre_gaussien);


subplot(3,3,8);
surf(g);colormap();colorbar;
view([0,0]);
title(['Le module de la TFD de la matrice complexe traité aprés le filtrege   (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');





%__________________________________________________________________________________


subplot(3,3,7);
surf(abs(F_fftshif_fft2_ImageRef));colormap();colorbar;
view([0,0]);
title(['le module TFD de matrice referent  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');





