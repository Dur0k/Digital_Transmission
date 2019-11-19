function tx_fifo
%TX_FIFO is used to buffering the source coded bits to coordinate the
%correct block length for the codewords.
%
%   [b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset)
%   
%   The 'switch_reset' works coordinately with the analog_source 
%   On:  switch_off = 0; indicates the buffer to continue working
%   Off: switch_off = 1; indicates the buffer will be reset
%   
%   The 'par_fifolen' is the capacity of the buffer
%   The 'par_ccblklen' determines the size of output for channel coding,
%   which should be a multiple of 16 bits
%   i.e. the length of each 'b_buf'


end