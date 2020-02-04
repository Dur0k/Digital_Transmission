function u_hat = source_decoding(b_hat_buf, code_tree, len_idx, switch_off)
if isempty(b_hat_buf)
   u_hat = []; 
else
    tmp_out = [];
    % divide input stream in blocks of length len_idx
    for blocks = 1:length(len_idx)
        tmp_block = b_hat_buf(sum(len_idx(1:blocks-1))+1:sum(len_idx(1:blocks)));
        tmp_sym = code_tree{blocks}.sym_list;
        tmp_cw = code_tree{blocks}.cw;

        % find code words in stream and remove found cw, add corresponding bit
        % vector to output 
        % do until block is empty
        while (~isempty(tmp_block))
            for i = 1:length(tmp_cw)
                if (ismember(tmp_block(1:length(tmp_cw{i}))',tmp_cw{i},'rows'))
                    tmp_block = tmp_block(length(tmp_cw{i})+1:end);
                    tmp_out = [tmp_out; tmp_sym{i}];
                    break;

                error('source_decoding: bit combination not found');
                end
            end
        end
    end
    u_hat = tmp_out;
end
end
