clear all; close all; clc
addpath('transmitter');
addpath('receiver');
par_no = 200;
switch_reset = 1;
par_w = 2;
par_q = 8;
par_scblklen = 100;
switch_off = 0;
par_fifolen = 10000;
par_ccblklen = 512;%640;%1600;
par_tx_w = 8;
par_H = [1 0 1 0 1 0 1;
         0 1 1 0 0 1 1;
         0 0 0 1 1 1 1];

par_rx_w = par_tx_w;
switch_graph = 0;
switch_mod = 1;
par_txthresh = 1;
par_rxthresh = par_txthresh;
par_SNRdB = 20;
rayleigh = 0;
data = [1+1j; 1+1j; 1+1j; 1+1j];
N = 5;

c = [];
d = [];
s = [];
x = [];
y = [];
MSE_t = 0;
BER_u_t = 0;
BER_c_t = 0;
BER_b_t = 0;
%fprintf('run\ta\tb\tb_buf\tc\td\ts\tx\ty\n');
fprintf('run\t\tMSE\t\tBER_u\t\tBER_c\t\tBER_b\n');

len_b = [];
codes = [];
%in_a = [];
%in_u = [];
%in_c = [];
%in_b = [];
for kk=1:N
% source
a = analog_source(par_no, switch_reset, 0);
% transmitter
u = ad_conversion(a, par_w, par_q, switch_graph);
[b, code_tree, len_idx] = source_coding(u,par_scblklen,switch_off,switch_graph);
b_buf = tx_fifo(b, par_fifolen, par_ccblklen, switch_reset);
c = channel_coding(b_buf, par_H, switch_off);
d = modulation(c, switch_mod, switch_graph);
if rayleigh
    [d] = tx_channel_est(d, data, switch_graph);
end
s = tx_filter(d, par_tx_w, switch_graph);
x = tx_hardware(s, par_txthresh, switch_graph);
if rayleigh 
    y = channel_rayleigh(s,par_SNRdB,switch_graph);
else
    y = channel(x, par_SNRdB, 0);
end

% channel
len_b = [len_b; len_idx];
%in_a = [in_a; a]
codes = [codes; code_tree];
switch_reset = 0;

%s_tilde = s;
% receiver
[s_tilde] = rx_hardware(y,par_rxthresh,switch_graph);
[d_tilde] = rx_filter(s_tilde,par_rx_w,switch_graph);
if rayleigh
    [d_tilde] = rx_channel_est(d_tilde,data,switch_graph);
end
c_hat = demodulation(d_tilde,switch_mod,switch_graph);
b_hat = channel_decoding(c_hat,par_H,switch_off);
b_hat_buf = rx_fifo(b_hat,par_fifolen, len_b(1),switch_reset);
u_hat = source_decoding(b_hat_buf, codes(1), len_b(1), switch_off);
[a_tilde] = da_conversion(u_hat, par_w, par_q, 1);

if ~isempty(b_hat_buf)
    if length(len_b) == 1
        len_b = [];
        codes =[];
    else
        len_b = len_b(2:end);
        codes = codes(2:end);
    end
end

% sink
[MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat);
MSE_t = MSE_t + MSE;
BER_u_t = BER_u_t + BER_u;
BER_c_t = BER_c_t + BER_c;
BER_b_t = BER_b_t + BER_b;
%fprintf('%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\n', kk, length(a), length(b), length(b_buf), length(c), length(d), length(s), length(x), length(y));
fprintf('%4i\t\t%4i\t\t%4i\t\t%4i\t\t%4i\n', kk, MSE, BER_u, BER_c, BER_b);
end
fprintf('\n');
fprintf('average\t\tMSE\t\tBER_u\t\tBER_c\t\tBER_b\n');
fprintf('%4i\t\t%4i\t\t%4i\t\t%4i\t\t%4i\n', kk, MSE_t/(kk-1), BER_u_t/(kk-1), BER_c_t/(kk-1), BER_b_t/(kk-1));