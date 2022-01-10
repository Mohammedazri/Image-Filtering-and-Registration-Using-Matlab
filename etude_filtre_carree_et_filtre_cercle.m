clear all
close all
clc

%correger

fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageRef= C{1};



D0=input('Entrer la valeur de D0 le filtre carree: ');


%________________filtre_pass_bas carres____________

D0_filtre_pass_bas=D0-1;
%D0_filtre_pass_bas=input('Entrer la valeur de D0 pour le filtre pass bas: ');
%charge;
F_fftshif_fft2=fftshift(fft2(ImageRef));
%calcul de la taille de l'image;
M=size(F_fftshif_fft2,1);
N=size(F_fftshif_fft2,2);
P=size(F_fftshif_fft2,3);
H1_filtre_pass_bas=zeros(M,N);
%D0=2;
M2=round(M/2);
N2=round(N/2);
H1_filtre_pass_bas(M2-D0_filtre_pass_bas:M2+D0_filtre_pass_bas,N2-D0_filtre_pass_bas:N2+D0_filtre_pass_bas)=1;
for i=1:M
for j=1:N
G_filtre_pass_bas(i,j)=F_fftshif_fft2(i,j)*H1_filtre_pass_bas(i,j);
end
end
g_filtre_pass_bas_carree=ifft2(G_filtre_pass_bas);
%subplot(1,2,1);imshow(I);title('image originale');
%subplot(1,2,2);imshow(255-abs(g),[0,255]);title('image filtrée');
figure
%_______________________________image referent__
subplot(2,2,1)
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');


%___________affichage de filtre utilise_____
subplot(2,2,2)
Im__ffiltre_pass_bas=imagesc(H1_filtre_pass_bas);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
%caxis([1121 4095]);
title(['Image filtré par un filtre carree avec une D0=',num2str(D0_filtre_pass_bas),'']);
xlabel('1/Xpixel'); 
ylabel('1/Ypixel');



%________________afichage de l image de filtre_________________
subplot(2,2,3)
Im_filtre_pass_bas_=imagesc(abs(g_filtre_pass_bas_carree));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1100 4095]);
title(['filtre carree (avec D0=',num2str(D0_filtre_pass_bas),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');

%________________substraction entre l image refernent est filtre__

Soustraction_filtre_pass_bas=abs(ImageRef-abs(g_filtre_pass_bas_carree));


subplot(2,2,4)
im_Soustraction_filtre_pass_haut=imagesc(Soustraction_filtre_pass_bas);
colormap('gray') %couleur gris
colorbar % barre des intensités image
caxis([0 50]);
title(['Soustraction entre l''image referent et l''image filtré (avec D0=',num2str(D0_filtre_pass_bas),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');


%surf(H1_filtre_pass_bas);colormap();colorbar;
%xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre pass bas applique au domain frequentiel ( avecD0=',num2str(D0_filtre_pass_bas),')']);



%____________________________________________________________________________________________________________________












%******************************_filter_circle_pass_bas*********************************
R0=input('Entrer la valeur de R0 le filtre cercle: ');
%diameter=input('Entrer le diameter de cercle pour le filtre circle pass bas: ');

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

g_filter_circle_filter_circle_pass_bas=ifft2(fftshift(G_filter_circle));

%subplot(1,2,1);imshow(I);title('image originale');
%subplot(1,2,2);imshow(255-abs(g),[0,255]);title('image filtrée');


%_______________________________image referent__

figure

subplot(2,2,1)
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');


%___________affichage de filtre utilise_____
subplot(2,2,2)
%surf(filter_circle);colormap();colorbar;
%xlabel('1/Ypixel'), ylabel('1/Xpixel'), title(['Le filtre cercle applique au domain frequentiel ( avec un diametre =',num2str(diameter),')']);
Im_filter_circle=imagesc(filter_circle_filter_circle_pass_bas);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
%caxis([1121 4095]);
title(['filtre cerculaire pass bas (avec un diametre de =',num2str(R0),')']);
xlabel('1/Xpixel'); 
ylabel('1/Ypixel');


%________________afiichage de l image de filtre_________________
subplot(2,2,3)
Im_filtre_pass_bas=imagesc(abs(g_filter_circle_filter_circle_pass_bas));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1100 4095]);
title(['image filtré (avec un diametre de =',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');

%________________substraction entre l image refernent est filtre__

Soustraction_filtre_circle=ImageRef-abs(g_filter_circle_filter_circle_pass_bas);


subplot(2,2,4)
im_Soustraction_filtre_circle=imagesc(Soustraction_filtre_circle);
colormap('gray') %couleur gris
colorbar % barre des intensités image
caxis([0 50]);
title(['Soustraction entre l''image filtré  et l''image  referent (avec D0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');







figure
sub_carre_et_cercle=H1_filtre_pass_bas-filter_circle_filter_circle_pass_bas;

imsub_carre_et_cercle=imagesc(sub_carre_et_cercle);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([0 50]);
title(['substraction entre filtre carré et filtre cercle cercle (avec D0=',num2str(R0),') et R0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');





sub_image=abs(g_filtre_pass_bas_carree)-abs(g_filter_circle_filter_circle_pass_bas);


figure

im___sub_image=imagesc(sub_image);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-10 10]);
title(['image avec un filtré carre (avec D0=',num2str(R0),') - image avec filtre cercle ( R0=',num2str(R0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');




sub_image=abs(g_filter_circle_filter_circle_pass_bas)-abs(g_filtre_pass_bas_carree);

figure

im___sub_image=imagesc(sub_image);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-10 10]);
title(['image avec filtre cercle ( R0=',num2str(R0),')-image avec un filtré carre (avec D0=',num2str(R0),') ']);
xlabel('Xpixel'); 
ylabel('Ypixel');



sub_image=abs(abs(g_filter_circle_filter_circle_pass_bas)-abs(g_filtre_pass_bas_carree));


figure

im___sub_image=imagesc(sub_image);
colormap('gray') %couleur gris
colorbar % barre des intensités image
%caxis([-10 10]);
title(['abs(image avec filtre cercle ( R0=',num2str(R0),')-image avec un filtré carre (avec D0=',num2str(R0),')) ']);
xlabel('Xpixel'); 
ylabel('Ypixel');

