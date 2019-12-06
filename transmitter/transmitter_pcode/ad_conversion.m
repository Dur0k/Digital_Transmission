function y = ad_conversion( x, L_dwn, n_bits, showflag )

% determine quantization step size
Delta = 2/2^n_bits;

% declare variable
y = zeros(ceil(length(x)/L_dwn), n_bits);

% downsampling and quantization
a_dwn = x(1:L_dwn:end) + 1;
a_dwn(a_dwn==0) = Delta;
q = ceil((a_dwn-Delta)/Delta);

% dec2bin conversion
for jj = 1:length(q)
    aux = q(jj);
    ii = n_bits;
    while aux>0
        y(jj,ii) = rem(aux,2);
        aux = floor(aux/2);
        ii = ii - 1;    
    end
end

% graphical output
if showflag
    stem((q+1)*Delta-1);
end

end

