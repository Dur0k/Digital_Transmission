%clear all;
close all; 
par_tx_w = 8;
addpath('p-files/');
addpath('transmitter/');
addpath('receiver/');

%56+i*8
d = [1, 1, -1+j, 0-j, 1+j, 1+j]';
s = tx_filter(d, par_tx_w, 0);
s= [1 1 s];

z = channel_rayleigh(s,100,0);
[d_tilde] = rx_filter(z,par_tx_w,1)

%phase=mean(mean(angle(s)-angle(z)));
phase=mean(angle(z(1:2)'./s(1:2)));
zz =  z  .* exp(1j*(phase));
absz = abs(s(1:2)/zz(1:2)');

zz = zz.*absz;

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

