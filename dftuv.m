function [U,V] = dftuv(M,N)
%DFTUV Computes meshgrid frequency matrices.
% [U,V] = DFTUV(MjN) computes meshgrid frequency matrices U and V. U
% and V are useful for computing frequency-domain filter transfer
% functions that can be used with function DFTFILT. U and V are both
% of size M-by-N and of class double,
% Set up range of variables.
u = 0:(M - 1);
v = 0:(N - 1);
% Compute the indices for use in meshgrid.
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;
% Compute the meshgrid arrays.
[V,U] = meshgrid(v,u);


