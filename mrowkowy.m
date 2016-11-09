clear;
clc;

H=1000; %zakres zmian warto�ci parametr�w
M=30; %liczba mr�wek
n=3; %liczba parametr�w
iter=10; %max liczba iteracji
alfa=2;
Q=0.2;%wsp�czynnik skaluj�cy ilo�� zostawianych feromon�w
ro=0.05 %warto�� szybko�ci parowania �ladu feromonowego

%Za�o�one warto�ci graniczne dla parametrow X1,X2,X3
X1min=-300e-5;
X1max=-100e-5;
X2min=200e-5;
X2max=400e-5;
X3min=-300e-5;
X3max=-100e-5;

%Tworzenie macierzy mo�liwych kandydat�w do rozwi�zania dla ka�dego z
%parametr�w X1=xxx(1),X2=xxx(2),X3=xxx(3)
X1(1)=X1min;
X1(H)=X1max;
X2(1)=X2min;
X2(H)=X2max;
X3(1)=X3min;
X3(H)=X3max;

for j=2:H-1
    
X1(j)=X1(j-1) + (X1max - X1min)/(H-1);
X2(j)=X2(j-1) + (X2max - X2min)/(H-1);
X3(j)=X3(j-1) + (X3max - X3min)/(H-1);
end;

parametry=[X1',X2',X3'];

 %losowanie randomowej wartosci dla pierwszych parametr�w X1,X2,X3 z zakresu
%X1min-X1max
kk1=rand; 
k1=(((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) , 0.00000001);kk2=rand; 
k2=(((400e-5 - 200e-5) .* kk2) + 200e-5) - mod((((400e-5 - 200e-5) .* kk2) + 200e-5) , 0.00000001);  
kk3=rand; 
k3=(((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) , 0.00000001);  
K123=[k1 k2 k3]

[blad_koncowy]=funkcjabledu(K123); %randomowy wska�nik jako�ci

%Tworzenie macierzy feromon�w na podstawie uzyskanego wy�ej wska�nika, dla
%ka�dego rozwi�zania macierzy taka sama warto��
for j=1:n
    for i=1:H
        feromony(i,j)=1/blad_koncowy;
 
    end
end
    
    
     %p�tla algorytmu
     for l=1:iter
         %tworzenie macierzy prawdopodobie�stw na podstawie wzoru
                for g=1:n
                alfa_feromony=feromony.^alfa;
                s=sum(alfa_feromony(:,g));
                prawdop=(1/s).*alfa_feromony; %feromony
                end
    for i=1:M
         %p�tla wyboru w�z�a
         for j=1:n
            r=rand;
            s=0;
    
            for k=1:H %numer wezla
                s=s+prawdop(k,j);%uzycie kola ruletki
                if r<=s
                    trasa(i,j,l)=parametry(k,j); %zapisywana warto�� wybranego w�z�a w macierzy trasy
                    ktory_wezel(i,j)=k;
                    break
                end
            end    
       end
     
         %wyznaczanie wskaznika jako�ci dla trasy i-tej mr�wki

            trasa_mrowki(1,:)=trasa(i,:,l) %trasa i-tej mr�wki(i-ty wiersz macierzy trasa)
            
           wskaznik(i,l)=funkcjabledu(trasa_mrowki); %zapisanie wskaznika w macierzy o wymiarach iter-kolumn M-wierszy
           
            
            %aktualizacja lokalna feromon�w
            trasa_w_wezlach(1,:)=ktory_wezel(i,:);
            pierwszy_el=trasa_w_wezlach(1);
            drugi_el=trasa_w_wezlach(2);
            trzeci_el=trasa_w_wezlach(3);
            
                      feromony(pierwszy_el,1)=feromony(pierwszy_el,1)+(Q/(wskaznik(i,l)));
                      feromony(drugi_el,2)=feromony(drugi_el,2)+(Q/(wskaznik(i,l)));
                      feromony(trzeci_el,3)=feromony(trzeci_el,3)+(Q/(wskaznik(i,l)));
               

                      %rysowanie wykres�w warto�ci wskaznika dla ka�dej z
                      %mr�wki w konkretnej iteracji
                      
                      figure(l)
                      plot(wskaznik(:,l)),xlabel('mr�wka (M)'),title('wskaznik (JE)'),grid
                      
                      
                      
    end
    %szukanie najlepszego wska�nika danej iteracji
                      A=min(wskaznik(:,l)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
                      
%     %aktualizacja globalna feromon�w
    for jj=1:n
        for ii=1:H
            feromony(ii,jj)=(1-ro).*feromony(ii,jj)+(1/A);
        end
    end
                      
                      %szukanie najlepszego wska�nika i trasy ze wszystkich
                      %iteracji
                      [min_wskaznik_iter(l,1),gdzie(l,1)]=min(wskaznik(:,l)); %minimalne wskazniki dla kazdej z iteracji oraz gdzie- ktora mrowka 
                      [E,B]=min(min_wskaznik_iter) %A-warto�� najmniejszego wskaznika, B-w kt�rej iteracji wyst�pi� najmniejszy wskaznik
                      [C,D]=min(wskaznik(:,B)); %C-warto�� najmniejszego wskaznika, D-numer najlepszej mr�wki (tzn. takiej kt�ra uzyska�a najmniejszy wskaznik)
                      najlepsza_iteracja=B;
                      najlepsza_mrowka=D;
                      najlepszy_wskaznik=E;
                      najlepsza_trasa_ever(1,:)=trasa(D,:,B)
                      

           
    
     end


