
close all

clear 

clc

%__________________________________________________________________________

%                                        load data 

%__________________________________________________________________________

fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Fid = fopen(fullfile(PathName, FileName));
formatSpec = '%q';
%c = textscan(Fid, formatSpec, 'Delimiter', ';');
c   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageRef= c{1};


%________________filtre_pass_bas cercle____________

D0=input('Entrer la valeur de R0 le filtre cercle: ');
%diameter=input('Entrer le diameter de cercle pour le filtre circle pass bas: ');

%charge;
F_fftshif_fft2=fftshift(fft2(ImageRef));
%calcul de la taille de l'image;
M=size(F_fftshif_fft2,1);
N=size(F_fftshif_fft2,2);
%filter_circle=zeros(M,N);
filter_Utilise=zeros(M,N);
M2=round(M/2);
N2=round(N/2);
for i=1:M
    for j=1:N
    if(sqrt((i-M2)^2+(j-N2)^2)<=(D0))
        filter_Utilise(i,j)=1;
    end
    end
end

for i=1:M
for j=1:N
G_filter_circle(i,j)=F_fftshif_fft2(i,j)*filter_Utilise(i,j);
end
end

Image_filtre=ifft2(fftshift(G_filter_circle));



figure
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title('image de reference selectionné ');
xlabel('Xpixel'); 

ylabel('Ypixel');




figure

Im_filtre_pass_bas=imagesc(abs(fft2(ImageRef)));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([0 100000]);
%title(['image filtré (avec un diametre de =',num2str(D0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');


figure
Im_filtre_pass_bas=imagesc(abs(fftshift(fft2(ImageRef))));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([0 100000]);
title(['le module de TFD de  l image de reference  (avec un diametre de =',num2str(D0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');




figure
surf(filter_Utilise);colormap();colorbar;
xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(D0),')']);
figure
surf(abs(fft2(ImageRef)));colormap();colorbar;
xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(D0),')']);


figure
surf(abs(fftshift(fft2(ImageRef))));colormap();colorbar;
xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(D0),')']);






figure
Im_filtre_pass_bas=imagesc(abs(Image_filtre));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1100 4095]);
title(['image filtre (avec un diametre de =',num2str(D0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');


