function u_hat = source_decoding(b_hat_buf, code_tree, len_idx, switch_off)

for blocks = 1:1%length(len_idx)
    tmp_block = b_hat_buf(sum(len_idx(1:blocks-1))+1:sum(len_idx(1:blocks)));
    tmp_code_tree = code_tree{blocks};
    
    
    
end



end
