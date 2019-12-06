function y = channel_coding( x, H, disableflag )

if disableflag || isempty(x)
    % exception handling
    y = x;
else
    % determine parameters
    k_prty = size(H, 1);
    N_tot = size(H, 2);
    n_data = N_tot - k_prty;
    n_words = length(x)/n_data;
        
    % create generator matrix
    G = [eye(n_data); H(:,1:n_data)];
    
    % declare variable
    y = zeros(N_tot, n_words);
    
    % reshape input block
    x_shpd = reshape(x, [n_data n_words]);
    
    % create hamming code by performing matrix multiplication for each word
    for ii=1:n_words
         y(:,ii) = mod(G*x_shpd(:,ii), 2);
    end
    y = y(:);
end

end