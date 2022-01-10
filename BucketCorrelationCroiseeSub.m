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
ImageReference= C{1};



%Affichage Image de référence
figure(1)
Iref=imagesc(abs(ImageReference));
cdata1 =Iref.CData; 
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');
ImageRef=Iref.CData;

fprintf("Sélection du dossier des images \n");
pathname = uigetdir();
NombreCycle=input('Sélectionner le nombre de cycle \n');
ImageARec = cell(1,4*NombreCycle);
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
        filename = sprintf('Cycle%d_Image%d_%d.csv', j, k, i);
        Comma2Dot(fullfile(pathname, filename));
        fid = fopen(fullfile(pathname, filename));
        C   = textscan(fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
        fclose(fid);
        ImageARec{i,4*(j-1)+k} = C{1};
        
        end
    end
end   

%Initialisation des données
CoefCorTrans1 = cell(i,4*(j-1)+k);
Tx=cell(i,4*(j-1)+k);
Ty=cell(i,4*(j-1)+k);
CoefCorTrans1{i,4*(j-1)+k} = [];
Tx{i,4*(j-1)+k}=[];
Ty{i,4*(j-1)+k}=[];
Recale = cell(i,4*(j-1)+k);
Recale{i,4*(j-1)+k} = [];
Greg = cell(i,4*(j-1)+k);
Greg{i,4*(j-1)+k} = [];

%Recalage Guizar
usfac=input('valeur du pas de subpixelisation \n');
for i = 1:1 % NsI: Nombre de sous images  
    for j = 1:NombreCycle % Nc: Nombre de cycles
        for k = 1:4 % K: Nombre d'images que contient un cycle
                [CoefCorTrans1{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageARec{i,4*(j-1)+k}),usfac);
                Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));% Ici tout les images recalé en fonction de celle pris comme référence
        end
    end
end

%Statistique déplacement moyen


for n=1:1:4*(NombreCycle-1)+4
    sommeX = sum([Tx{:}]);
    moyenneX=sommeX /(4*(NombreCycle-1)+4);
end

for n=1:1:4*(NombreCycle-1)+4
    sommeY = sum([Ty{:}]);
    moyenneY=sommeY /(4*(NombreCycle-1)+4);
end

NormVecteurMoyen=sqrt((moyenneX.^2)+(moyenneY.^2));

%Moyenne image recalé et non recalé
Nc=NombreCycle;
for n=1:4*(Nc-1)+4
    RecaleMoy{1,n}= mean(cat(3, Recale{1,n},Recale{1,n}), 3);%#ok<SAGROW> 
end
for n=1:4*(Nc-1)+4
    NonRecaleMoy{1,n}= mean(cat(3, ImageARec{1,n},ImageARec{1,n}), 3);%#ok<SAGROW> 
end
%%%%%% METHODE 4 BUCKET %%%%%%%%

NbSum=(4*(Nc-1)+4)/4;

sumI1 = zeros(size(cdata1));
for n=1:4:4*(Nc-1)+4
    sumI1 = sumI1 + RecaleMoy{1,n};
end
sumI1moy=sumI1/NbSum;

sumI2 = zeros(size(cdata1));
for n=2:4:4*(Nc-1)+4
    sumI2 = sumI2 + RecaleMoy{1,n};
end

sumI2moy=sumI2/NbSum;

sumI3 = zeros(size(cdata1));
for n=3:4:4*(Nc-1)+4
    sumI3 = sumI3 + RecaleMoy{1,n};
end
sumI3moy=sumI3/NbSum;

sumI4 = zeros(size(cdata1));
for n=4:4:4*(Nc-1)+4
    sumI4 = sumI4 + RecaleMoy{1,n};
end
sumI4moy=sumI4/NbSum;
denom=sumI1moy+sumI2moy+sumI3moy+sumI4moy;
x=sumI1moy-sumI3moy;
X=x.^2;
y=sumI2moy-sumI4moy;
Y=y.^2;
z=X+Y;
Z=sqrt(z);
ConstBucket=input('Entrer la valeur de la constante de BucKet\n');
Bucket=(ConstBucket*Z)./denom;

figure
Ibuc=imagesc(Bucket);
title('image du 4bucket ');
xlabel('Xpixel'); 
ylabel('Ypixel');
colormap(jet)
colorbar

%%Test qualité de recalage
for n=1:4*(Nc-1)+4
    soustractionIrecIref=(RecaleMoy{1,n}-cdata1); %soustrait chaque image recalé -image de reference 
end
for n=1:4*(Nc-1)+4
    absSoustractionIrecIref=abs(RecaleMoy{1,n}-cdata1); %soustrait chaque image recalé -image de reference en valeur absolue
end
for n=1:4*(Nc-1)+4
    soustractionIArecIref=(ImageARec{1,n}-cdata1); %soustrait chaque image à recalé -image de reference  
end
for n=1:4*(Nc-1)+4
    absSoustractionIArecIref=abs(ImageARec{1,n}-cdata1); %soustrait chaque image à recalé -image de reference en valeur absolue
end
figure
imagesc(soustractionIrecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('moy Image recalé-Image de référence CrossCorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIrecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|moy Image recalé-Image de référence| CrossCorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(soustractionIArecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('moy Image non recalé-Image de référence  ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure
imagesc(absSoustractionIArecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|moy Image non recalé-Image de référence | ');
xlabel('Xpixel'); 
ylabel('Ypixel');
   