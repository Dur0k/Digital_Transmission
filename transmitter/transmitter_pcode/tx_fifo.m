function [b_buf]=tx_fifo(b,par_fifolen,par_ccblklen,switch_reset)
global buffer;
if switch_reset==1
    buffer=[];
end
if isempty(buffer)
    buffer=ones(1,par_fifolen)*NaN; %buffer der richtigen l�nge, gef�llt mit NaNs
end
buffer_inv=flip(buffer); %buffer invertieren
idb=find(isnan(buffer_inv),1,'first'); %den index des ersten NaNs im vektor finden. entspricht hier dem letzten, weil invertiert
num_nan=sum(isnan(buffer_inv)); % anzahl nans im buffer ermitteln
if (num_nan)>=length(b) %pr�fen ob gen�gend platz ist im buffer, um b einzuf�gen
    buffer_inv(idb:idb+length(b)-1)=b; %b eingeschoben auf platz 1-8 mit erstem wert ganz hinten
    buffer=flip(buffer_inv); %buffer mit eingeschoebenem b wieder zur�ck invertieren
end

n=par_fifolen-sum(isnan(buffer)); %n=anzahl ziffern im buffer
if n>=par_ccblklen % anzahl integers im buffer summieren (ausgabe=ans=anzahl stellen, die eine ziffer enthalten statt Nan)
    b_buf=buffer_inv(1:par_ccblklen)'; %erste werte des invertierten buffers auslesen (entsprechen den letzten des buffers)
    %[b_buf]=b_buf_inv'; %ausgelesene werte in die richtige reihenfolge bringen
    buffer_inv(1:par_ccblklen)=NaN; %ausgelesene werte mit Nans ersetzen
    buffer=flip(buffer_inv);
    buffer=circshift(buffer,par_ccblklen); %schiebt die neu eingesetzten Nans vorne wieder rein
else 
    [b_buf]=[];
end
end