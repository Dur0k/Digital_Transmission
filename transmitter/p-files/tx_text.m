clear; close all; clc

% parameter setting
par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 3;
par_scblklen = 100;
switch_off = 1;
par_fifolen = 1501;
par_ccblklen = 16;
par_H = [1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 1);
[b,code_tree] = source_coding(u, par_scblklen, switch_off, 0);

for i=1:1%par_fifolen/par_ccblklen
    if i==1
        [b_buf]=tx_fifo(b, par_fifolen, par_ccblklen, 1);
    else
        [b_buf]=tx_fifo([], par_fifolen, par_ccblklen, 0);
    end;
    disp(b_buf);
    c=channel_coding(b_buf,par_H,0);
    disp(c);
end

