y=[];
[PixelX,PixelY]=size(cdata1);
for Nb=1:NumbTemp
    
    for i=1:PixelX
        for j=1:PixelY
                
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
