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


%%Selectionner la température de normalisation 
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
        ImageARec2{i,4*(j-1)+k} = C{1};
        
        end
    end
end 

%Recalage Guizar
usfac=input('valeur du pas de subpixelisation \n');
for i = 1:1 % NsI: Nombre de sous images  
    for j = 1:NombreCycle % Nc: Nombre de cycles
        for k = 1:4 % K: Nombre d'images que contient un cycle
                [CoefCorTrans1{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageARec2{i,4*(j-1)+k}),usfac);
                ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
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


%%Selectionner les températures 
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
    for i = 1:1 % NsI: Nombre de sous images  
        for j = 1:NombreCycle % Nc: Nombre de cycles
            for k = 1:4 % K: Nombre d'images que contient un cycle
                    [CoefCorTrans{i,4*(j-1)+k},Tx{i,4*(j-1)+k},Ty{i,4*(j-1)+k}, Greg{i,4*(j-1)+k}] = dftregistration(fft2(ImageRef),fft2(ImageARec{i,4*(j-1)+k}),usfac);%#ok<SAGROW>
                    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
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



