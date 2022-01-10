function [H_Im_F,H] = lpfilter(type,M,N,D0,n,ImagRef)
%H_Im_F >> image filtre 
% H >> le filtre utiliser

%LPFILTER Computes frequency domain lowpass filter transfer functions.
% H = LPFILTER(TYPE,M,N,D0,n) generates the transfer function., H, of a
% lowpass filter of the specified TYPE and size (M-by-N).
%
% Valid values for TYPE, D0, and n are:
%
% ’ideal' Ideal lowpass filter transfer function with cutoff
% frequency 00. n is not needed. 00 must be positive.
%
% 'butterworth’ Butterworth lowpass filter transfer function of order
% n, and cutoff frequency D0. The default value for n is
% 1.0. D0 must be positive.

% 'gaussian' Gaussian lowpass filter transfer function with cutoff
% frequency (standard deviation) 00. n is not needed. D0
% must be positive.
%
% H is floating point of class double. It is returned uncentered for
% consistency with filtering function dftfilt. To view H as an image or
% mesh plot, it should be centered using He = fftshift(H).
% Protect against uppercase.
type = lower(type);
% Use function dftuv to set up the meshgrid arrays needed for computing
% the required distances.
[U,V] = dftuv(M,N);
% Compute the distances D(U,V).
D = hypot(U,V);
% Begin filter computations.
switch type
case 'idea'
H = double(D <= D0);
case 'butterworth'
if nargin == 4
n = 1;
end
H = 1./(1 + (D./D0).^(2*n));
H_Im_F=fft2(fftshift(ImagRef)).*H;
H_Im_F=fftshift(ifft2(H_Im_F));
case 'gaussian'
H = exp(-(D.A2)./(2*(D0^2)));
case 'test'
A1=0.99999;
A2=0.9999;
x0=143.95004;
dx=30.81231;
H=A2+(A1-A2)./(1+exp((D-x0)/dx));
H_Im_F=fft2(fftshift(ImagRef)).*H;
H_Im_F=fftshift(ifft2(H_Im_F));     
otherwise
error('Unknown filter type.')
end