clear; close all; clc; clear global;

% parameter setting
par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 3;
par_scblklen = 100;
switch_off = 1;
par_fifolen = 10000;
par_ccblklen = 16;
par_tx_w=8;
par_H = [1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 0);
[b,code_trees, len_idx] = source_coding(u, par_scblklen, 0, 0);

[b_buf]=tx_fifo(b, par_fifolen, par_ccblklen, 1);

c=channel_coding(b_buf,par_H,0);
d=modulation(c,0,1);


s=10*tx_filter(d,par_tx_w,1);
x = tx_hardware(s,1,1);
%ss=tx_filter_s(d,par_tx_w,1);
