clear
clc
fprintf("Sélection de l'image 1 \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
FileName = cellstr(FileName);
 
m1 = cell(1,length(FileName)); %initialisation matrice m
 
for i_file = 1:size(m1,2)%lecture des données de l'image
    m1{i_file} = xlsread(fullfile(PathName, FileName{i_file})); 
end

ImageRef=m1{1,1}; %recuperation de l'image de reference 

%Affichage Image de reference
figure
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image 1 ');
xlabel('Xpixel'); 
ylabel('Ypixel');


fprintf("Sélection de l'image 2 \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
FileName = cellstr(FileName);
 
m2 = cell(1,length(FileName)); %initialisation matrice m2
 
for i_file = 1:size(m2,2)%lecture des données de l'image
    m2{i_file} = xlsread(fullfile(PathName, FileName{i_file})); 
end

ImageAReC=m2{1,1}; %recuperation de l'image de reference 

%Affichage Image de l'image à recalé
figure
ImARec=imagesc(abs(ImageAReC));
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image 2 ');
xlabel('Xpixel'); 
ylabel('Ypixel');


fprintf("Sélection de l'image 3 \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
FileName = cellstr(FileName);
 
m3 = cell(1,length(FileName)); %initialisation matrice m2
 
for i_file = 1:size(m3,2)%lecture des données de l'image
    m3{i_file} = xlsread(fullfile(PathName, FileName{i_file})); 
end

ImageARe=m3{1,1}; %recuperation de l'image de reference 

%Affichage Image de l'image à recalé
figure
ImARe=imagesc(abs(ImageARe));
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image 3 ');
xlabel('Xpixel'); 
ylabel('Ypixel');

fprintf("Sélection de l'image 4 \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
FileName = cellstr(FileName);
 
m4 = cell(1,length(FileName)); %initialisation matrice m2
 
for i_file = 1:size(m4,2)%lecture des données de l'image
    m4{i_file} = xlsread(fullfile(PathName, FileName{i_file})); 
end

ImageA=m4{1,1}; %recuperation de l'image de reference 

%Affichage Image de l'image à recalé
figure
ImA=imagesc(abs(ImageA));
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image 4 ');
xlabel('Xpixel'); 
ylabel('Ypixel');