function  [s] = tx_filter_s(d,par_tx_w,switch_graph)
% TX_FILTER reconstruct the analog signal by using the ideal low-pass filter 
% cooperating with the input symbols and zero inserting  
%
%   [ s ] = tx_filter(d,par_tx_w,switch_graph)
%
%   'par_tx_w' is the oversampling for the zero inserting, e.g., par_tx_w = 8.
%
%   Switchable graph of the output of the ideal low-pass filter with
%   On:  switch_graph = 1;
%   Off: switch_graph = 0;


% Upsampling von d um par_tx_w=8
oversampled_size = par_tx_w*length(d);
d_oversampled = zeros(oversampled_size,1);
cnt=1;

%Auffüllen der Stellen zwischen den Werten mit Nullen
for ii=1:length(d)
    d_oversampled(cnt,1) = d(ii);
    d_oversampled(cnt+1:cnt+par_tx_w-1,1) = 0;
    cnt = cnt + par_tx_w;
end

filter = rcosdesign(0.5,7,par_tx_w); % RRC-Filter mit Roll-off-Faktor 0.5 und einer Dauer von 6 Symbolen
filter = (1/sqrt(par_tx_w))*(filter/max(filter)); % Normierung

s = conv(d_oversampled, filter);    % Filterung

s = zeros(length(d)*par_tx_w,1);    % Erstellt einen leeren Spaltenvektor der Länge von d*par_tx_w(=8)
%                                         % >> Somit wird ein Oversampling des Signals möglich, weil für jedes
%                                         % Symbol nun die 8-fache Länge des Vektors ermöglicht wird.
% 
for ii=1:length(d)
	s(par_tx_w*ii-7) = d(ii);       % Speichere die Symbole aus d an jeder 8. Stelle des leeren Vektors s
end
%     % Alernativ: s(1:8:end)=d
x = [-3*par_tx_w:3*par_tx_w];   % Zeilenvektor der von -24 bis +24 alle Werte enthält 
%                                     % (jeweils das drei-fach von par_tx_w in negative und positive Richtung)
x = x';                         % Aus Zeile mach Spalte
%     
%     % Impulsantwort des Idealen Tiefpass-Filters
%     % >> Definition einer si-Funktion als Sendefilter, um das Matched-Filter-Prinzip mit dem Empfangsfilter zu erfüllen. 
%     % Der Filter ist ideal für eine Rechteck-Funktion im Frequenzbereich.
sinc = 1./(pi*x) .* sin(pi*x/par_tx_w);
sinc(3*par_tx_w+1) = 1/par_tx_w;            % Definiere die si-Funktion mit Hilfe von x im Bereich [-24,..., +24]
%     
%     % Normierung
%     % >> Damit der Sendefilter ideal ist, muss von einem NORMIERTEN TP-Filter ausgegangen werden.
norm = sqrt(max(sinc));     % Normierungsfaktor
sinc = sinc/norm;           % Normierung des Sendefilters
%     
s = conv(s, sinc);          % Faltung > Filterung vom Überabgetasteten (oversampled) s mit dem idealen Rechteck
%     
    if switch_graph == 1
        figure('Name','Filter','Numbertitle','off')
        suptitle('Signal nach dem Tiefpass-Filter');
        title('Title')
        subplot(2,1,1)
        stem(1:length(s),real(s));
        xlabel('t');
        ylabel('Realteil');
        subplot(2,1,2)
        stem(1:length(s),imag(s));
        xlabel('t');
        ylabel('Imaginärteil');
    end
    
    if switch_graph > 1 || switch_graph < 0
        'switch_graph must be 0 or 1!';
    end
    
end