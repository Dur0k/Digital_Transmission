function [a_tilde] = da_conversion(u_hat, par_w, par_q, switch_graph)
    % binary to decimal conversion by matrix multiplication
    % u_bin contains values between 0 and 2^par_w
    u_bin = u_hat * flip((2.^[0:(size(u_hat,2) - 1)]'));
    % Normalize to values between -1 and 1
    % https://stats.stackexchange.com/questions/178626/how-to-normalize-data-between-1-and-1
    u_dec = 2 * ((u_bin+1)/2^(par_q)) - 1;
    % Interpolation
    a_tilde = interp(u_dec,par_w);
    
    if switch_graph
        figure;
        stem(a_tilde)
        title('da conversion');
    end
end