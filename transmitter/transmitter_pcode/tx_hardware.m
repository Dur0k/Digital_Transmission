function x = tx_hardware(s,par_txthresh,switch_graph)
%TX_HARDWARE models the influences from an amplifier on the baseband signal
%by the hard thresholding.
%
%   x = tx_hardware(s,par_txthresh,switch_graph)
%
%   The non-linear behavior is modeled by a linear input and output
%   relation for the absolute value of s up to par_txthresh and 1 for
%   otherwise.
%
%   Switchable graph to draw the output of the non-linear hardware with
%   On:  switch_graph = 1;
%   Off: switch_graph = 0;
%

    % Go through every value of s and check if its abs is larger then
    % thresh
    for i = 1:length(s)
        s_abs = abs(s(i));
        if (s_abs > par_txthresh)
            s(i) = s(i)/s_abs;
        end
    end
    x = s;
    
    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(x));
        title('Non-Linear Hardware');
        legend('I');
        %axis([0,length(x), -par_txthresh,par_txthresh])
        grid on;
        subplot(2,1,2);
        plot(imag(x));
        legend('Q');
        %axis([0,length(x), -par_txthresh,par_txthresh])
        grid on;
    end
end