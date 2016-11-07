clear;
clc;

H=30; %zakres zmian warto¶ci parametrów
M=15; %liczba mrówek
n=3; %liczba parametrów
iter=3; %max liczba iteracji
alfa=1;
Q=0.2;%wspó³czynnik skaluj±cy ilo¶æ zostawianych feromonów
ro=0.05 %warto¶æ szybko¶ci parowania ¶ladu feromonowego

%Za³o¿one warto¶ci graniczne dla parametrow X1,X2,X3
X1min=-300e-5;
X1max=-100e-5;
X2min=200e-5;
X2max=400e-5;
X3min=-300e-5;
X3max=-100e-5;

%Tworzenie macierzy mo¿liwych kandydatów do rozwi±zania dla ka¿dego z
%parametrów X1=xxx(1),X2=xxx(2),X3=xxx(3)
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

 %losowanie randomowej wartosci dla pierwszych parametrów X1,X2,X3 z zakresu
%X1min-X1max
kk1=rand; 
k1=(((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk1) + (-300e-5)) , 0.00000001);kk2=rand; 
k2=(((400e-5 - 200e-5) .* kk2) + 200e-5) - mod((((400e-5 - 200e-5) .* kk2) + 200e-5) , 0.00000001);  
kk3=rand; 
k3=(((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* kk3) + (-300e-5)) , 0.00000001);  
K123=[k1 k2 k3]

[blad_koncowy]=funkcjabledu(K123) %randomowy wska¼nik jako¶ci

%Tworzenie macierzy feromonów na podstawie uzyskanego wy¿ej wska¼nika, dla
%ka¿dego rozwi±zania macierzy taka sama warto¶æ
for j=1:n
    for i=1:H
        feromony(i,j)=1/blad_koncowy;
 
    end
end



    
    
     %pêtla wyboru wêz³a
     for l=1:iter
    for i=1:M
                %tworzenie macierzy prawdopodobieñstw na podstawie wzoru
                for g=1:n
                alfa_feromony=feromony.^alfa;
                s=sum(alfa_feromony(:,g));
                prawdop=(1/s).*alfa_feromony; %feromony
                end
                
         for j=1:n
            r=rand;
            s=0;
    
            for k=1:H %numer wezla
                s=s+prawdop(k,j);%uzycie kola ruletki
                if r<=s
                    trasa(i,j)=parametry(k,j); %zapisywana warto¶æ wybranego wêz³a w macierzy trasy
                    ktory_wezel(i,j)=k;
                    break
                end
            end    
       end
     
         %wyznaczanie wskaznika jako¶ci dla trasy pierwszej mrówki

            trasa_mrowki(1,:)=trasa(i,:) %trasa i-tej mrówki(i-ty wiersz macierzy trasa)
            
           wskaznik(i,l)=funkcjabledu(trasa_mrowki); %zapisanie wskaznika w macierzy o wymiarach iter-kolumn M-wierszy
           
            
            %aktualizacja lokalna feromonów
            trasa_w_wezlach(1,:)=ktory_wezel(i,:);
            pierwszy_el=trasa_w_wezlach(1);
            drugi_el=trasa_w_wezlach(2);
            trzeci_el=trasa_w_wezlach(3);
            
                      feromony(pierwszy_el,1)=feromony(pierwszy_el,1)+(Q/(wskaznik(i,l)));
                      feromony(drugi_el,2)=feromony(drugi_el,2)+(Q/(wskaznik(i,l)));
                      feromony(trzeci_el,3)=feromony(trzeci_el,3)+(Q/(wskaznik(i,l)));
                      
                      
                      [E(l),F(l)]=min(wskaznik(:,l));
                      
     
    
                      
    end
    
%     %sprawdzanie czy najlepszy wska¼nik

          [A,B]=min(wskaznik);  %dla iteracji D-- sprawdzam jaka jest warto¶c (tzn która mrówka najlepsza)
          [C,D]=min(A); %D-która iteracja ma warto¶æ wska¼nika min
       
%     %aktualizacja globalna feromonów
    for jj=1:n
        for ii=1:H
            feromony(ii,jj)=(1-ro).*feromony(ii,jj)+(1/C);
        end
    end
    
     end
%     


