function  [d_c] = tx_channel_est(d, data, switch_graph)
    % Add known test data to signal 
    d_c = [data; d];
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(d_c));
        title('Tx channel est');
        legend('I');
        %axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(d_c));
        legend('Q');
        %axis([0,length(s) -1,1])
        grid on;
    end
end
