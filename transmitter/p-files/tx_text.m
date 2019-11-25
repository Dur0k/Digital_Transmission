%clear; close all; clc

% parameter setting
par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 3;
par_scblklen = 100;
switch_off = 1;
par_fifolen = 3000;
par_ccblklen = 16;
par_tx_w=8;
par_H = [1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];
% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 0);
[b,code_trees, len_idx] = source_coding(u, par_scblklen, 0, 1);

%for i=1:4%par_fifolen/par_ccblklen
%    if i==1
%        [b_buf]=tx_fifo(b, par_fifolen, par_ccblklen, 1);
%        d=[];
%    else
%        [b_buf]=tx_fifo([], par_fifolen, par_ccblklen, 0);
%    end
%    disp(b_buf);
%    c=channel_coding(b_buf,par_H,0);
%    d=[d modulation(c,0,1)'];
%end%

%s=tx_filter(d,par_tx_w,1);
%ss=tx_filter_s(d,par_tx_w,1);