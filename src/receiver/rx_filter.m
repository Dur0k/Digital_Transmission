function  [d_tilde] = tx_filter(s_tilde,par_rx_w,switch_graph)
    % Create a sinc of sufficient length
    x_si = [-3*par_rx_w:3*par_rx_w];
    si = sinc(x_si/par_rx_w);

    % Normalize the sinc impulse
    si_norm = si./sqrt(par_rx_w);
    % Convole the complex symbols with the sinc impulse
    s_filter = conv(s_tilde,si_norm);
    % Downsample
    d_tilde = s_filter(1:par_rx_w:end);
    % Discard extra values from sinc 
    d_tilde = d_tilde(3*2+1:end-3*2);
end
