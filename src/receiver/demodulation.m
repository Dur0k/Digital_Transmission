function y = demodulation( x, modtoggle, showflag )

G1 = inv([1 1 0 0;
          0 1 1 0;
          0 0 1 1;
          0 0 0 1]);
G2 = inv([1 1;
          0 1]);

if modtoggle
    c = de2bi(round((rad2main(angle(x))-pi/16)/(pi/8)), 4, 'left-msb');
    w = mod(c*G1, 2)';
else
    c = [de2bi((real(x)*sqrt(3^2+1)+3)/2, 2, 'left-msb') de2bi((imag(x)*sqrt(3^2+1)+3)/2, 2, 'left-msb')];
    w = [mod(c(:,1:end/2)*G2, 2) mod(c(:,end/2+1:end)*G2, 2)]';
end
y = w(:);

end

function retVal = rad2main( phi )

retVal = phi - 2*pi * floor(phi/2/pi);

end