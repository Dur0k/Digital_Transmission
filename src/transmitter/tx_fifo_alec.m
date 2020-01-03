function y = tx_fifo( x, buffersize, chunksize, resetflag )

global bufferarray;

if isempty(bufferarray) || resetflag
    bufferarray = -ones(buffersize, 1);
end

idx = find(bufferarray==-1, 1, 'first');
bufferload = idx+length(x)-1;
bufferarray(idx:bufferload) = x;

if bufferload>=chunksize
    y = bufferarray(1:chunksize);
    bufferarray = [bufferarray(chunksize+1:buffersize); -ones(chunksize, 1)];
else
    y = [];
end

end