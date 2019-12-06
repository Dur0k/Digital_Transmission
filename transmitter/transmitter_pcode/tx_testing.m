clear; close all; clc

% parameter setting
par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 8;
par_scblklen = 100;
switch_off = 1;
par_fifolen = 3000;
par_ccblklen = 1600;
par_tx_w=8;

% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 0);

[b, code_tree, len_idx] = source_coding(u, par_scblklen, 0, 0);

[b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset);

%[c] = channel_coding(b_buf,par_H,switch_off);
[d] = modulation(b_buf, 1, 1);

[s] = tx_filter(d,8,1);
