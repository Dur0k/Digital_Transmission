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
par_fifolen = 10;
par_ccblklen = 1600;
par_tx_w = 8;
par_rx_w = par_tx_w;
switch_graph = 1;
par_sdblklen = 3;

b_hat = [1 2 3 4 5 6];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,1)
b_hat = [];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,0)
b_hat = [7 8 9];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,0)
b_hat = [];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,0)
b_hat = [];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,0)
b_hat = [];
b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,0)