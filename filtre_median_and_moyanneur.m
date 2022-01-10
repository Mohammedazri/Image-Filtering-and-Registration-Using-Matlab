close all

clear all

clc
%corrieger
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

%                      Affichage l Image de reference
%___________________________________________________________


figure()
subplot(2,3,1)
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title('image de reference selectionné ');

xlabel('Xpixel'); 
ylabel('Ypixel');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%________________________________________________________________

%                    filtre median handling

%----------------------------------------------------------------
m=input('pour le filtre median rentre le nombre des lignes:');
n=input('pour le filtre median rentre le nombre des colones:');
J_Im_filt= medfilt2(ImageRef,[m n]);

%___________________________________________________________

%                      Affichage l Image filtre
%___________________________________________________________


subplot(2,3,2)
Im_filt_median=imagesc(J_Im_filt);
caxis([1121 4095]);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title(['image filtre avec un filtre median par une matrice [',num2str(m),',',num2str(n),']']);
xlabel('Xpixel'); 
ylabel('Ypixel');




%_______________________________________________________________________________________



sub_fltre_median=ImageRef-J_Im_filt;



subplot(2,3,3)
sub_Im_filt_median=imagesc(sub_fltre_median);
caxis([-1000 3000]);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title(['substraction image refrent et image filtre [',num2str(m),',',num2str(n),']']);
xlabel('Xpixel'); 
ylabel('Ypixel');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%









%_________________________________________________________________________________________

%                    Averge filtre  traitement 
%_________________________________________________________________________________________



%___________________________________________________________

%                      Affichage l Image de reference
%___________________________________________________________







subplot(2,3,4)
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title('image de reference selectionné ');

xlabel('Xpixel'); 
ylabel('Ypixel');





%_________________________________________________________________________

r=input('pour le filtre averge rentre le nombre des lignes:');
c=input('pour le filtre averge rentre le nombre des colones:');


fil_averge=fspecial('average', [r c]);


g_averge_filtre = imfilter(ImageRef, fil_averge, 'conv');

%_______________________________________________________________________________
%
%           afficahage d image filtre 
%______________________________________________________________________________
subplot(2,3,5)
Im_averge_filtre=imagesc(g_averge_filtre);
caxis([1121 4095]);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title(['image filtre avec un filtre avrege par une matrice [',num2str(m),',',num2str(n),']']);
xlabel('Xpixel'); 
ylabel('Ypixel');




%______________________________________________________________________________________________

%                               subsraction cet<en image refrence and pictuqre fitere 
   
%_______________________________________________________________________________________________






sub_averge_filtre=ImageRef-g_averge_filtre;

subplot(2,3,6)
Im_filt_median=imagesc(sub_averge_filtre);
caxis([-1000 3000]);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title(['substraction image refrent et image filtre [',num2str(m),',',num2str(n),']']);
xlabel('Xpixel'); 
ylabel('Ypixel');
















