clear; close all; clc

b_hat=[randi([0 1],1600,1)]; %binäres testsignal der länge 1600
switch_reset = 1;
par_fifolen = 3000;
len_b=1000; % =length(b)
par_sdblklen = len_b;


b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset)
