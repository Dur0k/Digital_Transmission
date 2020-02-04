function  [d_tilde] = rx_filter(s_tilde,par_rx_w,switch_graph)
    % Create a sinc of sufficient length
    x_si = [-3*par_rx_w:3*par_rx_w];
    si = sinc(x_si/par_rx_w);

    % Normalize the sinc impulse
    si_norm = si./sqrt(par_rx_w);
    % Convole the complex symbols with the sinc impulse
    s_filter = conv(s_tilde,si_norm);
    % Discard extra values from sinc 
    d_tilde = s_filter(3*2*par_rx_w+1:end-3*2*par_rx_w);
    % Downsample
    d_tilde = d_tilde(1:par_rx_w:end);
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(d_tilde));
        title('Rx filter');
        legend('I');
        %axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(d_tilde));
        legend('Q');
        %axis([0,length(s) -1,1])
        grid on;
    end
end
