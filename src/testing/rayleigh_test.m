clear; close all; clc
addpath('../transmitter');
addpath('../receiver');
par_rx_w = 8;
par_tx_w = 8;

d = [.5-.5j .5-.5j 1-1j 1-1j -1+1j -1+1j 1-1j 1-1j]';

[s] = 10*tx_filter(d,par_tx_w,1)';%10*
%xs = linspace(1,10,100);
%s = 1.2*exp(2j*pi*xs/5);
s_tilde = channel_rayleigh(s,0,0);


%channel_phase = sum(real(angle(d_tilde)./real(d)+1j*imag(d_tilde)./imag(d))/length(d)
channel_phase = 1/length(s) *sum(angle(s) - angle(s_tilde))
s_p = -1 *s_tilde * exp(-1j*channel_phase);
d_tilde = rx_filter(s_p,par_rx_w,1);

figure;
plot(abs(angle(s)));
hold on;
plot(abs(angle(s_tilde)));

%figure;
%subplot(2,1,1)
%plot(real(s_tilde));
%subplot(2,1,2);
%plot(imag(s_tilde));
%figure;
%plot(angle(s_tilde))
%hold on
%plot(angle(s));

figure;
subplot(2,1,1)
plot(real(s_tilde)); hold on; plot(real(s));
title('Before *p');
subplot(2,1,2);
plot(imag(s_tilde)); hold on; plot(imag(s))

figure;
subplot(2,1,1)
plot(real(s_p)); hold on; plot(real(s));
title('After *p');
subplot(2,1,2);
plot(imag(s_p)); hold on; plot(imag(s))