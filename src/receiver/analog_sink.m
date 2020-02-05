function [MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat)
if isempty(a_tilde) | isempty(u_hat) | isempty(c_hat) | isempty(b_hat)
   MSE = 0;
   BER_u = 0;
   BER_c = 0;
   BER_b = 0;
else
    if length(a) > length(a_tilde)
        len = length(a_tilde);
    else
        len = length(a);
    end
    % MSE
    MSE = 1/length(a(1:len)) .* sum(a(1:len) - a_tilde(1:len))^2;
    % BER
    if length(u) > length(u_hat)
        len = length(u_hat);
    else
        len = length(u);
    end
    BER_u = sum(sum(abs(u(1:len,:)-u_hat(1:len,:))))/(size(u(1:len,:),1)*size(u(1:len,:),2));
    if length(c) > length(c_hat)
        len = length(c_hat);
    else
        len = length(c);
    end
    BER_c = sum(sum(abs(c(1:len)-c_hat(1:len))))/len;
    if length(b) > length(b_hat)
        len = length(b_hat);
    else
        len = length(b);
    end
    BER_b = sum(abs(b(1:len)-b_hat(1:len)))/len;
end
end
