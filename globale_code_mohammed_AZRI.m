clear
clc
close all

%Avany utiliser le code

%{
utilite de code

1- calcule de clalicration avec les diffferent cas(sans filtrage; avec un filtre median; filtre cercle; filtre median + filtre cercle)
 
2- le calcule de Fit

3- le calclule de l image de 4buckts et apres obtenure l image thermique

4- Tracer le Fit pour quelque pexil

%}






%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-

%                          Calibration de Guizar      

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-


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
colorbar % barre des intensités image
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');
ImageRef=Iref.CData;


NombreCycle=input('Sélectionner le nombre de cycle \n');


%                Selectionner la température de normalisation 

TempNormalisation=input('Donner la valeur de température de normalisation\n');
pathname = uigetdir();



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

fprintf("Avant de recalage Guizar selon votre etude choisir un des cas:\n")
fprintf("1.sans filtrage\n2.filtre median\n3.filtre cercle\n4.filtre median + filtre cercle\n");
N=input('');
if N==2
m=input('pour le filtre median rentre le nombre des lignes:');
n=input('pour le filtre median rentre le nombre des colones:');
end

if N==3

fprintf("Filtre cercle entre le parametre de filtrage:\n");
R0=input('');
end

if N==4
m=input('pour le filtre median rentre le nombre des lignes:');
n=input('pour le filtre median rentre le nombre des colones:');
fprintf("Filtre cercle entre le parametre de filtrage:\n");
R0=input('');
end

%Recalage Guizar
usfac=input('valeur du pas de subpixelisation \n');


    
    % sans filtrage
    if N==1
    
    for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
                    [CoefCorTrans{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageARec{i,4*(j-1)+k}),usfac);%#ok<SAGROW>
                     ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
            end
        end
    end
    end
    
    
    %filtre median
    
    if N==2
        for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
    ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
    ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);
    [CoefCorTrans{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
            end
            end
        end
    end
    
    %filtre cercle
    
    if N==3 
        for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageARec{i,4*(j-1)+k},R0);
    [CoefCorTrans{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));  
            end
    end
            end
        end
    
    %filtre median +filtre cercle
    
    if N==4
       for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
         
    ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
    ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);  
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference1_Filtre,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageReference2_Filtre,R0);
    [CoefCorTrans{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));   
                end
             end
         end
     end
    


for n=1:4*(NombreCycle-1)+4
    ImageCalibNormMoy{1,n}= mean(cat(3, ImageCalibNorm{1,n},ImageCalibNorm{1,n}), 3); %#ok<SAGROW>
  
end
Nc=NombreCycle;
%%Moyenne des images de la température normalisée 
NbSum=(4*(NombreCycle-1)+4);
SumImageCalibNorm = zeros(size(ImageRef));
for n=1:4*(Nc-1)+4
    SumImageCalibNorm = SumImageCalibNorm + ImageCalibNormMoy{1,n};
end
ImMoyRecalTempNorm=SumImageCalibNorm/NbSum;





%                  Selectionner les températures











NombreTemp=input('Donner le nombre de température\n');
for NumbTemp=1:1:NombreTemp
    fprintf("Sélection du dossier température %d \n",NumbTemp);
    a=input('Entrer la valeur de la température \n');
    T{1,NumbTemp}=a;
    pathname = uigetdir();
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
    
    
    
    
    
    % sans filtrage
    if N==1
    
    for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
                    [CoefCorTrans{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageARec{i,4*(j-1)+k}),usfac);%#ok<SAGROW>
                    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
            end
        end
    end
    end
    
    
    %filtre median
    
    if N==2
        for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
    ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
    ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
            end
            end
        end
    end
    
    %filtre cercle
    
    if N==3 
        for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageARec{i,4*(j-1)+k},R0);
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));  
            end
    end
            end
        end
    
    %filtre median +filtre cercle
    
    if N==4
       for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
         
    ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
    ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);  
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference1_Filtre,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageReference2_Filtre,R0);
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));   
                end
             end
         end
     end
    
    for n=1:4*(Nc-1)+4
        ImageCalibTempMoy{1,n}= mean(cat(3, ImageCalibTemp{1,n},ImageCalibTemp{1,n}), 3); 
    end

    NbSum=(4*(Nc-1)+4);
    
    sumImRecal = zeros(size(ImageRef));
    for n=1:4*(Nc-1)+4
        sumImRecal = sumImRecal + ImageCalibTempMoy{1,n};
    end
    Moy=sumImRecal/NbSum;
    ImMoyRecalTemp{NumbTemp}=Moy;
    b{1,NumbTemp}=Moy;
   
