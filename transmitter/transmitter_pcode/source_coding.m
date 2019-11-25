function [b, code_tree, len_idx] = source_coding(u,par_scblklen,switch_off,switch_graph)
%SOURCE_CODING excutes the huffman encoding for the input signal 
%    
%   [b, code_tree, len_idx] = source_coding(u,par_scblklen,switch_off,switch_graph)
%
%   source_coding encodes the input signal 'u' using Huffman coding if 
%
%   On:  switch_off = 0; indicates using the Huffman source coding  
%   Off: switch_off = 1; indicates no source coding
%   
%   If the Huffman coding is switched off, the input signal will be
%   delivered directly. If not, the input message 'u' will be firstly recovered
%   to the respective signal (symbols) before quantization and then encoded by 
%   huffman coding blcok by block w.r.t block size of 'par_scblklen', e.g. par_scblklen = 100.
%
%   The parameter 'switch_graph' is used to control the display of a histogram of huffman encoding over
%   one block:
%   On:  switch_graph = 1;
%   Off: switch_graph = 0;
%
%   'code_tree': the huffman encoding code tree for every block
%   'len_idx': record the block sizes of each block (either using the length 
%   index of coded block or using 'b' for source decoding )
if switch_off == 0
    nr_blocks = ceil(length(u)/par_scblklen);
    b=[];
    len_idx = [];
    code_tree = {};
    % Repeat huffman coding for all nr_blocks
    for nr = 1:nr_blocks
        % u_block with length par_scblklen or rest of u if remaining length
        % is smaller than par_scblklen
        if nr*par_scblklen+1 > length(u)
            u_block = u((nr-1)*par_scblklen+1:end,:);
        else
            u_block = u((nr-1)*par_scblklen+1:nr*par_scblklen,:);
        end
        
        % Get the amount of bits per row vector of u
        nr_bits = size(u_block,2);
        nr_combinations = 2^nr_bits;

        % Generate all posible bit vector combinations based on nrbits of u
        % https://stackoverflow.com/questions/9767321/how-to-generate-all-possible-combinations-n-bit-strings
        combinations = dec2bin(0:2^nr_bits-1) - '0';

        % Search u_block for occurences of bit vector combinations and store them in zocc
        occ = zeros(nr_combinations,1);
        %uind = zeros(length(u_block),1);
        for i=1:nr_combinations
            % With find and ismember the matching positions of the bit vector are
            % returned as a vector
            tmp_occ = find(ismember(u_block,combinations(i, :),'rows'));
            % Based on the size of the vector the number of occurences are stored
            % uind 
            occ(i) = size(tmp_occ,1);
            %uind(tmp_occ) = i;
        end

        % Rewrite the number of occurences as a percentage to get the weight of
        % each bit vector
        weight = occ./size(u_block,1);

        % Huffman code
        % https://sourceforge.net/p/octave/communications/ci/default/tree/inst/huffmandict.m
                    % sym = ['a' 'b' 'c' 'd' 'e'];
                    % weight = [0.1 0.15 0.15 0.4 0.2];

        % Sort the weight and return the index of weights in
        % ascending order
        [~,index]=sort(weight);
        index = flip(index);
        S = length(weight);

        % put the sorted weight in a matlab cell type
        tree_stage = {};
        tree_stage.weight_list = weight(index)';
        % assign each index value to a cell array to later on combine symbols
        for i = 1:S
            tree_stage.sym_list{i} = index(i);
        end

        
        cw_list = cell(1, S);
        tree_list = {};
        
        % Loop until only two combined symbols are left 
        I = 1;
        while (I < S)
            % Save the current stage of the tree
                        %	weight_list: [0.4000 0.2000 0.1500 0.1500 0.1000]
                        %	sym_list: {[4]  [5]  [3]  [2]  [1]}
            tree_list{I} = tree_stage;
            
            % Determine the current lenght of weight vector
            L = length(tree_stage.weight_list);
            % Sum up the 2 smallest weights
            nweight = tree_stage.weight_list(L-1) + tree_stage.weight_list(L);
            % Create a new symbol from symbols that just got summed up
            nsym = [tree_stage.sym_list{L-1}(1:end), tree_stage.sym_list{L}(1:end)];

            % check on which position to insert the new weight and symbol by
            % counting up until a place is found
            for p = 1:(L-2)
                if (tree_stage.weight_list(p) < nweight)
                    break;
                end;
            end
            % Insert the weight to the list and discard the two smallest values
                        %   weight_list: [0.4000 0.2500 0.2000 0.1500]
                        %   sym_list: {[4]}    {[2 1]}    {[5]}    {[3]}
            tree_stage.weight_list = [tree_stage.weight_list(1:p-1) nweight tree_stage.weight_list(p:L-2)];
            tree_stage.sym_list = {tree_stage.sym_list{1:p-1}, nsym, tree_stage.sym_list{p:L-2}};

            I = I + 1;
        end

        % Reverse the tree        
        I = I - 1;
        while (I > 0)
            % 
            tree_stage = tree_list{I};
            L = length(tree_stage.sym_list);
            % assign the smallest weight a 0 and the second smallest a 1
                        % Starting with:
                        %   weight_list: [0.6000 0.4000]
                        %   sym_list: {[5 3 2 1]  [4]}
                        % Results in:
                        %   cw_list: {[1]} {[1]} {[1]} {[0]} {[1]}
                        %%%
                        % Next loop:
                        %   weight_list: [0.4000 0.3500 0.2500]
                        %   sym_list: {[4]  [5 3]  [2 1]}
                        % Results in:
                        %   cw_list: {[10]} {[10]} {[11]} {[0]} {[11]}
                        %%%
                        % Next loop:
                        %   weight_list: [0.4000 0.2500 0.2000 0.1500]
                        %   sym_list: {[4]  [2 1]  [5]  [3]}
                        %   cw_list: {[10]} {[10]} {[110]} {[0]} {[111]}
                        %%%
                        % Last loop:
                        %   weight_list: [0.4000 0.2000 0.1500 0.1500 0.1000]
                        %   sym_list: {[4]  [5]  [3]  [2]  [1]}
                        %   cw_list: {[100]} {[101]} {[110]} {[0]} {[111]}

            % Assign 0s and 1s to symbols         
            symbols = tree_stage.sym_list{L};
            for k = 1:length(symbols)
                cw_list{1,symbols(k)} = [cw_list{1,symbols(k)} 0];
            end

            symbols = tree_stage.sym_list{L-1};
            for k = 1:length(symbols)
                cw_list{1,symbols(k)} = [cw_list{1,symbols(k)} 1];
            end
            I = I - 1;
        end
    
    
        % Encode u to get b with cw_list
        code_tree_block = {};
        for i = 1:S
            code_tree_block.sym_list{i} = combinations(i,:);
            code_tree_block.cw{i} = cw_list{i};
        end
        
        code_length = 0;
        for i=1:length(u_block)
            for j=1:length(code_tree_block.sym_list)
                if (ismember(u_block(i,:),code_tree_block.sym_list{j},'rows'))
                    tmp_code = code_tree_block.cw{j};
                    code_length = code_length + length(tmp_code);
                    b = [b tmp_code];
                end
            end
        end
    
        %
        len_idx = [len_idx, code_length];
        code_tree{nr} = code_tree_block; 
    end
    
    if switch_graph == 1
        figure;
        bar(cell2mat(tree_stage.sym_list),tree_stage.weight_list)
        ylabel('probability');
        xlabel('symbols');
        title('probability distribution');
    
elseif switch_off ==1
    b = u;
    b = reshape(b,size(u,1)*size(u,2),1);
    code_tree = [];
    len_idx = [];
end
end



