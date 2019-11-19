function analog_source
%Analog_source provides highly oversampled signal from a pseudo-analog source 
%for further processing
%
%    [a] = analog_source(par_no,switch_reset,switch_graph) 
%    
%    provides 'par_no' highly oversampled samples from a pseudo-analog 
%    source, e.g. par_no = 1000.
%   
%    The parameter 'switch_reset' works as a start/reset switch. It must be set to 1 
%    to trigger the oversamping, and the cooresponding sampled data will be delivered 
%    by 'a'. When 'sw_restart' is set up tp 1 again, it indicates that the
%    oversampling will restart.
%
%    The parameter 'switch_graph' to indicate whether to plot certain period 
%    of sampled signal. Setting switch_graph = 1 to draw the figure or
%    switch_graph = 0 to turn it off.
%


end

