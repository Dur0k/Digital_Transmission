function y = modulation( x, modtoggle, showflag )

% set parameters
n_bits = 4;
G1 = [0 1;
      1 0];
G2 = [1 0;
      1 1];
M = [2^1 2^0];

% determine parameters
n_words = length(x)/n_bits;

% declare variable
c = zeros(n_bits, n_words);
I = zeros(n_words, 1);
Q = zeros(n_words, 1);

% reshape input block
w = reshape(x, [n_bits n_words]);

if modtoggle
    % time-devision demux -- split bit stream in half (process each crumb of 2 bits seperately)
    for kk=1:n_words
        % rearrange order of 2 bit crumbs and gray mapping
        c(1:2,kk) = mod(G2*G1*w(1:2,kk), 2); ... 1st crumb of 2 bits
        c(3:4,kk) = mod(mod(sum(w(1:2,kk)), 2)+G2*w(3:4,kk), 2); ... 2nd crumb of 2 bits
        % bin2dec conversion
        I(kk) = M*c(1:2,kk);
        Q(kk) = M*c(3:4,kk);
    end
    % angle mapping
    y = exp( 1j*(I*pi/2 + Q*pi/8 + pi/16 + pi) );
else
    % time-devision demux -- split bit stream in half (process each crumb of 2 bits seperately)
    for kk=1:n_words
        % rearrange order of 2 bit crumbs and gray mapping
        c(1:2,kk) = mod(G2*w(1:2,kk), 2); ... 1st crumb of 2 bits
        c(3:4,kk) = mod(G2*w(3:4,kk), 2); ... 2nd crumb of 2 bits
        % bin2dec conversion
        I(kk) = M*c(1:2,kk);
        Q(kk) = M*c(3:4,kk);
    end
    % cartesian mapping
    y = ( (I*2-3) + 1j*(Q*2-3) ) / sqrt(3^2+1);
end

% graphical output
if showflag
    plot(real(y), imag(y), 'o');
end

end