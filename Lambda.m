%clc
%clear
%%Choix de l'image de référence 
TempNorm=input('Donner la température de normalisation\n');
fichiersRecherches = '*.xlsx'; %selection des fichiers.xlsx puis ouverture
[FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers spectro xlsx', 'MultiSelect', 'on');
FileName = cellstr(FileName);

m1 = cell(1,length(FileName)); %initialisation matrice m

for i_file = 1:size(m1,2)%lecture des données de l'image
m1{i_file} = xlsread(fullfile(PathName, FileName{i_file}));
end
Norm=m1{1,1};
    
   
NombreTemp=input('Donner le nombre de température\n');
fprintf("Sélection des fichiers spectromètre \n"); 
spect = cell(1,NombreTemp);
[i,j]=(spect{1,:}); 
for Temp=1:NombreTemp
    a=input('Entrer la valeur de la température \n');
    T{1,Temp}=a;
    fichiersRecherches = '*.xlsx'; %selection des fichiers.xlsx puis ouverture 
    [FileName,PathName] = uigetfile(fichiersRecherches,'Sélectionnez les fichiers spectro xlsx', 'MultiSelect', 'on'); 
    FileName = cellstr(FileName);

    m = cell(1,length(FileName)); %initialisation matrice m

    for i_file = 1:size(m,2)%lecture des données de l'image
        m{i_file} = xlsread(fullfile(PathName, FileName{i_file})); 
    end
    spect{1,Temp}=m{1,1};
    [x,u]=size(Norm);
    lam=spect{1,Temp}(:,1);
    in=spect{1,Temp}(:,2);    
    %K=in./Norm(:,2);
    figure
    plot(lam,in);
    title(['Spectre pour ' num2str(a) ' degrès']);
    xlabel('lambda');
    ylabel('Intensité');
   % droite = polyfit(lam,K,1);
end  

for Temp=1:NombreTemp
    for i=1:x
        for j=1:u

            Y=[spect{1,Temp}(i,2)/Norm(i,2)];
            Ttout=cell2mat(T);
            droite = polyfit( Ttout(1,Temp),Y,1);
            warning('off','all');
            MatrixCoefCalNorm{i,1}=droite(1);
            Ordonnee{i,1}=droite(2);

        end
    end
end
data1=cell2mat(MatrixCoefCalNorm);


figure
semilogy(lam,data1);
title('K en fonction de lambda ');
xlabel('lambda (nm)');
ylabel('K(Kelvin^-1)');



%%Fit des Températures en fonction de l'intensité en fonction de lambda

%y=[];
nb=450;
while nb>0
    lambda=input('choisir la ligne de la longueur à tracer :');
    for Nb=1:NombreTemp

            y(1,Nb)=spect{1,Nb}(lambda,2)/Norm(lambda,2);
            Ttout=cell2mat(T);


    end
    data=y;
    P = polyfit( Ttout,data,1);
    figure
    yfit = P(1)*Ttout+P(2); 
    scatter(Ttout,data,50,'b','*')
    hold on; 
    plot(Ttout,yfit,'r-.');
    title(['Fit pour ' num2str(lam(lambda,:)) ' nm']);
    xlabel('Température');
    ylabel('Intensité');
end
