function  [s_c] = tx_channel_est(s, data, switch_graph)
    s_c = [data s];
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(s_c));
        title('Tx channel est');
        legend('I');
        %axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(s_c));
        legend('Q');
        %axis([0,length(s) -1,1])
        grid on;
    end
end
