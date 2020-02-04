clear all; close all; clc
addpath('../receiver');
addpath('../transmitter');
par_no = 200;
switch_reset = 1;
par_w = 2;
par_q = 8;
par_scblklen = 100;
switch_off = 0;
par_fifolen = 10000;
par_ccblklen = 640;%1600;
par_tx_w = 8;
par_H = [1 0 1 0 1 0 1;
         0 1 1 0 0 1 1;
         0 0 0 1 1 1 1];

par_rx_w = par_tx_w;
switch_graph = 0;
N = 5;

c = [];
d = [];
s = [];
x = [];
y = [];
fprintf('run\ta\tb\tb_buf\tc\td\ts\tx\ty\n');

for kk=1:N
% source
a = analog_source(par_no, switch_reset, 0);
% transmitter
u = ad_conversion(a, par_w, par_q, switch_graph);
[b, code_tree, len_idx] = source_coding(u,par_scblklen,switch_off,switch_graph);
b_buf = tx_fifo(b, par_fifolen, par_ccblklen, switch_reset);
%c = channel_coding(b_buf, par_H, switch_off);

% channel
switch_reset = 0;
%c_hat = c;
b_hat = b_buf;

% receiver
%b_hat = channel_decoding(c_hat,par_H,switch_off);
b_hat_buf = rx_fifo(b_hat,par_fifolen, length(b),switch_reset);
u_hat = source_decoding(b_hat_buf, code_tree, len_idx, switch_off);
[a_tilde] = da_conversion(u_hat, par_w, par_q, 1);

% sink

%[MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat);
if isempty(a_tilde) | isempty(u_hat) %| isempty(b_hat)
   MSE = inf;
   BER_u = inf;
   BER_c = inf;
   BER_b = inf;
else
    len = length(u_hat);
    BER_u = sum(sum(abs(u(1:len,:)-u_hat(1:len,:))))/(size(u(1:len,:),1)*size(u(1:len,:),2));
end
len = length(a_tilde);
MSE = 1/length(a(1:len)) .* sum(a(1:len) - a_tilde(1:len))^2;
disp(len_idx);
%disp(MSE);
disp(BER_u);
fprintf('%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\t%4i\n', kk, length(a), length(b), length(b_buf), length(b_hat_buf), length(d), length(s), length(x), length(y));

end