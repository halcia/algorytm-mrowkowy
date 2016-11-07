clear;
clc;
%function [besttour,mincost]=MyAlgorithm(n,iter,M);


H=30; %zakres zmian warto�ci parametr�w
M=15; %liczba mr�wek
n=3; %liczba parametr�w
iter=20; %max liczba iteracji
alfa=1;
beta=1;

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

[blad_koncowy]=funkcjabledu(K123)

%Tworzenie macierzy feromon�w
for j=1:n
    for i=1:H
        feromony(i,j)=1/blad_koncowy;
 
    end
end

    for j=1:n
        for i=1:H
    alfa_feromony=feromony.^alfa;
    s=sum(alfa_feromony(:,j));
    prawdop=(1/s).*alfa_feromony; %feromony
        end
    end

    
%losowanie randomowej wartosci dla pierwszego parametru z zakresu
%X1min-X1max
o=rand(M,1); 
losowa=(((-100e-5 - (-300e-5)) .* o) + (-300e-5)) - mod((((-100e-5 - (-300e-5)) .* o) + (-300e-5)) , 0.00000001); 
trasa(:,1)=losowa
  
   for i=1:M
       for j=1:n-1
            r=rand;
            s=0;
            for k=1:H %numer wezla
                s=s+prawdop(k,j);%uzycie kola ruletki
                if r<=s
                    trasa(i,j+1)=parametry(k,j+1); %umieszczenie mrowki i w nastepnym wezle
                    break
                end
            end    
       end
         %wyznaczanie wskanika jako�ci
%         rozwiazanie()=trasa(i,:)
%            [blad_koncowy1(i)]=funkcjabledu(rozwiazanie(i))
          
            
            %aktualizacja lokalna feromon�w
            
    end
    
         

    


