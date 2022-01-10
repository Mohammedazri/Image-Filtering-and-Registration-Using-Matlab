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

%______________________________________________________________________________________________________

figure
subplot(2,2,1)
ImRef=imagesc(abs(ImageRef));
caxis([1021 4095]);
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');

subplot(2,2,2)
[counts, grayLevels1] = MyHistogram(ImageRef);





%______________________________________________________________________________________________________


R0=input('on est dans le cas d un filtre cercle, entre la valeur de rayon cercle dans l espace fréquentiel:\n');
[Im_filtre_cercle_Ref] = filtre__cercle_function(ImageRef,R0);


subplot(2,2,3)
ImRef=imagesc(abs(Im_filtre_cercle_Ref));
caxis([1021 4095]);
colormap('gray') %couleur gris
colorbar % barre des intensités image

title(['image filtré avec un filtre cercle (avec D0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');

subplot(2,2,4)
[counts, grayLevels2] = MyHistogram(Im_filtre_cercle_Ref);




%figure

%[counts, grayLevels2] = MyHistogram(abs(Im_filtre_cercle_Ref-ImageRef));




%___________________________________________________________________________________________________



figure
subplot(2,2,1)
ImRef=imagesc(abs(ImageRef));
caxis([1021 4095]);
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');

subplot(2,2,2)
[counts, grayLevels1] = MyHistogram(ImageRef);






r=input('pour le filtre averge rentre le nombre des lignes:');
c=input('pour le filtre averge rentre le nombre des colones:');
[g_averge_filtre] = function_moyanage_filtre(ImageRef,r,c);
subplot(2,2,3)
ImRef=imagesc(abs(g_averge_filtre));
caxis([1021 4095]);
colormap('gray') %couleur gris
colorbar % barre des intensités image

title(['image filtré avec un filtre moyennage (avec r=',num2str(r),'  et c=',num2str(c),') ']);
xlabel('Xpixel'); 
ylabel('Ypixel');

subplot(2,2,4)
[counts, grayLevels2] = MyHistogram(g_averge_filtre);

