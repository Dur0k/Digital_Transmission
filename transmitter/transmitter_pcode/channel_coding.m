function channel_coding
%CHANNEL_CODING excutes the switchable hamming encoding function
%
%   [c] = channel_coding(b,par_H,switch_off)
%
%   The Hamming encoding here uses the common [7,4,3] Hamming code with the
%   given parity-check matrix to encode the input binary signal b.
%
%   the encoding principle is simply given by b*G = c and the basic matrix
%   transformation between parity-check matrix and generator matrix based on
%   the principle of GH^T = 0.
%
%   Parameter 'par_H' indicates the parity-check matrix in standard (or 
%   systematic) form, which needs to be provided. The corresponding generator 
%   matrix will be automatically generated in this block. 
%
%   Parameter 'switch_off' indicates the command of switch off the hamming
%   coding functionality or not with switch_off = 1 telling the block to
%   turn it on.
%
%   


    end

    
% end
       
% end

