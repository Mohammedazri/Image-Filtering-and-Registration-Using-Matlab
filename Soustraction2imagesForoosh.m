clear
clc

fprintf("S�lection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'S�lectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
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
colorbar % barre des intensit�s image
title('image de reference selectionn� ');
xlabel('Xpixel'); 
ylabel('Ypixel');


fprintf("S�lection de l'image a recale \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'S�lectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
m2   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageAReC= m2{1};


%Affichage Image de l'image � recal�
figure
ImARec=imagesc(abs(ImageAReC));
colormap('gray') %couleur gris
colorbar % barre des intensit�s image10
title('image a recal� selectionn� ');
xlabel('Xpixel'); 
ylabel('Ypixel');

%Recalage Foroosh
[deltaX, deltaY] = ExtPhaseCorrelation(ImageRef,ImageAReC);
[nr,nc]=size(ImageRef);
Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
[Nc,Nr] = meshgrid(Nc,Nr);
Greg = (fft2(ImageAReC).*exp(-1i*2*pi*(deltaX*Nr/nr+deltaY*Nc/nc))).*exp(1i*0);
Recale= abs (ifft2 (Greg));% Ici tout les images recal� en fonction de celle pris comme r�f�rence
figure
ImageRec=imagesc(Recale);
colorbar
colormap(gray)
title('image recal� par la m�thode corrPhaseSub ');
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
title('Image recal�-Image de r�f�rence corrPhaseSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIrecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|Image recal�-Image de r�f�rence| corrPhaseSub  ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(soustractionIArecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('Image non recal�-Image de r�f�rence corrPhaseSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIArecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|Image non recal�-Image de r�f�rence| corrPhaseSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');