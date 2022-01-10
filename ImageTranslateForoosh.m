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

f=ImageRef;
X=input('Entrer la valeur de translation suivant x\n');
Y=input('Entrer la valeur de translation suivant y\n');
deltar = Y;
deltac = X;
phase = 0;
[nr,nc]=size(f);
Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
[Nc,Nr] = meshgrid(Nc,Nr);
g = ifft2(fft2(f).*exp(1i*2*pi*(deltar*Nr/nr+deltac*Nc/nc))).*exp(-1i*phase);
ImTrans=abs(g);
figure
imagesc(abs(g));
colormap('gray')
colorbar
title('Image à recalé ');
xlabel('Xpixels');
ylabel('Ypixels');
[deltaX, deltaY] = ExtPhaseCorrelation1(f,g);
Greg = (fft2(g).*exp(1i*2*pi*(-deltaY*Nr/nr-deltaX*Nc/nc))).*exp(1i*phase);
Recale= abs(ifft2(Greg));
figure
Irec=imagesc(Recale);
colormap('gray')
colorbar
title('Image recalé par Foroosh ');
xlabel('Xpixels');
ylabel('Ypixels');
ImRec = Irec.CData;
SoustractionIARecIref=(ImTrans-ImageRef);
AbsSoustractionIARecIref=abs(ImTrans-ImageRef);
SoustractionIRecIref=(ImRec-ImageRef);
AbsSoustractionIRecIref=abs(ImRec-ImageRef);
figure
imagesc(SoustractionIARecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('Image à recalé-Image de référence ');
xlabel('Xpixels');
ylabel('Ypixels');
figure
imagesc(AbsSoustractionIARecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('| Image à recalé-Image de référence |');
xlabel('Xpixels');
ylabel('Ypixels');
figure
imagesc(SoustractionIRecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('Image recalé-Image de référence PhaseCorrSub ');
xlabel('Xpixels');
ylabel('Ypixels');
figure
imagesc(AbsSoustractionIRecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|Image recalé-Image de référence PhaseCorrSub| ');
xlabel('Xpixels');
ylabel('Ypixels');
MoyImRef=mean(mean(ImageRef));
MoyImRec=mean(mean(ImRec));
MoyImTrans=mean(mean(ImTrans));
MoyImTransImRef=mean(mean(ImTrans-ImageRef));
MoyImTransImRefAbs=mean(mean(abs(ImTrans-ImageRef)));
MoyImRecImRef=mean(mean(ImRec-ImageRef));
MoyImRecImRefAbs=mean(mean(abs(ImRec-ImageRef)));

