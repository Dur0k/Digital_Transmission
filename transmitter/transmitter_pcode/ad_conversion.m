function u = ad_conversion( a, par_w, par_q, switch_graph )

% declare variable
u = zeros(ceil(length(a)/par_w), par_q);

% determine quantization step size
Delta = 2/2^par_q;

% downsampling and quantization
a_dwn = a(1:par_w:end) + 1;
a_dwn(a_dwn==0) = Delta;
q = ceil((a_dwn-Delta)/Delta);

% dec2bin conversion
for jj = 1:length(q)
    aux = q(jj);
    ii = par_q;
    while aux>0
        u(jj,ii) = rem(aux,2);
        aux = floor(aux/2);
        ii = ii - 1;    
    end
end

% graphical output
if switch_graph
    stem((q+1)*Delta-1);
    figure;
    stem(q);
end

end

