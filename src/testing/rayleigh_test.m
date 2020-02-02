clear; close all; clc
addpath('../transmitter');
addpath('../receiver');
par_rx_w = 8;
par_tx_w = 8;

data = [1+1j; 1+1j; 1+1j; 1+1j];
d = [1; 1; -1+1j; 0-1j; 1+1j; 1+1j];

[d_c] = tx_channel_est(d, data, 0);
s = tx_filter(d_c, par_tx_w, 1);

y = channel_rayleigh(s,100,0);

[d_tilde] = rx_filter(y,par_tx_w,1);

[d_tilde_c] = rx_channel_est(d_tilde,data,1);
