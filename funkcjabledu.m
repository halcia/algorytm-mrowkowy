function blad = funkcjabledu(ship_param)

global x_odn;
global y_odn;
global u_odn;

% global Nrudder1;
% global t1;
% global r1;
% global U1;
% global advance1;
% global transfer1;

x0  = zeros(7,1);
ui = -35*pi/180;
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)

[t,u,v,r,x,y,psi,U, advance, transfer] = MyTurncircle('MyMariner',x0,ui,t_final,t_rudderexecute,h,ship_param);


% zabezpieczenie jezeli wartosc wychodzi poza zakres minimalny mozliwy do
% reprezentacji

for i=1:size(x,1)
    if isnan(x(i))
        x(i) = 0;
    end
    if isnan(y(i))
        y(i) = 0;
    end
    if isnan(u(i))
        u(i) = 0;
    end
end

if nargin~=1, error('number of inputs must be 1'); end
if (length(x) ~= length(x_odn)),error('x1 musi by? dlugosci takiej jak x2!'); end
if (length(y) ~= length(y_odn)),error('y1 musi by? dlugosci takiej jak y2!'); end
if (length(u) ~= length(u_odn)),error('u1 musi by? dlugosci takiej jak u2!'); end

% alokacja pamiêci dla macierzy blêdów
x_blad = zeros(size(x,1), 1);
y_blad = zeros(size(x,1), 1);
u_blad = zeros(size(x,1), 1);

for i=1:size(x,1)
    x_blad(i,1)=(x_odn(i,1)-x(i,1))^2;
    y_blad(i,1)=(y_odn(i,1)-y(i,1))^2;
    u_blad(i,1)=(u_odn(i,1)-u(i,1))^2;
end

blad=sum(x_blad) + sum(y_blad) + sum(u_blad);