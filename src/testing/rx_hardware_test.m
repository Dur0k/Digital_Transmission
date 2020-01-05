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
par_txthresh = 1;
par_rxthresh = par_txthresh;
% input
xs = linspace(1,10,100);
ys = 1.2*exp(2j*pi*xs/5);

x = tx_hardware(ys,par_txthresh,switch_graph);
y = ys.*x;
figure;
plot(y);
[s_tilde] = rx_hardware(y,par_rxthresh,switch_graph);