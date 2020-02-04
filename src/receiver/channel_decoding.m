function y = channel_decoding( x, H, disableflag )

if disableflag || isempty(x)
    % exception handling
    y = x;
else
%     % determine parameters
    k_prtyBits = size(H, 1); ... number of parity bits per word
    N_totBits = size(H, 2); ... number of total bits per word
    n_dataBits = N_totBits - k_prtyBits; ... number of data bits per word
    n_words = length(x)/N_totBits; ... number of words within input chunk
%         
%     % create generator matrix
%     G = [eye(n_dataBits); H(:,1:n_dataBits)]; ... is derived by parity check matrix
% 
%     % reshape input block
    c = reshape(x, [N_totBits n_words]); ... matrix of data words -- one word per column
% 
%     % create hamming code by performing matrix multiplication for each word
%     y = mod(G*w, 2);
%     y = y(:);

R = [0 0 1 0 0 0 0;
     0 0 0 0 1 0 0;
     0 0 0 0 0 1 0;
     0 0 0 0 0 0 1];

z = bi2de(mod(c'*H', 2));
e = zeros(size(c));
e(sub2ind(size(e), z(z>0), find(z>0))) = 1;
w = mod(c+e, 2);
y = mod(w'*R', 2)';
y = y(:);
end

end