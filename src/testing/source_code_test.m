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
par_tx_w=8;

% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 0);

[b, code_tree, len_idx] = source_coding(u, par_scblklen, 0, 0);

u_hat=source_decoding(b,code_tree, len_idx, switch_off);
disp('Input == Output:');
disp(isequal(u_hat,u));