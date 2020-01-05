function [MSE, BER_u, BER_c, BER_b] = analog_sink(a, a_tilde, u, u_hat, c, c_hat, b, b_hat)
    len = length(a_tilde);
    % MSE
    MSE = 1/length(a(1:len)) .* sum(a(1:len) - a_tilde(1:len))^2;
    % BER
    len = length(u_hat);
    BER_u = sum(sum(abs(u(1:len,:)-u_hat(1:len,:))))/(size(u(1:len,:),1)*size(u(1:len,:),2));
    len = length(c_hat);
    BER_c = sum(sum(abs(c(1:len)-c_hat(1:len))))/len;
    len = length(b_hat);
    BER_b = sum(abs(b(1:len)-b_hat(1:len)))/len;
end
