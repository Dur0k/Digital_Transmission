%clear all;
close all; 
par_tx_w = 8;
addpath('p-files/');
addpath('transmitter/');
addpath('receiver/');

%56+i*8
data = [1+1j; 1+1j; 1+1j; 1+1j];
d = [1; 1; -1+1j; 0-1j; 1+1j; 1+1j];
[d_c] = tx_channel_est(d, data, 0);
s = tx_filter(d_c, par_tx_w, 1);
%s_p = tx_filter(p, par_tx_w, 0);

z = channel_rayleigh(s,50,0);
[d_tilde] = rx_filter(z,par_tx_w,1);

%phase=mean(mean(angle(s)-angle(z)));
%phase=mean(angle(z(1:2)'./s(1:2)));
phase=mean(mean(angle(d_tilde(1:4).'./p(1:4))));

zz =  z  .* exp(-1j*(phase));
absz = mean(abs(p(1:4)./d_tilde(1:4)));
%freq = sum(real(d_tilde(1:4))./real(p(1:4))+1j*imag(d_tilde(1:4))./imag(p(1:4)))/length(p);
zz = zz.*absz;
d_tilde_shift = d_tilde .* exp(-1j*(phase)).*absz;

figure;
subplot(2,1,1);
plot(real(s),'k');
hold on;
plot(real(z))
subplot(2,1,2)
plot(imag(s),'k');
hold on;
plot(imag(z))
title('Before')

figure;
subplot(2,1,1);
plot(real(s),'k');
hold on;
plot(real(zz))
subplot(2,1,2)
plot(imag(s),'k');
hold on;
plot(imag(zz))
%figure;
%plot(abs(s));
%hold on;
%plot(real(z));
%Pzz = pwelch(z);
%plot(abs(z))
%p_mean = zeros(1,iii);
%for i=2:iii
%    s = tx_filter(d, par_tx_w, 0);
%    z = channel_rayleigh(s,i,0);
%    p_mean(i) = mean(angle(s)-angle(z));
%end

