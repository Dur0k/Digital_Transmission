clear; close all; clc
addpath('../receiver');
addpath('../transmitter');

% parameter setting
switch_mod = 0;

% input
w = (dec2bin(0:15, 4) - '0')';
c = w(:);

%  processing
d = modulation(c, switch_mod, 1);
d_tilde = d;
c_hat = demodulation(d_tilde, switch_mod, 1);

% output
disp([c c_hat]);
