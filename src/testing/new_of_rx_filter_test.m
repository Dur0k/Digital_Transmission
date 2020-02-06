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

d =[
  -0.3162 - 0.3162i;
  -0.3162 - 0.9487i;
  -0.3162 + 0.9487i;
  -0.3162 - 0.9487i;
  -0.9487 - 0.9487i;
  -0.3162 + 0.9487i;
  -0.3162 + 0.9487i;
  -0.3162 - 0.3162i;
  -0.3162 - 0.9487i;
  -0.9487 - 0.9487i;
  -0.9487 + 0.3162i;
   0.9487 - 0.9487i;
  -0.3162 + 0.9487i;
   0.9487 - 0.3162i;
   0.9487 + 0.9487i;
   0.9487 + 0.9487i;
  -0.3162 + 0.9487i;
  -0.3162 - 0.3162i;
  -0.9487 + 0.9487i;
   0.9487 - 0.9487i];

[s] = tx_filter(d,par_tx_w,switch_graph);
[d_tilde] = rx_filter(s,par_rx_w,switch_graph);