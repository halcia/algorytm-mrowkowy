init;

H=1000;         %próbkowanie przestrzeni rozwi¹zañ
M=30;           %liczba mrówek
n=3;            %liczba parametrów
iter=10;        %max liczba iteracji
alfa=2;         %wspó³czynnik wzmocnienia feromonów
Q=0.2;          %wspó³czynnik skaluj¹cy feromonów
ro=0.05;        %wspó³czynnik parowania feromonów

% inicjalizacja tablic
feromony = zeros(H,n);
trasa = zeros(iter, M, n);
macierzBledow = zeros(iter, n);
wBledowIter = zeros(iter); %<£K> najmniejszy b³¹d uzyskany w danej iteracji
najWIter = zeros(iter); %<£K> œledzi zmiany najlepszego rozwi¹zania (do wykresu)
najlepszaMrowka = [0, 0]; %<£K> indeks najlepszej mrówki

%Za³o¿one wartoœci graniczne dla parametrow X1,X2,X3
X1min=-300e-5;
X1max=-100e-5;
X2min=200e-5;
X2max=400e-5;
X3min=-300e-5;
X3max=-100e-5;

%Tworzenie macierzy mo¿liwych kandydatów do rozwi±zania dla ka¿dego z
%parametrów X1=xxx(1),X2=xxx(2),X3=xxx(3)

% <£K>
% podmieni³em sta³e elementy tej pêtli, bo niepotrzebnie
% by³y liczone przy ka¿dej iteracji
% </£K>

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

% <£K>
% lub nawet:
% for j=2:H-1
%     X1(j) = j*krokX1;
%     X2(j) = j*krokX1;
%     X3(j) = j*krokX1;
% end
% </£K>

% tablica z mo¿liwymi rozwi¹zaniami
% parametry=[X1',X2',X3'];

%  %losowanie randomowej wartosci dla pierwszych parametrów X1,X2,X3 z zakresu
% %X1min-X1max
% kk1=rand; 
% k1=(((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) , 0.00000001);
% kk2=rand; 
% k2=(((400e-5 - 200e-5) .* kk2) + 200e-5) - mod((((400e-5 - 200e-5) .* kk2) + 200e-5) , 0.00000001);  
% kk3=rand; 
% k3=(((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) , 0.00000001);  
% K123=[k1 k2 k3]

% <£K>
% Moja propozycja :)
% </£K>
X1_0 = X1(randi([1, H],1,1));
X2_0 = X2(randi([1, H],1,1));
X3_0 = X3(randi([1, H],1,1));
X0 = [X1_0, X2_0, X3_0];

blad_0 = funkcjabledu(X0); % b³¹d na podstawie losowych wartoœci X
feromon_0 = 1/blad_0; % wartoœæ pocz¹tkowa feromonów

minBlad = blad_0; %<£K> najmniejszy uzyskany b³¹d we wszystkich iteracjach;
                  %inicjalizuje b³êdem pocz¹tkowym</£K> 

%Tworzenie macierzy feromonów na podstawie uzyskanego wy¿ej wska¼nika, dla
%ka¿dego rozwi±zania macierzy taka sama warto¶æ

% for j=1:n
%     for i=1:H
%         feromony(i,j)=1/blad;
%     end
% end

% <£K>
% ma³y trick na przysz³oœæ :)
feromony(:) = blad_0;

 %pêtla algorytmu
 for l=1:iter
     %<£K> ; je¿eli irytuje
     info = ['Iteracja ', num2str(l)];
     disp(info)
     %tworzenie macierzy prawdopodobieñstw na podstawie wzoru
    for g=1:n
        alfa_feromony=feromony.^alfa;
        s=sum(alfa_feromony(:,g));
        prawdop=(1/s).*alfa_feromony; %feromony
    end
    for i=1:M
        %<£K> ; je¿eli irytuje
        info = ['Mrowka ', num2str(i)];
        disp(info)
        %pêtla wyboru wêz³a
        for j=1:n
            r=rand;
            s=0;
            for k=1:H %numer wezla
                s=s+prawdop(k,j);%uzycie kola ruletki
                if r<=s
%                   <£K>
%                   zapisa³em trasê: 
%                   w l-tej iteracji, i-ta mrówka, w j-tym wêŸle 
%                   wybra³a kandydata nr k
%                   </£K>
                    trasa(l,i,j) = k;
                    break
                end
            end    
        end
        %<£K>
        %nie zmieni³em nic w zasadzie dzia³anie, dostosowa³em tylko do
        %w³asnych oznaczeñ
        %</£K>
        %wyznaczanie wskaznika jako¶ci dla trasy i-tej mrówki
        macierzBledow(l,i)=funkcjabledu([X1(trasa(l,i,1)), X2(trasa(l,i,2)), X3(trasa(l,i,3))]); %zapisanie wskaznika w macierzy o wymiarach iter-kolumn M-wierszy
        %<£K>
        %Sprawdzam przy ka¿dym b³êdzie czy jest mniejszy od najmniejszego
        %uzyskanego, na taj podstawie znajdujê najmniejszy b³¹d i najlepsz¹
        %mrówkê
        %</£K>
        if (macierzBledow(l,i) < minBlad)
            minBlad = macierzBledow(l,i);
            najlepszaMrowka = [l ,i];
        end
        %aktualizacja lokalna feromonów
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

        %rysowanie wykresów warto¶ci wskaznika dla ka¿dej z
        %mrówki w konkretnej iteracji
%       <£K> chwilowo wy³¹czam
%         figure(l)
%         plot(macierzBledow(:,l)),xlabel('mrówka (M)'),title('wskaznik (JE)'),grid
    end
    %szukanie najlepszego wska¼nika danej iteracji
    wBledowIter(l) = min(macierzBledow(l,:)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
    najWIter(l) = minBlad; %<£K> do wykresu
    %aktualizacja globalna feromonów
    
    %<£K> nie jestem pewien, ale chyba trzeba najlepszym znalezionym
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
    
    
    %szukanie najlepszego wska¼nika i trasy ze wszystkich
    %iteracji
%     [min_wskaznik_iter(l,1),gdzie(l,1)]=min(macierzBledow(:,l)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
%     [E,B]=min(min_wskaznik_iter) %A-warto¶æ najmniejszego wskaznika, B-w której iteracji wyst±pi³ najmniejszy wskaznik
%     [C,D]=min(macierzBledow(:,B)); %C-warto¶æ najmniejszego wskaznika, D-numer najlepszej mrówki (tzn. takiej która uzyska³a najmniejszy wskaznik)
%     najlepsza_iteracja=B;
%     najlepsza_mrowka=D;
%     najlepszy_wskaznik=E;
%     najlepsza_trasa_ever(1,:)=trasa(D,:,B)
 end
figure(1)
plot(wBledowIter);
figure(2)
plot(najWIter);


