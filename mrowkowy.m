clear;
clc;
%function [besttour,mincost]=MyAlgorithm(n,iter,M);

blad_koncowy=rand;
J=10; %zakres zmian warto¶ci parametrów
M=10; %liczba mrówek
n=3; %liczba parametrów
iter=20; %max liczba iteracji
alfa=2;

%Za³o¿one warto¶ci graniczne dla parametrow X1,X2,X3
X1min=-100e-6;
X1max=-100e-4;
X2min=278e-6;
X2max=278e-4;
X3min=-166e-6;
X3max=-166e-4;

%Tworzenie macierzy mo¿liwych kandydatów do rozwi±zania dla ka¿dego z
%parametrów X1=xxx(1),X2=xxx(2),X3=xxx(3)
X1(1)=X1min;
X1(J)=X1max;
X2(1)=X2min;
X2(J)=X2max;
X3(1)=X3min;
X3(J)=X3max;

for j=2:J-1
    
X1(j)=X1(j-1) + (X1max - X1min)/(J-1);
X2(j)=X2(j-1) + (X2max - X2min)/(J-1);
X3(j)=X3(j-1) + (X3max - X3min)/(J-1);
end;

X=[X1',X2',X3'];

%Tworzenie macierzy feromonów
for j=1:J
    for i=1:3
        feromon(i,j)=1/blad_koncowy;
        feromony=feromon';
    end
end

parametry=ones(M,n); %tworzenie macierzy przykladowych wartosci wybranych parametrow

%y=max(feromony(:,1,:))
%tworzenie macierzy prawdopodobieñstw
for j=1:n
    for i=1:M
aktual_feromony=feromony.^alfa;
s=sum(aktual_feromony(:,j));
p(i,j)=aktual_feromony(i,j)/s; %feromony
    end
end

%metoda ko³a ruletki
 r=rand;
        s=0;
        for k=1:M %numer parametru
            s=s+p(k); %uzycie ko³a rulrtki
            if r<=s
                rute(i,j+1)=k; %umieszczenie mrówki i w kolejnym wê¼le
                break