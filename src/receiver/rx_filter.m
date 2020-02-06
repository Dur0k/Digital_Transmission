function  [d_tilde] = rx_filter(s_tilde,par_rx_w,switch_graph)
if isempty(s_tilde)
   d_tilde = []; 
else
    beta = 1;
    iFiltOrd = 64;
    L = par_rx_w; ... T_symbol/T_sample (oversampling factor)
    h = rcosdesign(beta, iFiltOrd/L, L);  
    %h = h * 1/sqrt(par_rx_w) * 1/max(h);
    d_tilde = conv(s_tilde,h.');
    d_tilde = d_tilde*L/2/sum(h);
    
    d_tilde = d_tilde(iFiltOrd+1:end-iFiltOrd);
    d_tilde = downsample(d_tilde,8);

    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(d_tilde));
        title('Rx filter');
        ylabel('I');
        %axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(d_tilde));
        ylabel('Q');
        %axis([0,length(s) -1,1])
        grid on;
    end
end
end
