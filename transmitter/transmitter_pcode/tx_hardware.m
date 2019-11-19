function tx_hardware 
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


end