end














%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-

%                                      Fit

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-



y=[];
[PixelX,PixelY]=size(cdata1);
for Nb=1:NumbTemp
    
    for i=1:PixelX
        for j=1:PixelY
            
                % le point element par element 
                y=[b{1,Nb}(i,j)./ImMoyRecalTempNorm(i,j)];
                Ttout=cell2mat(T);
                droite = polyfit( Ttout(1,Nb),y,1);
                warning('off','all');
                MatrixCoefCalNorm{i,j}=droite(1);
                Ordonnee{i,j}=droite(2); 
                
         end
    end
end

ImMatixCoefCalNorm = cell2mat(MatrixCoefCalNorm);
figure
imagesc(ImMatixCoefCalNorm)
colormap('jet') %couleur gris
colorbar % barre des intensités image10
title('IMAGE COEFFICIENT DE THERMOREFLECTANCE ');
xlabel('X'); 
ylabel('Y');











%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-

%                                   image de 4buckt et image thermique 

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-


fprintf("selection le dossier de 4bucks:\n");
pathname = uigetdir();%ouverture fichier image à recaler + conversion
ImageBucket = cell(1,4*NombreCycle);
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
        filename = sprintf('Cycle%d_Image%d_%d.csv', j, k, i);
        Comma2Dot(fullfile(pathname, filename));
        fid = fopen(fullfile(pathname, filename));
        C   = textscan(fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
        fclose(fid);
        ImageBucket{i,4*(j-1)+k} = C{1};
        
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

%                      Recalage Guizar
 %   cas sans filtrage
if  N== 1
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4   
                [CoefCorTrans1{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageBucket{i,4*(j-1)+k}),usfac);
                Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));% Ici tout les images recalé en fonction de celle pris comme référence
        end
    end
end

end
% cas avec filtre médian
if N==2
     
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
     ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
     ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));

        end
    end
end 

end
%cas avec fitre cercle
if N==3

for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageARec{i,4*(j-1)+k},R0); 
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
    end
    end
end 
end
%cas avec filtre median + filtre cercle
if N==4
   
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
    ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
    ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);  
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference1_Filtre,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageReference2_Filtre,R0);
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
        end
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
    NonRecaleMoy{1,n}= mean(cat(3, ImageBucket{1,n},ImageBucket{1,n}), 3);%#ok<SAGROW> 
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
title('image du 4bucket corrélation croisée subpixelisé');
xlabel('Xpixel'); 
ylabel('Ypixel');
colormap(jet)
colorbar
caxis([0.0 0.02]);
%%%%%%%%%%%%%%%%% IMAGE THERMIQUE %%%%%%%%%%%%%%%%%%%%
ImTherNorm = Bucket./ImMatixCoefCalNorm;
figure
imagesc(ImTherNorm)
colormap(jet)
colorbar
title('Image Thermique corrélation croisée subpixelisé ');
xlabel('X'); 
ylabel('Y');
caxis([0.0 1]);












%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-

%                                     Tracage du  Fit

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-


nb=450;
while nb>0
    Tp1=input('Tracer de la température :');
    Tp2=input('à la température  :');

    Abs=input('Entrer le pixel que vous voulez tracer suivant x\n');
    Ord=input('Entrer le pixel que vous voulez tracer suivant y\n');
    
    for Tp=Tp1:Tp2

            x(1,Tp)=ImMoyRecalTemp{1,Tp}(Ord,Abs)./ImMoyRecalTempNorm(Ord,Abs);
            Ttout=cell2mat(T);

    end
    for Tp=Tp1:Tp2        
            tem(1,Tp)=Ttout(1,Tp);        
    end
    for Tp=Tp1:Tp2    
            xtra(1,Tp)=x(1,Tp);     
    end
    data=xtra;
    temperature=tem;
    P = polyfit( temperature,data,1);
    figure
    yfit = P(1)*temperature+P(2); 
    scatter(temperature,data,50,'b','*')
    hold on; 
    plot(temperature,yfit,'r-.');
    title('Fit');
    xlabel('Température');
    ylabel('Intensité');
