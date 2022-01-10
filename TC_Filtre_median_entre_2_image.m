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






%________________________________________________________________________________



%___________________________________________________________________________________________________________________
fprintf("                             L image a recale est:\n1 - meme image translate\n2 - image different\n\n "); 

choie_de_im_A_reCal=input('');



if choie_de_im_A_reCal==2
    
fprintf("Sélection de l'image a recale \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
m2   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
fclose(Fid);
ImageAReC= m2{1};
end

if choie_de_im_A_reCal==1
    
  [ImTrans] = fct_Im_Tran(ImageRef);
ImageAReC=ImTrans;
end


RI_sans_filtrage=corr2(ImageRef,ImageAReC)

fprintf("\n filtrage de l'image de reference \n"); 

m=input('pour le filtre median rentre le nombre des lignes:');
n=input('pour le filtre median rentre le nombre des colones:');
ImageRef= medfilt2(ImageRef,[m n]);


fprintf("\n filtrage de l'image de A recalee \n");


m=input('pour le filtre median rentre le nombre des lignes:');
n=input('pour le filtre median rentre le nombre des colones:');
ImageAReC= medfilt2(ImageAReC,[m n]);


TC_sans_recalge_=corr2(ImageRef,ImageAReC)


[CoefCorTrans1,Ty,Tx, Greg] = dftregistration(fft2(ImageRef),fft2(ImageAReC),50); 
Recale= abs (ifft2 (Greg));

TC_avec_recalge_=corr2(ImageRef,Recale)



