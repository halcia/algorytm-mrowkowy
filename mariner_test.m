x  = zeros(7,1);
ui = -35*pi/180;
% [xdot, u] = MyMariner(x,ui,[-100e-5])
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)
global u2;
global y2;
global x2;

[t2,u2,v2,r2,x2,y2,psi2,U2] = turncircle('mariner',x,ui,t_final,t_rudderexecute,h);

para = [-100e-5, 270e-5, -160e-5];

[blad_koncowy]=funkcjabledu(para);

%[x, fval] = fminunc(@funkcjabledu, para);



