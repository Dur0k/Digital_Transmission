function y = modulation( x, modtoggle, showflag )
if isempty(x)
   y = []; 
else
   % set parameters
    n_bits = 4;
    G1 = [1 1 0 0;
          0 1 1 0;
          0 0 1 1;
          0 0 0 1];
    G2 = [1 1;
          0 1];

    % determine parameters
    n_words = length(x)/n_bits; ... number of words within input chunk

    % declare variables
    w = reshape(x, [n_bits n_words])';

    if modtoggle
        % PSK16 -- gray mapping, BIN to DEC conversion, angle mapping, offset/rescale
        c = mod(w*G1, 2);
    %     c = [mod(w(:,1:end/2)*G2, 2) mod(w(:,end/2+1:end)*G2, 2)];
    %     c([1:n_bits 16-n_bits+1:16],:) = mod(c([1:n_bits 16-n_bits+1:16],:)+[1 0 0 0], 2);
    %     c(n_bits+1:3*n_bits,:) = mod(c(n_bits+1:3*n_bits,:)+[0 0 1 1], 2);
        y = exp(2j*pi/16 * bi2de(c, 'left-msb') + 1j*pi/16);
    else
        % QAM16 -- cut data word in half, gray mapping, BIN to DEC conversion, cartesian mapping, offset/rescale
        c = [mod(w(:,1:end/2)*G2, 2) mod(w(:,end/2+1:end)*G2, 2)];
        y = ( (bi2de(c(:,1:end/2), 'left-msb')*2-3) + 1j*(bi2de(c(:,end/2+1:end), 'left-msb')*2-3) ) / sqrt(3^2+1);
    end

    % graphical output
    if showflag
        plot(real(y), imag(y), 'o');
    end
end
end
