function  [s] = tx_filter(d,par_tx_w,switch_graph)
if isempty(d)
   s = []; 
else
    % design filter impulse response
    beta = 1;
    iFiltOrd = 64;
    L = par_tx_w; ... T_symbol/T_sample (oversampling factor)
    h = rcosdesign(beta, iFiltOrd/L, L);%/sqrt(par_tx_w);  
    h = h * 1/sqrt(par_tx_w) * 1/max(h);
    z = zeros(par_tx_w-1,length(d));
    tmp = [d.';z];
    d_up = tmp(:);

    %sr = filtfilt(h,1,real(d_up));
    %si = filtfilt(h,1,imag(d_up));
    %s = sr + 1j*si;
    s = conv(d_up,h.');
    %s = s *L/sum(h);
    %filter = rcosdesign(0.5,7,par_tx_w); % RRC-Filter mit Roll-off-Faktor 0.5 und einer Dauer von 6 Symbolen
    %filter = (1/sqrt(par_tx_w))*(h/max(h)); % Normierung
    %s = conv(d_up, filter);    % Filterung
    
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(s));
        title('Tx filter');
        ylabel('I');
        %axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(s));
        ylabel('Q');
        %axis([0,length(s) -1,1])
        grid on;
    end
end
end
