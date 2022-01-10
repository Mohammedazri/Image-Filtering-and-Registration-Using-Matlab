close all

clear 

clc
%coriger





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
ImageReference= c{1};


%           Affichage Image de référence

figure(1)

Iref=imagesc(abs(ImageReference));
cdata1 =Iref.CData; 
colormap('gray') %couleur gris
colorbar % barre des intensités image10
title('image de reference selectionné ');
xlabel('Xpixel'); 
ylabel('Ypixel');
ImageRef=Iref.CData;






%__________________________________________________________________________

%                                   load fils
%__________________________________________________________________________


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
       formatSpec = '%q';
%c = textscan(Fid, formatSpec, 'Delimiter', ';');
       C   = textscan(Fid, '', -1, 'Delimiter', ';', 'EndOfLine', '\r\n', ...
                       'CollectOutput', 1);
        fclose(fid);
        ImageARec{i,4*(j-1)+k} = C{1};
        
        end
    end
end 
%__________________________________________________________________________
  
  



%__________________________________________________________________________
CoefCorTrans1 = cell(i,4*(j-1)+k);
CoefCorTrans1{i,4*(j-1)+k} = [];

Tx=cell(4*(j-1)+k,i);
Ty=cell(4*(j-1)+k,i);
Tx{4*(j-1)+k,i}=[];
Ty{4*(j-1)+k,i}=[];

Recale = cell(i,4*(j-1)+k);
Recale{i,4*(j-1)+k} = [];
Greg = cell(i,4*(j-1)+k);
Greg{i,4*(j-1)+k} = [];

Im_filtre_Recale = cell(i,4*(j-1)+k);
Im_filtre_Recale{i,4*(j-1)+k} = [];
%__________________________________________________________________________
le_taux_de_correlation_sans_reclage=zeros(4*NombreCycle,1);
le_taux_de_correlation_avec_reclage=zeros(4*NombreCycle,1);

Nbr_image=zeros(4*NombreCycle,1);
%__________________________________________________________________________

usfac=input('valeur du pas de subpixelisation \n');
fprintf("selon votre etude choisir un de ces cas:\n")
fprintf("1.sans filtrage\n2.filtre median\n3.filtre cercle\n4.filtre median + filtre cercle\n");
N=input('');


%__________________________________________________________________________

%                                sans filtrage

%__________________________________________________________________________
if  N== 1
   
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
        Nbr_image(4*(j-1)+k,1)=4*(j-1)+k;
         

    le_taux_de_correlation_sans_reclage(4*(j-1)+k,1)=corr2(ImageReference,ImageARec{i,4*(j-1)+k});
    
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference),fft2(ImageARec{i,4*(j-1)+k}),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
  
    le_taux_de_correlation_avec_reclage(4*(j-1)+k,1)=corr2(ImageReference,Recale{i,4*(j-1)+k});
    
 end
    end
end

end
%__________________________________________________________________________


   

%_________________________________________________________________________   
    
%                               filtre median

%__________________________________________________________________________

if N==2
     m=input('pour le filtre median rentre le nombre des lignes:');
   n=input('pour le filtre median rentre le nombre des colones:');
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
            Nbr_image(4*(j-1)+k,1)=4*(j-1)+k;
    

ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);

   le_taux_de_correlation_sans_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,ImageReference2_Filtre);
 
    
    
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
    %fprintf("______________________________________________________________\n");
    
    le_taux_de_correlation_avec_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,Recale{i,4*(j-1)+k});
    


    
 end
    end
end 

end
   
   
%__________________________________________________________________________


%                                          cercle filtre    
    
%__________________________________________________________________________  
if N==3
fprintf("Filtre cercle :\n");
   fprintf("Entre le parametre de filtrage:\n");
   R0=input('');
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
            Nbr_image(4*(j-1)+k,1)=4*(j-1)+k;
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageARec{i,4*(j-1)+k},R0);
    le_taux_de_correlation_sans_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,ImageReference2_Filtre);
   
    
    
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
    le_taux_de_correlation_avec_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,Recale{i,4*(j-1)+k});
    
    
    end
    end
