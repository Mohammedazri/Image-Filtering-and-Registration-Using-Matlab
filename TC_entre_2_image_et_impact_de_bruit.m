close all
clear all
clc


 %corriger
 
 
 
 
%{
utilité de code
avoir l impact de paramétre de filtage cercle sur des images quand on a une
ajouté une matrice bruit entre [0 1000].
%}
fprintf("utilité de code avoir l impact de paramétre de filtage cercle sur des images quand on a uneajouté une matrice bruit entre [0 1000].")
fprintf("Sélection de l'image de reference \n"); 
fichiersRecherches = '*.csv'; %selection des fichiers.csv puis ouverture fichier image de reference
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers qui ont pour extention csv', 'MultiSelect', 'on'); 
Comma2Dot(fullfile(PathName, FileName));
Fid = fopen(fullfile(PathName, FileName));
C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);                  
fclose(Fid);
ImageRef= C{1};



figure
ImRef=imagesc(abs(ImageRef));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');

%________________________________________________________________________







%___________________________________________________________________________________________________________________
fprintf("                             L image a recale est:\n1 - meme image translate\n2 - image different\n\n "); 

choie_de_im_A_reCal=input('');

n=size(ImageRef,1);
m=size(ImageRef,2);

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

fprintf("creation de matrice bruit entre l interval de bruit:\n");
a=input('');
fprintf("jusqu a\n")
b=input('');
r=randi([a b],n,m);

Image_A_Rec_noise=ImageAReC+r;
end

if choie_de_im_A_reCal==1
    
  [ImTrans] = fct_Im_Tran(ImageRef);
ImageAReC=ImTrans;

fprintf("creation de matrice bruit entre l interval de bruit:\n");
a=input('');
fprintf("jusqu a\n")
b=input('');
r=randi([a b],n,m);

Image_A_Rec_noise=ImageAReC+r;
end






%___________________________________________________________________________








figure
ImRef_with_noise=imagesc(abs(Image_A_Rec_noise));
colormap('gray') %couleur gris
colorbar % barre de(s intensités image
caxis([1121 4095]);
title('image de reference selectionné+bruit ');
xlabel('Xpixel'); 
ylabel('Ypixel');



D=248;
Tx_I=zeros(D,1);
Ty_I=zeros(D,1);

TraN=zeros(D,1);

Taux_de_corelatoion_apres=zeros(D,1);
Taux_de_corelatoion_avant=zeros(D,1);

sub_TC=zeros(D,1);
erReur=zeros(D,1);

usfac=50;
D0=zeros(D,1);
TC_entre_les_2_image_sans_filtrage=corr2(ImageRef,Image_A_Rec_noise)
for D0=1:D
    [Im_filtre_cercle_Ref] = filtre__cercle_function(ImageRef,D0);
    [Im_filtre_cercle_A_Rec] = filtre__cercle_function(Image_A_Rec_noise,D0);

R1=corr2(Im_filtre_cercle_Ref,Im_filtre_cercle_A_Rec);
Taux_de_corelatoion_avant(D0,1)=R1;

[CoefCorTrans1,Ty,Tx, Greg] = dftregistration(fft2(Im_filtre_cercle_Ref),fft2(Im_filtre_cercle_A_Rec),usfac); 
Recale= abs (ifft2 (Greg));

    
  

erReur(D0,1)=CoefCorTrans1(1,1);

Tx_I(D0,1)=Tx;
Ty_I(D0,1)=Ty;

TraN(D0,1)=sqrt(Tx_I(D0,1).^2+Ty_I(D0,1).^2);

R2=corr2(Im_filtre_cercle_Ref,Recale);
Taux_de_corelatoion_apres(D0,1)=R2;

sub_TC(D0,1)=Taux_de_corelatoion_apres(D0,1)-Taux_de_corelatoion_avant(D0,1);
DO(D0,1)=D0;

end

R2=corr2(Im_filtre_cercle_Ref,Recale);

T = table(DO,Taux_de_corelatoion_avant,Taux_de_corelatoion_apres,sub_TC,erReur,Tx_I,Ty_I,TraN);

figure
subplot(2,3,1)
plot(DO,Taux_de_corelatoion_avant),
xlabel('RO'), ylabel('Taux_de_corelatoion avant recalge')
%ylim([0.7 1]);
title('le Taux de corelation avant  en fonction de RO filtre')


subplot(2,3,2)
plot(DO,Taux_de_corelatoion_apres),
xlabel('RO'), ylabel('Taux_de_corelatoion apres recalge')
%ylim([0.97 1]);
title('le Taux de corelation apres en fonction de RO')


subplot(2,3,3)
plot(DO,erReur),
xlabel('RO'), ylabel('Erreur')
%ylim([0 0.2]);
title('Erreur en fonction de RO')


subplot(2,3,4)
plot(DO,Tx_I),
xlabel('RO'), ylabel('Tx')
title('Tx en fct de RO')

subplot(2,3,5)
plot(DO,Ty_I),
xlabel('RO'), ylabel('Ty')
title('Ty en fct de RO')

subplot(2,3,6)
plot(DO,TraN),
xlabel('RO'), ylabel('sqrt(Tx^2+Ty^2)')
title('sqrt(Tx^2+Ty^2) en fct de RO')




figure


subplot(2,2,1)
plot(DO,Taux_de_corelatoion_avant,'--',DO,Taux_de_corelatoion_apres,'-')
legend('le Taux de corelation avant  en fonction de R0 ','le Taux de corelation apres en fonction de R0')
xlabel('RO')



subplot(2,2,2)
plot(DO,erReur),
xlabel('RO'), ylabel('Erreur')
%ylim([0 0.2]);
title('Erreur en fonction de RO)')




subplot(2,2,3)



plot(DO,sub_TC)
xlabel('RO')
legend('TC Apres -TC Avant ')



subplot(2,2,4)



plot(DO,Tx_I,'.',DO,Ty_I,'--',DO,TraN,'-')
xlabel('RO')
legend('Tx','Ty','sqrt(Tx^2+Ty^2)')


