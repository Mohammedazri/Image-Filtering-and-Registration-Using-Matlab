close all
clear all
clc

%corriger

fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageRef= C{1};

%___________________________________________________________
%             filtre cercle 

%____________________________________________________________

M=size(ImageRef,1);
R0=1:1:(M/2);
M=4;
for k=1:(M/2)

[Im_filtre_cercle] = filtre__cercle_function(ImageRef,R0(k));

figure(k)

Im_filte_cercle=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title(['image filtre par filtre cercle(avec R0=',num2str(R0(k)),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');

saveas(figure(k),sprintf('Figure_l_image_filtre_par_filtre_cercle_pass_bas_pour_rayon=%d.png',R0(k))); % will create
close all



end