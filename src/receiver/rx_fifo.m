function b_hat_buf=rx_fifo(b_hat,par_fifolen,par_sdblklen,switch_reset)

global rxbuffer
if switch_reset==1
    rxbuffer=[];
end
if isempty(rxbuffer)
    rxbuffer=ones(1,par_fifolen)*NaN; %rxbuffer der richtigen l�nge, gef�llt mit NaNs
end
idb=find(isnan(rxbuffer),1,'first'); %den index des ersten NaNs im vektor finden.
num_nan=sum(isnan(rxbuffer)); % anzahl nans im rxbuffer ermitteln (aufsummieren)
if (num_nan)>=length(b_hat) %pr�fen ob gen�gend platz ist im rxbuffer, um b einzuf�gen
    rxbuffer(idb:idb+length(b_hat)-1)=b_hat; %b eingeschoben auf platz des 1. ermittelten NaNs
end
n=par_fifolen-sum(isnan(rxbuffer)); %n=anzahl ziffern im rxbuffer
if n>=par_sdblklen %pr�fen ob gen�gend werte f�r ausgabe der l�nge par_sdblklen vorhanden sind
    b_hat_buf=rxbuffer(1:par_sdblklen)'; %erste werte des rxbuffers auslesen
    
    rxbuffer(1:par_sdblklen)=NaN; %ausgelesene werte mit Nans ersetzen
    rxbuffer=circshift(rxbuffer,par_fifolen-par_sdblklen); %schiebt die neu eingesetzten Nans vorne wieder rein
else 
    b_hat_buf=[];
end
end

