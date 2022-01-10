close all
clear all

clc
%coreger
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
%%% Affichage image réferent  selectioné%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F_fftshif_fft2=fftshift(fft2(ImageRef));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Affichage de fftshift a 2D ET 3D                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
ImRef_ABS=imagesc(abs(F_fftshif_fft2));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title('abs de fft2');
xlabel('FXpixel'); 
ylabel('FYpixel');

figure()
surf(abs(F_fftshif_fft2));colormap();colorbar;

xlabel('FXpixel'), ylabel('FYpixel'), title('abs de fft2 ');
%xlabel('FXpixel'), ylabel('FYpixel'), title(['abs de fft2 ( avecD0=',num2str(D0),')']);
%%%%%%%%%%%%%%%%%%%%%%  traitemaent d'image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D0=input('Entrer la valeur du rayon D0 : ');

R0=D0;


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
g_filter_circle_pass_bas=ifft2(G_filter_circle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      affichage ABS de FFT aprés le filtrage  dans l'espace fréquentiel %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure()
ImRef_ABS_G_filter_circle=imagesc(abs(G_filter_circle));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title(['abs de fft2 ( pour D0=',num2str(D0),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');

figure()
surf(abs(G_filter_circle));colormap();colorbar;

xlabel('FXpixel'), ylabel('FYpixel'), title(['abs de fft2 ( pour D0=',num2str(D0),')']);
%xlabel('FXpixel'), ylabel('FYpixel'), title(['abs de fft2 ( avecD0=',num2str(D0),')']);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     Affiche de filtre                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
Im_FILTRE_G_filter_circle=imagesc(abs(filter_circle_filter_circle_pass_bas));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title(['filter utilisé ( pour D0=',num2str(D0),')']);
xlabel('FXpixel'); 
ylabel('FYpixel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          affichage de fft apres le filtrage             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
Im_Filt__G_filter_circle=imagesc(abs(G_filter_circle));
colormap('gray') %couleur gris
colorbar % barre des intensités image
title(['le module de spectre aprés  la multiplication ( pour D0=',num2str(D0),')']);
xlabel('Fpixel'); 
ylabel('Fpixel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Afichage image filtre                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure()
Im_Filt__g_filter_circle=imagesc(abs(g_filter_circle_pass_bas));

colormap('gray') %couleur gris
colorbar % barre des intensités image
title(['image filtré par un filtre cercle ( pour D0=',num2str(D0),')']);
caxis([1121 4095]);
xlabel('Xpixel'); 
ylabel('Ypixel');

% _______________ subsatarcation entre l image referent et l image filtre 


Sous_filtre_pass_bas_cercle=ImageRef-abs(g_filter_circle_pass_bas);

figure()

Im_Soustraction_filtre_pass_haut=imagesc(Sous_filtre_pass_bas_cercle);
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([-50 50]);
title(['Soustraction entre l''image referent et l''image  filtré  (avec D0=',num2str(D0),')']);
xlabel('Xpixel'); 
ylabel('Ypixel');







