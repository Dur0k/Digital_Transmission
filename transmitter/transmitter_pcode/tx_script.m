clear all;
close all;

switch_off = 0;
switch_graph = 1;
par_scblklen = 100;
par_ccblklen = 100;
par_fifolen = 1000;
switch_off = 1;
par_H = [];
%u=[0 0; 0 1; 1 0; 1 1; 0 0; 0 0; 0 0; 1 1];
%[b, code_tree, len_idx]

par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 8;
par_tx =8;

a = analog_source(par_no,switch_reset,0);

u = ad_conversion(a,par_w,par_q,0);
[b,code] = source_coding(u,par_scblklen,switch_off,switch_graph);

%u=[]
%[b,code] = source_coding(u,par_scblklen,switch_off,switch_graph);
%[b,code] = source_coding(u,par_scblklen,switch_off,switch_graph);
%[b,code] = source_coding(u,par_scblklen,switch_off,switch_graph);

b_buf = tx_fifo(b,par_fifolen,par_ccblklen,switch_reset);

%c = channel_coding(b_buf, par_H, switch_off);

d = modulation(b_buf,0,0);

s = tx_filter(d,par_tx,1);