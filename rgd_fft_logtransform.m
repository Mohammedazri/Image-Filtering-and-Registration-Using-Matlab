function [F,abs_fft,abs_fftsh,log_abs_F,log_abs_FsH,phase_fft,Fsh] = rgd_fft_logtransform(imdata)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
imdata_1 = im2gray(imdata);
%subplot(4,3,2);imshow(imdata_1), title('gray image');

%Get Fourier Transform of an image
F = fft2(imdata_1);
%Fourier transform of an image
abs_fft=abs(F);
Fsh = fftshift(F);
abs_fftsh=abs(Fsh);
%subplot(4,3,3); imshow(S,[]);title('Fourier transform of an image')
%calcule de la phase
phase_fft = angle(F);

%get the centre of spectre
%fftshift Shift zero-frequency component to center of spectrum.
%Fsh = fftshift(F);
%subplot(4,3,2); imshow(abs(Fsh),[]); title('Le module de la TF');
%apply log transform
log_abs_F=200*log(1+abs(F));
log_abs_FsH=200*log(1+abs(Fsh));

%______________IFF

%S2=200*log(1+abs(Fsh));
%subplot(4,3,3); imshow(S2,[]); title('le recalage logarithmique');
end

