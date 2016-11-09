init;

H=1000;         %pr�bkowanie przestrzeni rozwi�za�
M=30;           %liczba mr�wek
n=3;            %liczba parametr�w
iter=10;        %max liczba iteracji
alfa=2;         %wsp�czynnik wzmocnienia feromon�w
Q=0.2;          %wsp�czynnik skaluj�cy feromon�w
ro=0.05;        %wsp�czynnik parowania feromon�w

% inicjalizacja tablic
feromony = zeros(H,n);
trasa = zeros(iter, M, n);
macierzBledow = zeros(iter, n);
wBledowIter = zeros(iter); %<�K> najmniejszy b��d uzyskany w danej iteracji
najWIter = zeros(iter); %<�K> �ledzi zmiany najlepszego rozwi�zania (do wykresu)
najlepszaMrowka = [0, 0]; %<�K> indeks najlepszej mr�wki

%Za�o�one warto�ci graniczne dla parametrow X1,X2,X3
X1min=-300e-5;
X1max=-100e-5;
X2min=200e-5;
X2max=400e-5;
X3min=-300e-5;
X3max=-100e-5;

%Tworzenie macierzy mo�liwych kandydat�w do rozwi�zania dla ka�dego z
%parametr�w X1=xxx(1),X2=xxx(2),X3=xxx(3)

% <�K>
% podmieni�em sta�e elementy tej p�tli, bo niepotrzebnie
% by�y liczone przy ka�dej iteracji
% </�K>

X1(1) = X1min;
X1(H) = X1max;
krokX1 = (X1max - X1min)/(H-1);
X2(1) = X2min;
X2(H) = X2max;
krokX2 = (X2max - X2min)/(H-1);
X3(1) = X3min;
X3(H) = X3max;
krokX3 = (X3max - X3min)/(H-1);

for j=2:H-1    
    X1(j)=X1(j-1) + krokX1;
    X2(j)=X2(j-1) + krokX2;
    X3(j)=X3(j-1) + krokX3;
end;

% <�K>
% lub nawet:
% for j=2:H-1
%     X1(j) = j*krokX1;
%     X2(j) = j*krokX1;
%     X3(j) = j*krokX1;
% end
% </�K>

