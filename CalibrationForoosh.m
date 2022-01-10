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
%Recalage Foroosh
%Initialisation des données

Greg = cell(i,4*(j-1)+k);
Greg{i,4*(j-1)+k} = [];
deltaY=cell(i,4*(j-1)+k);
deltaX=cell(i,4*(j-1)+k);
deltaX{i,4*(j-1)+k}= [];
deltaY{i,4*(j-1)+k}= [];
for i = 1:1 % NsI: Nombre de sous images  
    for j = 1:NombreCycle % Nc: Nombre de cycles
        for k = 1:4 % K: Nombre d'images que contient un cycle
                [deltaX{i,4*(j-1)+k}, deltaY{i,4*(j-1)+k}] = ExtPhaseCorrelation(ImageRef,ImageARec2{i,4*(j-1)+k});
                [nr,nc]=size(ImageRef);
                Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
                Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
                [Nc,Nr] = meshgrid(Nc,Nr);
                Greg{i,4*(j-1)+k} = (fft2(ImageARec2{i,4*(j-1)+k}).*exp(-1i*2*pi*(deltaX{i,4*(j-1)+k}*Nr/nr+deltaY{i,4*(j-1)+k}*Nc/nc))).*exp(1i*0);
                ImageCalibNorm{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));
                
        end
    end
end



for n=1:4*(NombreCycle-1)+4
    ImageCalibNormMoy{1,n}= mean(cat(3, ImageCalibNorm{1,n},ImageCalibNorm{1,n}), 3); %#ok<SAGROW>
end

%%Moyenne des images de la température normalisée 
NbSum=(4*(NombreCycle-1)+4);
SumImageCalibNorm = zeros(size(ImageRef));
for n=1:4*(NombreCycle-1)+4
    SumImageCalibNorm = SumImageCalibNorm + ImageCalibNormMoy{1,n};
end
ImMoyRecalTempNorm=SumImageCalibNorm/NbSum;


%%Selectionner les températures 
NombreTemp=input('Donner le nombre de température\n');
for NumbTemp=1:1:NombreTemp
    fprintf("Sélection du dossier tempréture %d \n",NumbTemp);
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
                    [deltaX{i,4*(j-1)+k}, deltaY{i,4*(j-1)+k}] = ExtPhaseCorrelation(ImageRef,ImageARec{i,4*(j-1)+k});
                    [nr,nc]=size(ImageRef);
                    Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
                    Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
                    [Nc,Nr] = meshgrid(Nc,Nr);
                    Greg{i,4*(j-1)+k} = (fft2(ImageARec{i,4*(j-1)+k}).*exp(-1i*2*pi*(deltaX{i,4*(j-1)+k}*Nr/nr+deltaY{i,4*(j-1)+k}*Nc/nc))).*exp(1i*0);
                    ImageCalibTemp{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
            end
        end
    end
    

    for n=1:4*(NombreCycle-1)+4
        ImageCalibTempMoy{1,n}= mean(cat(3, ImageCalibTemp{1,n},ImageCalibTemp{1,n}), 3); 
    end

    NbSum=(4*(NombreCycle-1)+4);
    
    sumImRecal = zeros(size(ImageRef));
    for n=1:4*(NombreCycle-1)+4
        sumImRecal = sumImRecal + ImageCalibTempMoy{1,n};
    end
    Moy=sumImRecal/NbSum;
    ImMoyRecalTemp{NumbTemp}=Moy;
    b{1,NumbTemp}=Moy;
    
end