end 
end




%__________________________________________________________________________
   
%              filtre median + filtre cercle 
%__________________________________________________________________________

if N==4
     m=input('pour le filtre median rentre le nombre des lignes:');
   n=input('pour le filtre median rentre le nombre des colones:');
   fprintf("Filtre cercle :\n");
   fprintf("Entre le parametre de filtrage:\n");
   R0=input('');
for i = 1:1
    for j = 1:NombreCycle
        for k = 1:4
            Nbr_image(4*(j-1)+k,1)=4*(j-1)+k;
  
ImageReference1_Filtre= medfilt2(ImageReference,[m n]);
ImageReference2_Filtre= medfilt2(ImageARec{i,4*(j-1)+k},[m n]);

     
    [ImageReference1_Filtre] = filtre__cercle_function(ImageReference1_Filtre,R0);
    [ImageReference2_Filtre] = filtre__cercle_function(ImageReference2_Filtre,R0);
    
    le_taux_de_correlation_sans_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,ImageReference2_Filtre);
    
    
    [CoefCorTrans1{i,4*(j-1)+k},Tx{4*(j-1)+k,i},Ty{4*(j-1)+k,i}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageReference1_Filtre),fft2(ImageReference2_Filtre),usfac); 
    Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
   
    
    le_taux_de_correlation_avec_reclage(4*(j-1)+k,1)=corr2(ImageReference1_Filtre,Recale{i,4*(j-1)+k});
    
    
    end
    end
end 
end

    

%-_-_-_-_-_-_-__-_-_-_-_-__-_-_-_-_-__-_-_-_-_-_---_-__-_-_-_-_-_-_-_-__-_-



%-_-_-_-_-__--_-__-_-_-_-_-__-_-_-__-_-_-_-__-_-_-_-_-_-_-_-__-_-_-_-_-_-__

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
caxis([0 0.04]);
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
figure()
imagesc(soustractionIrecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('moy Image recalé-Image de référence CrossCorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure()
imagesc(absSoustractionIrecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|moy Image recalé-Image de référence| CrossCorrSub ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure()
imagesc(soustractionIArecIref);
colorbar
caxis([-150 150]);
colormap(gray)
title('moy Image non recalé-Image de référence  ');
xlabel('Xpixel'); 
ylabel('Ypixel');

figure()
imagesc(absSoustractionIArecIref);
colorbar
caxis([0 150]);
colormap(gray)
title('|moy Image non recalé-Image de référence | ');
xlabel('Xpixel'); 
ylabel('Ypixel');










%_______________________________________________________________

%         parte si vous voulez enregistrer les data
%_______________________________________________________________
%{

text = menu('vous voulez enregistrer les data?','Yes','No');
if text == 1
[files,paths] = uiputfile('*.xlsx');
Pulsdauers = [paths files];
writetable(T,Pulsdauers);

[files,paths] = uiputfile('*.fig','*.png');
for k=1:10
    Pulsdauers = [paths 'fig',num2str(k)];
    
saveas(figure(k),Pulsdauers);
saveas(figure(k),Pulsdauers,'png'); % will create
end

end
%_______________________________________________

%               Create a presentation
%_______________________________________________
import mlreportgen.ppt.*
ppt = Presentation("myFigurePresentation.pptx");
open(ppt);


for i=1:8
% Add a slide to the presentation
slide = add(ppt,"Title and Content");
% Add title to the slide
replace(slide,"Title","surf(peaks)");
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
% Close the presentation
close(ppt);
% Once the presentation is generated, the figure and the image file
% can be deleted
for i=1:8
    
delete(['figSnapshot',num2str(i),'.png']);
end
% View the presentation
rptview(ppt);
%}



