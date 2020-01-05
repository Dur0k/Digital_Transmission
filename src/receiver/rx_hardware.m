function [s_tilde] = rx_hardware(y,par_rxthresh,switch_graph)
    % Go through every value of s_tilde and check if its abs is larger then
    % thresh
    for i = 1:length(y)
        y_abs = abs(y(i));
        if (y_abs > par_rxthresh)
            y(i) = y(i)/y_abs;
        end
    end
    s_tilde = y;
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(y));
        title('Non-Linear Rx Hardware');
        legend('I');
        %axis([0,length(x), -par_txthresh,par_txthresh])
        grid on;
        subplot(2,1,2);
        plot(imag(y));
        legend('Q');
        %axis([0,length(x), -par_txthresh,par_txthresh])
        grid on;
    end
end
