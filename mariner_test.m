x  = zeros(7,1);
ui = -35*pi/180;
[xdot, u] = MyMariner(x,ui);
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)
[t1,u1,v1,r1,x1,y1,psi1,U1] = MyTurncircle('MyMariner',x,ui,t_final,t_rudderexecute,h);

[t2,u2,v2,r2,x2,y2,psi2,U2] = MyTurncircle('mariner',x,ui,t_final,t_rudderexecute,h);