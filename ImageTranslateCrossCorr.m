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
Itfd=fft2(f);
Jtfd=fft2(g);
Ctfd=Itfd.*conj(Jtfd);
CP= real(ifft2(Ctfd));
% recherche du pic de corrélation
nblig=size(CP,1);
[val,pos]=max(CP(:));
col=1+floor((pos-1)/nblig);
lig=pos-nblig*(col-1);
%if lig>10 % décalage maximale autorisée
    %lig=lig-1-450;
%end
disp(sprintf('correlation:translation=(%d,%d)',col-1,lig-1));