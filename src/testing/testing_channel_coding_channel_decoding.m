clear; close all; clc
addpath('../receiver');
addpath('../transmitter');

% parameter setting
par_H = [1 0 1 0 1 0 1;
         0 1 1 0 0 1 1;
         0 0 0 1 1 1 1];
switch_off = 0;

% error data for flipped bits
N = size(par_H, 2);
iNmbrOfWrds = 16;
f = randi(N+1, iNmbrOfWrds, 1)-1;
e = zeros(iNmbrOfWrds,N);
e(sub2ind(size(e), find(f>0), f(f>0))) = 1;
e = e';

% input
w = (dec2bin(0:15, 4) - '0')';
b_buf = w(:);

% processing
c = channel_coding(b_buf, par_H, switch_off);
c_hat = mod(c + e(:), 2);
% c_hat = c;
b_hat = channel_decoding(c_hat, par_H, switch_off);

% output
disp([b_buf b_hat]);