end

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-

%                 part si vous voulez enregister votre data

%_-__-_-_-__-__-_-__-_-_-_-_-_-__-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-__-_-__-
%{

pat_pixel=input('le pas entre les pixle pour trace le fit ');
fprintf("-_-__-_-_-_-_-_-_-_-__-_-_-_-_-__-_-_-_-_-_-_-_-__-_-_-__-_-_-\n")

%                             intiation des paramétre
fprintf("tacage de Fit\n");
Tp1=1;
    
Tp2=NombreTemp;

Abs_bocle=size(ImageReference,1);
Ord_bocle=size(ImageReference,2);


for n = 1:pat_pixel:Ord_bocle
      for l=1:pat_pixel:Abs_bocle
          
fprintf("tacage de Fit\n");

    %Abs=input('Entrer le pixel que vous voulez tracer suivant x\n');
    
    %Ord=input('Entrer le pixel que vous voulez tracer suivant y\n');   
    Abs=n;
    Ord=l;
   
    
    for Tp=Tp1:Tp2

            x(1,Tp)=ImMoyRecalTemp{1,Tp}(Ord,Abs)/ImMoyRecalTempNorm(Ord,Abs);
            Ttout=cell2mat(T);

    end
    for Tp=Tp1:Tp2        
            tem(1,Tp)=Ttout(1,Tp);        
    end
    for Tp=Tp1:Tp2    
            xtra(1,Tp)=x(1,Tp);     
    end
    data=xtra;
    temperature=tem;
    P = polyfit( temperature,data,1);
    figure
    yfit = P(1)*temperature+P(2); 
    scatter(temperature,data,50,'b','*')
    hold on; 
    plot(temperature,yfit,'r-.');
    title('Fit');
    title(['Fit pixil [',num2str(n),',',num2str(l),']']);
    ylim([0.9 1.1])
    xlabel('Température');
      end 
end


h=findobj('type','figure');
n=length(h);




text = menu('vous voulez enregistrer les figure?','Yes','No');
if text == 1

[files,paths] = uiputfile('*.fig','*.png');
for k=1:n
    Pulsdauers = [paths 'fig',num2str(k)];
    
saveas(figure(k),Pulsdauers);
saveas(figure(k),Pulsdauers,'png'); % will create
end

end










fprintf("creation de document ppt\n");

% Create a presentation
import mlreportgen.ppt.*
if N==1
ppt = Presentation("cas1_sans_filtrage.pptx");
end
if N==2
ppt = Presentation("cas2_filtre_median.pptx");
end
if N==3
ppt = Presentation("cas3_filtre_cercele.pptx");
end
if N==4
ppt = Presentation("cas4_filtre_median_cercle.pptx");
end



open(ppt);
for i=1:n
    fprintf("creation des sildes\n");
% Add a slide to the presentation
slide = add(ppt,"Title and Content");
% Add title to the slide
%replace(slide,"Title","surf(peaks)");
% Create a MATLAB figure with the surface plot
fig = figure(i);

%{
figSize = [5,5];            % [width, height]
figUnits = 'Centimeters';

      %fig = figure(1);
      % Resize the figure
      set(fig, 'Units', figUnits);
      %pos = get(fig, 'Position');
      
       pos = [1,1,850,800];
      %pos = [pos(1), figSize(2),figSize(1), pos(4)];
      set(fig, 'Position', pos);
  %}

%surf(peaks);
% Print the figure to an image file
figSnapshotImage = ['figSnapshot',num2str(i),'.png'];
print(fig,"-dpng",figSnapshotImage);
% Create a Picture object using the figure snapshot image file
figPicture = Picture(figSnapshotImage);
% Add the figure snapshot picture to the slide
replace(slide,"Content",figPicture);

end

% testttt


% Close the presentation

close(ppt);
% Once the presentation is generated, the figure and the image file
% can be deleted

for i=1:n
    
fprintf("supprime les photos");
delete(['figSnapshot',num2str(i),'.png']);
end


% View the presentation
rptview(ppt);
%close all















%}
test1=ImMoyRecalTemp{1,2}./ImMoyRecalTempNorm;
test2=ImMoyRecalTemp{1,2}/ImMoyRecalTempNorm;
