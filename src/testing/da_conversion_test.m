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

y = ad_conversion(ys, par_w, par_q, 1);
u_hat=y;
[a_tilde] = da_conversion(u_hat, par_w, par_q, switch_graph);
