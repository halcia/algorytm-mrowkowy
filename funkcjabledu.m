
function blad_koncowy = funkcjabledu(xxx);

global x2;
global y2;
global u2;
global Nrudder1;
global t1;
global r1;
global U1;
global advance1;
global transfer1;

x  = zeros(7,1);
ui = -35*pi/180;
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)

[t1,u1,v1,r1,x1,y1,psi1,U1, advance1, transfer1] = MyTurncircle('MyMariner',x,ui,t_final,t_rudderexecute,h,xxx);

if nargin~=1, error('number of inputs must be 1'); end
if (length(x1) ~= length(x2)),error('x1 musi byæ dlugosci takiej jak x2!'); end
if (length(y1) ~= length(y2)),error('y1 musi byæ dlugosci takiej jak y2!'); end
if (length(u1) ~= length(u2)),error('u1 musi byæ dlugosci takiej jak u2!'); end

for i=1:7001,
    x1blad(i)=(x1(i)-x2(i))^2;
    y1blad(i)=(y1(i)-y2(i))^2;
    u1blad(i)=(u1(i)-u2(i))^2;
    xblad=x1blad';
    yblad=y1blad';
    ublad=u1blad';
end
x_suma=sum(xblad);
y_suma=sum(yblad);
u_suma=sum(ublad);
blad_koncowy=x_suma + y_suma + u_suma;
