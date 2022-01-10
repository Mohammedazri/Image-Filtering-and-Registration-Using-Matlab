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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Affichage image réferent  selectioné%           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








figure()


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
k=size(ImageRef,1);
j=size(ImageRef,2);
w_gaussian=fspecial('gaussian',[k j],sigma_spacial);
FTM=fftshift(fft2(w_gaussian));
Module_TF=abs(FTM);











% __________________trouvé le filtre au nivau de l espace frequencial

%{

PQ=paddedsize(size(ImageRef)/2);
H=freqz2(w_gaussian,PQ(2),PQ(1));
subplot(3,2,2);
Im_g_filter_gaussien_=imagesc(H);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
title(['Le filtre utilisé  (avec sigma=',num2str(sigma),')']);

xlabel('Xpixel'); 
ylabel('Ypixel');

%_______________________________________________________________________________
%subplot(3,2,4);
figure()
surf(H);colormap();colorbar;
xlabel('FXpixel'), ylabel('FYpixel'), title(['Le filtre pass bas applique au domain frequentiel ( avec segma=',num2str(sigma),')']);

%figure,imshow(abs(H1),[])

%}

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





%___________affichage de filtre utilise_____

subplot(3,4,2);
%surf(filter_circle);colormap();colorbar;
%xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(diameter),')']);
Im_filter_gaussian=imagesc(Module_TF);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
%caxis([1121 4095]);
title(['Le filtre utilisé  (avec sigma=',num2str(sigma_frequenciel),')']);

xlabel('FXpixel'); 
ylabel('FYpixel');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        affichage d  e l image traité                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(3,4,3);
ImRef=imagesc(g_filter_gaussien_pass_bas);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title(['image filtré (pour segma= ',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');





%________________substraction entre l image refernent est filtre filtre gaussien__

Soustraction_filter_gaussian=ImageRef-g_filter_gaussien_pass_bas;


subplot(3,4,4)


im_Soustraction_filter_gaussian=imagesc(Soustraction_filter_gaussian);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-50 50]);
title(['Soustraction entre l''image filtré t et l''image referen  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Affichage deuxizmme image réferent  selectioné%           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(3,4,5);
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');


































%______________________________________________________________________________



%******************************_filter_circle_pass_bas*********************************
%R0=D0(k);
%R0=D0;
R0=input('Entrer le rayon de cercle pour le filtre circle pass bas: ');

%charge;
F_fftshif_fft2=fftshift(fft2(ImageRef));
%calcul de la taille de l'image;
M=size(F_fftshif_fft2,1);
N=size(F_fftshif_fft2,2);
%filter_circle=zeros(M,N);
filter_circle_filter_circle_pass_bas=zeros(M,N);
M2=round(M/2);
N2=round(N/2);
for i=1:M
    for j=1:N
    if(sqrt((i-M2)^2+(j-N2)^2)<=(R0))
        filter_circle_filter_circle_pass_bas(i,j)=1;
    end
    end
end

for i=1:M
for j=1:N
G_filter_circle(i,j)=F_fftshif_fft2(i,j)*filter_circle_filter_circle_pass_bas(i,j);
end
end

g_filter_circle_pass_bas=ifft2(fftshift(G_filter_circle));




% le filtre utilise 

subplot(3,4,6);
Im_filtre_utilise=imagesc(filter_circle_filter_circle_pass_bas);
colormap('gray') %couleur gris
colorbar % barre des intensités image
title(['le fitre cercle utilise à un rayoun (avec un rayon de D0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');


%____image filtre par iun filtre cercle




subplot(3,4,7)
Im_filtre_pass_bas=imagesc(abs(g_filter_circle_pass_bas));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title(['image filtré par un pass bas cercle (avec un rayon de D0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');



%_________la substraction entre image referent et filtre par un filtre
%cercle pass bas

%
Soustraction_filtre_circle_pass_bas=ImageRef-abs(g_filter_circle_pass_bas);

subplot(3,4,8)
im_Soustraction_filtre_circle=imagesc(Soustraction_filtre_circle_pass_bas);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-50 50]);
title(['Soustraction entre l''image filtré  et l''image dnas le cas d un filtre cercle pass bas(avec D0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                           les sbstraction des images                   %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%
%_________So_filtre_gaussien_et__circle_pass_bas

%
So_filtre_gaussien_et__circle_pass_bas=Module_TF-filter_circle_filter_circle_pass_bas;

subplot(3,4,10)
im_so_filtre_gaussien_et__circle_pass_bas=imagesc(So_filtre_gaussien_et__circle_pass_bas);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-50 50]);
title(['Soustraction entre le filtre gaussie et le filtre cercle(avec D0=',num2str(R0),')et  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');






%_________la substraction entre image referent et filtre par un filtre
%cercle pass bas

%
So_image_filtre_gaussien_et__circle_pass_bas=g_filter_gaussien_pass_bas-abs(g_filter_circle_pass_bas);

subplot(3,4,11)
im_So_image_filtre_gaussien_et__circle_pass_ba=imagesc(So_image_filtre_gaussien_et__circle_pass_bas);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-50 50]);
title(['image filtre gaussien -image filtre cercle (avec D0=',num2str(R0),')et  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');







%_________la substraction les bruit des deux image 

%
So_image_bruit_gaussien_et_image_bruit_cercle=g_filter_gaussien_pass_bas+abs(g_filter_circle_pass_bas);

subplot(3,4,12)
im_So_image_bruit_gaussien_et_image_bruit_cercle=imagesc(So_image_bruit_gaussien_et_image_bruit_cercle);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-50 50]);
title(['image bruit gaussien -image bruit cercle (avec D0=',num2str(R0),')et  (avec sigma=',num2str(sigma_frequenciel),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');








