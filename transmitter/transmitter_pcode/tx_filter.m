function  [s] = tx_filter(d,par_tx_w,switch_graph)
    %TX_FILTER reconstruct the analog signal by using the ideal low-pass filter 
    %coorperating with the input symbols and zero inserting  
    %
    %   [ s ] = tx_filter(d,par_tx_w,switch_graph)
    %
    %   'par_tx_w' is the oversampling for the zero inserting, e.g., par_tx_w = 8.
    %
    %   Switchable graph of the output of the ideal low-pass filter with
    %   On:  switch_graph = 1;
    %   Off: switch_graph = 0;


    % Insert par_tx_w-1 zeros between each sample
    %   d1 d2 d3 d4

    z = zeros(par_tx_w-1,length(d));
    tmp = [d';z];
    d_up = reshape(tmp,1,size(tmp,1)*size(tmp,2));


    % Create a sinc with x values of -24 to 24
    x_si = [-3*par_tx_w:3*par_tx_w];
    si = sinc(x_si/par_tx_w);

    % Normalize the sinc impulse
    si_norm = si./sqrt(par_tx_w);

    % Convole the complex symbols with the sinc impulse
    s = conv(d_up,si_norm);

    if switch_graph == 1
        figure;
        subplot(2,1,1)
        plot(real(s));
        title('Tx filter');
        legend('I');
        axis([0,length(s) -1,1])
        grid on;
        subplot(2,1,2);
        plot(imag(s));
        legend('Q');
        axis([0,length(s) -1,1])
        grid on;
    end
end
