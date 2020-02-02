clear; close all; clc

addpath('../receiver');
addpath('../transmitter');
% parameter setting
par_no = 200;
switch_reset = 1;
par_w = 2;
par_q = 8;
par_scblklen = 200;
switch_off = 1;
par_fifolen = 3000;
par_ccblklen = 1600;
par_tx_w = 8;
par_rx_w = par_tx_w;
switch_graph = 1;

% input
d = [0+1j 1 0+1j 1 0+1j 1+1j 1+1j 1+1j]';
d = [0+1j -1-1j]';
[s] = tx_filter(d,par_tx_w,switch_graph);
s_tilde = s;
[d_tilde] = rx_filter(s_tilde,par_rx_w,switch_graph);
figure;
subplot(2,1,1);
plot(real(d_tilde))
subplot(2,1,2);
plot(imag(d_tilde))
disp('Input == Output:');
dd = round(d_tilde);
disp(isequal(d,dd'));