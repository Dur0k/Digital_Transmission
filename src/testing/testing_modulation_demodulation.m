clear; close all; clc
addpath('../receiver');
addpath('../transmitter');

% parameter setting
switch_mod = 1;

% input
w = [1 1 0 1 0 0 0 0 1 1 1 1 0 1 0 1 1 1 0 0 1 1 1 1 0 0 0 0 1 0 1 1 0 1 0 1 1 1 1 1 0 0 0 0 1 1 1 1 0 1 0 1 0 1 1 0 1 1 1 1 0 1 0 0 0 1 0 1 0 0 0 0 1 1 1 1 0 1 0 1]';
c = w(:);

%  processing
d = modulation(c, switch_mod, 1);

%d_tilde = d-0.1;
%d =[0.3162 + 0.3162i;
%  -0.9487 - 0.9487i;
%   0.3162 + 0.3162i];
c_hat = demodulation(d, switch_mod, 1);

% output
%disp([c c_hat]);
disp(c == c_hat);