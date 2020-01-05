clear; close all; clc

addpath('../receiver');
addpath('../transmitter');
% parameter setting
par_no = 128;
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

xs = linspace(1,10,100);
ys = sin(2*pi*xs/5);
a = [1 1];
a_tilde = [1 0.6];
u = [1 1 1; 0 1 1; 0 1 0];
u_hat = [1 1 0; 0 1 1; 0 1 0];
b = [0 1 0 1 0 1 0 1 0 1];
b_hat = [1 1 1 1 0 1 0 1 0 1];
c = b;
c_hat = b_hat;
[MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat)