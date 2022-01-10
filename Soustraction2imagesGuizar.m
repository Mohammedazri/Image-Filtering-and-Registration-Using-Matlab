clear
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

%Affichage Image de reference
figure
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');


fprintf("Sélection de l'image a recale \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
m2   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageAReC= m2{1};


%Affichage Image de référence
figure
ImARec=imagesc(abs(ImageAReC));
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image a recalé selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');




%Recalage Guizar
% choix du sub-division de pixel
usfac=input('valeur du sur échantillonnage de pixel\n');
[CoefCorTrans1,Ty,Tx, Greg] = dftregistration(fft2(ImageRef),fft2(ImageAReC),usfac); 
Recale= abs (ifft2 (Greg));% Ici tout les images recalé en fonction de celle pris comme référence



figure
ImageRec=imagesc(Recale);
colorbar
colormap(gray)
title('image recalé par la crosscorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');
ImRec = ImageRec.CData;




%Moyenne image
soustractionIrecIref=(ImRec-ImageRef);
absSoustractionIrecIref=abs(ImRec-ImageRef);
soustractionIArecIref=(ImageAReC-ImageRef);
absSoustractionIArecIref=abs(ImageAReC-ImageRef);

figure
imagesc(soustractionIrecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('Image recalé-Image de référence crosscorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIrecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('| Image recalé-Image de référence | crosscorrSub  ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(soustractionIArecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('Image non recalé-Image de référence crosscorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIArecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('Image non recalé-Image de référence crosscorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');
