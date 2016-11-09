% inicjalizacja parametrów
clc;
clear all;
% wartoœci odniesienia
global t_odn;
global v_odn;
global r_odn;
global x_odn;
global y_odn;
global u_odn;
global Nrudder_odn;
global advance_odn;
global transfer_odn;

% parametry do symulacji MyTurncircle
x0  = zeros(7,1);         % wartoœci parametrów pocz¹tkowych dla mariner
ui = -35*pi/180;         % zadany k¹t wychylenia steru
t_final = 700;           % czas symulacji
t_rudderexecute = 100;   % moment rozpoczêcia manewru
h = 0.1;                 % próbkowanie (sec)


% wartoœci oczekiwane parametrów statku
shipParam(1) = -184e-5;
shipParam(2) =  278e-5;
shipParam(3) = -166e-5;

% zmienne globalne konieczne do wyznaczenia funkcji_bledu

[t_odn,u_odn,v_odn,r_odn,x_odn,y_odn,psi2,U2,Nrudder_odn,advance_odn,transfer_odn] = MyTurncircle('MyMariner',x0,ui,t_final,t_rudderexecute,h,shipParam);

