function y = channel_coding( x, H, disableflag )

if disableflag || isempty(x)
    % exception handling
    y = x;
else
    % determine parameters
    k_prtyBits = size(H, 1); ... number of parity bits per word
    N_totBits = size(H, 2); ... number of total bits per word
    n_dataBits = N_totBits - k_prtyBits; ... number of data bits per word
    n_words = length(x)/n_dataBits; ... number of words within input chunk
        
    % create generator matrix
    G = [eye(n_dataBits); H(:,1:n_dataBits)]; ... is derived by parity check matrix
    
    % declare variable
    y = zeros(N_totBits, n_words);
    
    % reshape input block
    w = reshape(x, [n_dataBits n_words]); ... matrix of data words -- one word per column
    
    % create hamming code by performing matrix multiplication for each word
    for ii=1:n_words
         y(:,ii) = mod(G*w(:,ii), 2);
    end
    y = y(:);
end

end