function y = demodulation( x, modtoggle, showflag )
if isempty(x)
   y = []; 
else
    G1 = inv([1 1 0 0;
              0 1 1 0;
              0 0 1 1;
              0 0 0 1]);
    G2 = inv([1 1;
              0 1]);

    if modtoggle
        s = round((rad2main(angle(x))-pi/16)/(pi/8));
        c = de2bi(s, 4, 'left-msb');
        %c = de2bi(round((rad2main(angle(x))-pi/16)/(pi/8)), 4, 'left-msb');
        w = mod(c*G1, 2)';
    else
        %disp(real(x));
        I = round((real(x)*sqrt(3^2+1)+3)/2);
        Q = round((imag(x)*sqrt(3^2+1)+3)/2);
        I(I>3) = 3;
        Q(Q>3) = 3;
        I(I<0) = 0;
        Q(Q<0) = 0;
        
        %c = [de2bi((real(x)*sqrt(3^2+1)+3)/2, 2, 'left-msb') de2bi((imag(x)*sqrt(3^2+1)+3)/2, 2, 'left-msb')];
        c = [de2bi(round(I), 'left-msb') de2bi(round(Q), 'left-msb')];
        w = [mod(c(:,1:end/2)*G2, 2) mod(c(:,end/2+1:end)*G2, 2)]';
    end
    y = w(:);

    end

    function retVal = rad2main( phi )

    retVal = phi - 2*pi * floor(phi/2/pi);
    end
end