% tablica z mo�liwymi rozwi�zaniami
% parametry=[X1',X2',X3'];

%  %losowanie randomowej wartosci dla pierwszych parametr�w X1,X2,X3 z zakresu
% %X1min-X1max
% kk1=rand; 
% k1=(((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) , 0.00000001);
% kk2=rand; 
% k2=(((400e-5 - 200e-5) .* kk2) + 200e-5) - mod((((400e-5 - 200e-5) .* kk2) + 200e-5) , 0.00000001);  
% kk3=rand; 
% k3=(((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) , 0.00000001);  
% K123=[k1 k2 k3]

% <�K>
% Moja propozycja :)
% </�K>
X1_0 = X1(randi([1, H],1,1));
X2_0 = X2(randi([1, H],1,1));
X3_0 = X3(randi([1, H],1,1));
X0 = [X1_0, X2_0, X3_0];

blad_0 = funkcjabledu(X0); % b��d na podstawie losowych warto�ci X
feromon_0 = 1/blad_0; % warto�� pocz�tkowa feromon�w

minBlad = blad_0; %<�K> najmniejszy uzyskany b��d we wszystkich iteracjach;
                  %inicjalizuje b��dem pocz�tkowym</�K> 

%Tworzenie macierzy feromon�w na podstawie uzyskanego wy�ej wska�nika, dla
%ka�dego rozwi�zania macierzy taka sama warto��

% for j=1:n
%     for i=1:H
%         feromony(i,j)=1/blad;
%     end
% end

% <�K>
% ma�y trick na przysz�o�� :)
feromony(:) = blad_0;

 %p�tla algorytmu
 for l=1:iter
     %<�K> ; je�eli irytuje
     info = ['Iteracja ', num2str(l)];
     disp(info)
     %tworzenie macierzy prawdopodobie�stw na podstawie wzoru
    for g=1:n
        alfa_feromony=feromony.^alfa;
        s=sum(alfa_feromony(:,g));
        prawdop=(1/s).*alfa_feromony; %feromony
    end
    for i=1:M
        %<�K> ; je�eli irytuje
        info = ['Mrowka ', num2str(i)];
        disp(info)
        %p�tla wyboru w�z�a
        for j=1:n
            r=rand;
            s=0;
            for k=1:H %numer wezla
                s=s+prawdop(k,j);%uzycie kola ruletki
                if r<=s
%                   <�K>
%                   zapisa�em tras�: 
%                   w l-tej iteracji, i-ta mr�wka, w j-tym w�le 
%                   wybra�a kandydata nr k
%                   </�K>
                    trasa(l,i,j) = k;
                    break
                end
            end    
        end
        %<�K>
        %nie zmieni�em nic w zasadzie dzia�anie, dostosowa�em tylko do
        %w�asnych oznacze�
        %</�K>
        %wyznaczanie wskaznika jako�ci dla trasy i-tej mr�wki
        macierzBledow(l,i)=funkcjabledu([X1(trasa(l,i,1)), X2(trasa(l,i,2)), X3(trasa(l,i,3))]); %zapisanie wskaznika w macierzy o wymiarach iter-kolumn M-wierszy
        %<�K>
        %Sprawdzam przy ka�dym b��dzie czy jest mniejszy od najmniejszego
        %uzyskanego, na taj podstawie znajduj� najmniejszy b��d i najlepsz�
        %mr�wk�
        %</�K>
        if (macierzBledow(l,i) < minBlad)
            minBlad = macierzBledow(l,i);
            najlepszaMrowka = [l ,i];
        end
        %aktualizacja lokalna feromon�w
        feromony(trasa(l,i,1),1) = feromony(trasa(l,i,1),1) + (Q/macierzBledow(l,i));
        feromony(trasa(l,i,2),2) = feromony(trasa(l,i,2),2) + (Q/macierzBledow(l,i));
        feromony(trasa(l,i,3),3) = feromony(trasa(l,i,3),3) + (Q/macierzBledow(l,i));
%         trasa_w_wezlach(1,:)=ktory_wezel(i,:);
%         pierwszy_el=trasa_w_wezlach(1);
%         drugi_el=trasa_w_wezlach(2);
%         trzeci_el=trasa_w_wezlach(3);
% 
%         feromony(pierwszy_el,1)=feromony(pierwszy_el,1)+(Q/(macierzBledow(i,l)));
%         feromony(drugi_el,2)=feromony(drugi_el,2)+(Q/(macierzBledow(i,l)));
%         feromony(trzeci_el,3)=feromony(trzeci_el,3)+(Q/(macierzBledow(i,l)));

        %rysowanie wykres�w warto�ci wskaznika dla ka�dej z
        %mr�wki w konkretnej iteracji
%       <�K> chwilowo wy��czam
%         figure(l)
%         plot(macierzBledow(:,l)),xlabel('mr�wka (M)'),title('wskaznik (JE)'),grid
    end
    %szukanie najlepszego wska�nika danej iteracji
    wBledowIter(l) = min(macierzBledow(l,:)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
    najWIter(l) = minBlad; %<�K> do wykresu
    %aktualizacja globalna feromon�w
    
    %<�K> nie jestem pewien, ale chyba trzeba najlepszym znalezionym
    for jj=1:n
        for ii=1:H
            feromony(ii,jj)=(1-ro).*feromony(ii,jj)+(1/minBlad);
        end
    end
    minBlad
    najlepszaMrowka
    parametry = [X1(trasa(najlepszaMrowka(1,1), najlepszaMrowka(1,2), 1)),...
                 X2(trasa(najlepszaMrowka(1,1), najlepszaMrowka(1,2), 2)),... 
                 X3(trasa(najlepszaMrowka(1,1), najlepszaMrowka(1,2), 3))]
    
    
    %szukanie najlepszego wska�nika i trasy ze wszystkich
    %iteracji
%     [min_wskaznik_iter(l,1),gdzie(l,1)]=min(macierzBledow(:,l)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
%     [E,B]=min(min_wskaznik_iter) %A-warto�� najmniejszego wskaznika, B-w kt�rej iteracji wyst�pi� najmniejszy wskaznik
%     [C,D]=min(macierzBledow(:,B)); %C-warto�� najmniejszego wskaznika, D-numer najlepszej mr�wki (tzn. takiej kt�ra uzyska�a najmniejszy wskaznik)
%     najlepsza_iteracja=B;
%     najlepsza_mrowka=D;
%     najlepszy_wskaznik=E;
%     najlepsza_trasa_ever(1,:)=trasa(D,:,B)
 end
figure(1)
plot(wBledowIter);
figure(2)
plot(najWIter);


