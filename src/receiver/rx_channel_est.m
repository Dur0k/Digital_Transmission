function  [d_tilde_c] = rx_channel_est(d_tilde,data,switch_graph)
    % Calculate phase difference of known data before and after the channel
    phase_d = mean(mean(angle(d_tilde(1:length(data))./data)));
    % Power difference
    abs_d = mean(abs(data./d_tilde(1:length(data))));
    % Shift phase and scale symbols
    d_tilde_c_plot = d_tilde * abs_d * exp(-1j*(phase_d));
    d_tilde_c = d_tilde_c_plot(length(data)+1:end);
    
    if switch_graph == 1
        figure;
        subplot(2,1,1);
        plot(real(d_tilde),'k');
        title('Rx channel est');
        hold on;
        plot(real(d_tilde_c_plot));
        grid on;
        legend('real(d_{in})','real(d_{out})');
        subplot(2,1,2);
        plot(imag(d_tilde),'k');
        hold on;
        plot(imag(d_tilde_c_plot));
        grid on;
        legend('imag(d_{in})','imag(d_{out})');
        
        figure;
        scatter(real(d_tilde),imag(d_tilde));
        hold on;
        scatter(real(d_tilde_c_plot),imag(d_tilde_c_plot));
        title('Rx channel est');
        xlim([-2,2]);
        ylim([-2,2]);
        xlabel('Re');
        ylabel('Im');
    end

end
