clear all;
par_fifolen=10;
par_ccblklen = 5;

b=[1 1 1 1];
[b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,1);
disp(b_buf);
b=[0 0 0];
[b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,0);
disp(b_buf);
