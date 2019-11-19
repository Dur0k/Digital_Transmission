clear; close all; clc

% parameter setting
par_no = 1000;
switch_reset = 1;
par_w = 2;
par_q = 8;

% input
a = analog_source(par_no, switch_reset, 0);

% processing
u = ad_conversion(a, par_w, par_q, 1);