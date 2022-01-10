%Implementation of:
%   Extension of Phase Correlation to Subpixel Registration
%   (Hassan Foroosh, Josiane B. Zerubia, Marc Berthod)
%Implemented by:
%   Lulu Ardiansyah (halluvme@gmail.com)
%
%TODO:
%   - Find out whether this implementation is correct :)
%   - Combine the result, overlay the images based on the result
%
%                                               eL-ardiansyah
%                                               January, 2010
%                                                       CMIIW
%============================================================
function [deltaY , deltaX ] = ExtPhaseCorrelation(img1, img2)
%Description:
%   Find the translation shift between two image
%
%Parameter:
%   img1 = image 1
%   img2 = image 2
%   image 1 and image 2 , must in the same size
%Phase correlation (Kuglin & Hines, 1975)
%============================================================

af = fftn(double(img1));
bf = fftn(double(img2));
cp = af .* conj(bf) ./ abs(af .* conj(bf));
icp = (ifft2(cp));
mmax = max(max(icp));
%[output,row_shift,col_shift, Greg] = dftregistration(af,bf,1);
[output,row_shift1,col_shift1, Greg] = dftregistration(fft2(img1),fft2(img2),1);
if(  row_shift1 > -1 && row_shift1 < 1 &&  col_shift1 > -1 && col_shift1 < 1 )
    %Extension to Subpixel Registration [Foroosh, Zerubia & Berthod, 2002]
    %============================================================
    [x,y,~] = find(mmax == icp);
    [M, N] = size(img1);
    %two side-peaks
    xsp = x + 1;
    xsn = x - 1;
    ysp = y + 1;
    ysn = y - 1;
    %if the peaks outsize the image, then use xsn and/or ysn for the two
    %side-peaks
    if xsp > M
        xsp = M-1;
    end
    if ysp > N
        ysp = N-1;
    end
    %Calculate the translational shift
    deltaX1 = ((icp(xsp,y) * xsp + icp(x,y) * x) / (icp(xsp,y) + icp(x,y)))-1;
    deltaY1 = ((icp(x,ysp) * ysp + icp(x,y) * y) / (icp(x,ysp) + icp(x,y)))-1;
    %I don't know why but after few test i find out that the result of deltaX
    %and delta Y is inverted.. :( ??
    %Validate if translation shift is negative
    if deltaX1 < (N/2)
        deltay = deltaX1;
    else
        deltay = deltaX1 - M;
    end
    if deltaY1 < (M/2)
        deltax = deltaY1;
    else
        deltax = deltaY1 - N;
    end
    deltaX=real(deltax);
    deltaY=real(deltay);

elseif(  row_shift1 >= 2  &&  col_shift1 >= 2 )

    a=250;
    cpzoom=icp(1:a,1:a);
    %imagesc(cpzoom);
    %figure('Name','Image de correlation de phase');
    indices=[0:a-1];
    [xm,ym]=meshgrid(indices,indices);
    %CPzoomColor=zeros(size(cpzoom));
    %CPzoomColor(1,end)=1;
    %mesh(xm,ym,cpzoom,'FaceColor','interp');
    %title('correlation de phase');
    ix = imregionalmax(cpzoom);

    %hold on
    %plot3(xm(ix),ym(ix),cpzoom(ix),'r*','MarkerSize',24)
    coef=cpzoom(ix);
    zmax=max(coef(coef<max(coef)));
    I=find(cpzoom==zmax);
    xi=(xm(I)); %x value corresponding to the points where Z is second maximum
    yi=(ym(I)); %y value corresponding to the points where Z is second maximum
    xi=abs(xi);
    yi=abs(yi);
    [M, N] = size(img1);
    %two side-peaks
    xsp = xi + 1;
    xsn = xi - 1;
    ysp = yi + 1;
    ysn = yi - 1;
    %if the peaks outsize the image, then use xsn and/or ysn for the two
    %side-peaks
    if xsp > M
        xsp = M-1;
    end
    if ysp > N
        ysp = N-1;
    end
   %Calculate the translational shift
    deltaX11 = ((icp(xsp,yi) * xsp + icp(xi,yi) * xi) / (icp(xsp,yi) + icp(xi,yi)))-1;
    deltaY11 = ((icp(xi,ysp) * ysp + icp(xi,yi) * yi) / (icp(xi,ysp) + icp(xi,yi)))-1;

    if deltaX11 < (N/2)
        deltay = deltaX11;
    else
        deltay = deltaX11 - M;
    end
    if deltaY11 < (M/2)
        deltax = deltaY11;
    else
        deltax = deltaY11 - N;
    end
    deltaX=real(deltax);
    deltaY=real(deltay);


else
    deltaX=row_shift1;
    deltaY=col_shift1;
    
end