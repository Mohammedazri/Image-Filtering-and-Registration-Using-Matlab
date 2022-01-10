%%Tracage du Fit 
nb=450;
while nb>0
    Tp1=input('Tracer de la température :');
    Tp2=input('à la température  :');

    Abs=input('Entrer le pixel que vous voulez tracer suivant x\n');
    Ord=input('Entrer le pixel que vous voulez tracer suivant y\n');    
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
    xlabel('Température');
    ylabel('Intensité');
end