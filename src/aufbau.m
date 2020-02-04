clear; close all; clc

% parameter setting
addpath('transmitter');
addpath('receiver');

N = 2;
par_no = 1*2*100; ... number of samples from source (must be multiple of source coding chunk size)
switch_reset = 1; ... reset source and clear buffers
par_w = 2; ... downsampling factor prior to A/D conversion (must be an integer)
par_q = 8; ... number of bits for quantization
par_scblklen = 50; ... source coding chunk size for block processing of bit stream
switch_off = 0;
par_fifolen = 1024; ... buffer size for block processing of bit stream (must be bigger than source coding block size)
par_ccblklen = 512; ... channel coding chunk size for block processing of bit stream (must be bigger than source coding block size/smaller than buffer size)
par_H = [1 0 1 0 1 0 1;
         0 1 1 0 0 1 1;
         0 0 0 1 1 1 1];
switch_mod = 0; ... toggle modulation type (0 = 16-QAM and 1 = 16-PSK)
par_tx_w = 8; ... oversampling factor prior to TX filter
par_txthresh = 1; ... limit of TX amplifier
par_SNRdB = 60; ... signal to noise ratio of baseband channel
par_rxthresh = par_txthresh;
par_rx_w = par_tx_w;
switch_graph = 0;
par_sdblklen = par_scblklen;

fprintf('run\ta\tb\tb_buf\tc\td\ts\tx\ty\n');

for kk=1:N
% input
a = analog_source(par_no, switch_reset, 0);
% processing
u = ad_conversion(a, par_w, par_q, 0);
[b,code_tree,len_idx] = source_coding(u, par_scblklen, switch_off, 0);
b_buf = tx_fifo(b, par_fifolen, par_ccblklen, switch_reset);
c = channel_coding(b_buf, par_H, switch_off);
d = modulation(c, switch_mod, 0);
s = tx_filter(d, par_tx_w, 0);
x = 10*tx_hardware(s, par_txthresh, 0);
y = channel(x, par_SNRdB, 0);       
switch_reset = 0;

% receiver
[s_tilde] = rx_hardware(y,par_rxthresh,switch_graph);
[d_tilde] = rx_filter(s_tilde,par_rx_w,switch_graph);
c_hat = demodulation(d_tilde,switch_mod,switch_graph);
b_hat = channel_decoding(c_hat,par_H,switch_off);
b_hat_buf = rx_fifo(b_hat,par_fifolen,sum(len_idx),switch_reset);
%u_hat = source_decoding(b_hat_buf, code_tree, len_idx, switch_off);
%[a_tilde] = da_conversion(u_hat, par_w, par_q, switch_graph);
%[MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat);

fprintf('%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\n', kk, length(a), length(b), length(b_buf), length(c), length(d), length(s), length(x), length(y));
end
