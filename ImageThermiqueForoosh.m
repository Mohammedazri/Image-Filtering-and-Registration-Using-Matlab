pathname = uigetdir();
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

%Initialisation des donn?es
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

%Recalage Foroosh

for i = 1:1 % NsI: Nombre de sous images  
    for j = 1:NombreCycle % Nc: Nombre de cycles
        for k = 1:4 % K: Nombre d'images que contient un cycle
                [deltaX{i,4*(j-1)+k}, deltaY{i,4*(j-1)+k}] = ExtPhaseCorrelation(ImageRef,ImageBucket{i,4*(j-1)+k});
                [nr,nc]=size(ImageRef);
                Nr = ifftshift((-fix(nr/2):ceil(nr/2)-1));
                Nc = ifftshift((-fix(nc/2):ceil(nc/2)-1));
                [Nc,Nr] = meshgrid(Nc,Nr);
                Greg{i,4*(j-1)+k} = (fft2(ImageARec{i,4*(j-1)+k}).*exp(-1i*2*pi*(deltaX{i,4*(j-1)+k}*Nr/nr+deltaY{i,4*(j-1)+k}*Nc/nc))).*exp(1i*0);
                Recale{i,4*(j-1)+k}= abs (ifft2 (Greg{i,4*(j-1)+k}));%#ok<SAGROW>
                
        end
    end
end

%Statistique d?placement moyen


for n=1:1:4*(NombreCycle-1)+4
    sommeX = sum([Tx{:}]);
    moyenneX=sommeX /(4*(NombreCycle-1)+4);
end

for n=1:1:4*(NombreCycle-1)+4
    sommeY = sum([Ty{:}]);
    moyenneY=sommeY /(4*(NombreCycle-1)+4);
end

NormVecteurMoyen=sqrt((moyenneX.^2)+(moyenneY.^2));

%Moyenne image recal? et non recal?

for n=1:4*(NombreCycle-1)+4
    RecaleMoy{1,n}= mean(cat(3, Recale{1,n},Recale{1,n}), 3);%#ok<SAGROW> 
end
for n=1:4*(NombreCycle-1)+4
    NonRecaleMoy{1,n}= mean(cat(3, ImageBucket{1,n},ImageBucket{1,n}), 3);%#ok<SAGROW> 
end
%%%%%% METHODE 4 BUCKET %%%%%%%%

NbSum=(4*(NombreCycle-1)+4)/4;

sumI1 = zeros(size(cdata1));
for n=1:4:4*(NombreCycle-1)+4
    sumI1 = sumI1 + RecaleMoy{1,n};
end
sumI1moy=sumI1/NbSum;

sumI2 = zeros(size(cdata1));
for n=2:4:4*(NombreCycle-1)+4
    sumI2 = sumI2 + RecaleMoy{1,n};
end

sumI2moy=sumI2/NbSum;

sumI3 = zeros(size(cdata1));
for n=3:4:4*(NombreCycle-1)+4
    sumI3 = sumI3 + RecaleMoy{1,n};
end
sumI3moy=sumI3/NbSum;

sumI4 = zeros(size(cdata1));
for n=4:4:4*(NombreCycle-1)+4
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
title('image du 4bucket corr?lation de phase subpix?lis? ');
xlabel('Xpixel'); 
ylabel('Ypixel');
colormap(jet)
colorbar
caxis([0.0 0.04]);
%%%%%%%%%%%%%%%%% IMAGE THERMIQUE %%%%%%%%%%%%%%%%%%%%
ImTherNorm = Bucket./ImMatixCoefCalNorm;
figure
imagesc(ImTherNorm)
colormap(jet)
colorbar
title('Image Thermique corr?lation de phase subpix?lis?');
xlabel('Xpixel'); 
ylabel('Ypixel');
caxis([0.0 10]);