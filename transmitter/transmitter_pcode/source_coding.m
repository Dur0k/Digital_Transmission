function [b, code_dic] = source_coding(u,par_scblklen,switch_off,switch_graph)
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
    global uu
    uu = [uu u];
    if par_scblklen>length(uu)
    	par_scblklen=length(u);
    end
   
    u = uu(1:par_scblklen,:);
    uu = uu(par_scblklen+1:end,:);
    %evalin('base','uu=uu;');
    % Get the amount of bits per row vector of u
    getBitLen = size(u);
    BitLen = getBitLen(2);


    % Generate all posible bit vector combinations based on BitLen of u
    % https://stackoverflow.com/questions/9767321/how-to-generate-all-possible-combinations-n-bit-strings
    z = dec2bin(0:2^BitLen-1) - '0';
    zLen = size(z);

    % Search u for occurences of bit vector combinations and store them in zocc
    zocc = zeros(zLen(1),1);
    uind = zeros(getBitLen(1),1);
    for i=1:zLen(1)
        % With find and ismember the matching positions of the bit vector are
        % returned as a vector
        tmp_occ = find(ismember(u,z(i, :),'rows'));
        % Based on the size of the vector the number of occurences are stored
        zocc(i) = size(tmp_occ,1);
        uind(tmp_occ) = i;
    end


    % Rewrite the number of occurences as a percentage to get the weight of
    % each bit vector
    weight = zocc./size(u,1);



    % https://sourceforge.net/p/octave/communications/ci/default/tree/inst/huffmandict.m
                % sym = ['a' 'b' 'c' 'd' 'e'];
                % weight = [0.1 0.15 0.15 0.4 0.2];

    % Sort the weight and return the index of weights in
    % ascending order
    [~,index]=sort(weight);
    index = flip(index);
    S = length(weight);

    % put the weight sorted in a matlab cell type
    tree_stage = {};
    tree_stage.weight_list = weight(index)';
    % assign the index to another cell array to lateron combine symbols
    for i = 1:S
        tree_stage.sym_list{i} = index(i);
    end


    %%%%
    cw_list = cell (1, S);
    tree_list = {};
    %%%

    I = 1;
    while (I < S)
        % Determine the current lenght of weight vector
        L = length(tree_stage.weight_list);
        % Sum up the 2 smallest weights
        nweight = tree_stage.weight_list(L-1) + tree_stage.weight_list(L);
        % Create a new symbol from symbols with smallest weights
        nsym = [tree_stage.sym_list{L-1}(1:end), tree_stage.sym_list{L}(1:end)];

        % Save the current stage of the tree
                    %	weight_list: [0.4000 0.2000 0.1500 0.1500 0.1000]
                    %	sym_list: {[4]  [5]  [3]  [2]  [1]}
        tree_list{I} = tree_stage;

        % check on which position to insert the new weight and symbol by
        % counting up until a place is found
        for i = 1:(L-2)
            if (tree_stage.weight_list(i) < nweight)
                break;
            end
        end
        % Insert the weight to the list and discard the two smallest values
                    %   weight_list: [0.4000 0.2500 0.2000 0.1500]
                    %   sym_list: {[4]}    {[2 1]}    {[5]}    {[3]}
        %if (size(tree_stage.weight_list(1:i-1),1) == 0)
        %    tree_stage.weight_list = [nweight tree_stage.weight_list(i:L-2)];
        %else
            
        %end
        tree_stage.weight_list = [tree_stage.weight_list(1:i-1) nweight tree_stage.weight_list(i:L-2)];
        tree_stage.sym_list = {tree_stage.sym_list{1:i-1}, nsym, tree_stage.sym_list{i:L-2}};

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
                    
        % FIXME!            
        clist = tree_stage.sym_list{L};
        for k = 1:length(clist)
            cw_list{1,clist(k)} = [cw_list{1,clist(k)} 0];
        end

        clist = tree_stage.sym_list{L-1};
        for k = 1:length(clist)
            cw_list{1,clist(k)} = [cw_list{1,clist(k)} 1];
        end
        I = I - 1;
    end
    
    
    % Encode u to get b with code_dic
    code_dic = {};
    for i = 1:S
        code_dic.sym_list{i} = z(i,:);
        code_dic.cw{i} = cw_list{i};
    end
    b=[];
    %uind = zeros(getBitLen(1),1);
    for i=1:length(u)
        for j=1:length(code_dic.sym_list)
            if (ismember(u(i,:),code_dic.sym_list{j},'rows'))
                tmp_code = code_dic.cw{j};
                b = [b tmp_code];
            end
        end
    end
    
    
        
    %    % With find and ismember the matching positions of the bit vector are
    %    % returned as a vector
    %    tmp_occ = find(ismember(u,z(i, :),'rows'));
    %    % Based on the size of the vector the number of occurences are stored
    %    zocc(i) = size(tmp_occ,1);
    %    uind(tmp_occ) = i;
    %end
    
end


