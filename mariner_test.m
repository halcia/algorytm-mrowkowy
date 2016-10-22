x  = zeros(7,1);
ui = -35*pi/180;
% [xdot, u] = MyMariner(x,ui,[-100e-5])
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)
global u2;
global y2;
global x2;
global Nrudder1;
global Nrudder;
global t2;
global U2;
global r2;
global u1;
global y1;
global x1;
global t1;
global r1;
global U1;


[t2,u2,v2,r2,x2,y2,psi2,U2] = turncircle('mariner',x,ui,t_final,t_rudderexecute,h);

para = [-100e-5, 270e-5, -160e-5];

[blad_koncowy]=funkcjabledu(para);

%[x, fval] = fminunc(@funkcjabledu, para);

figure(1)
subplot(211),plot(t1,r1,'b'),xlabel('time (s)'),title('yaw rate r (deg/s)'),grid
hold on;
plot(t2,r2,'g') 
hold off;
legend('r1','r2')
subplot(212),plot(t1,U1,'b'),xlabel('time (s)'),title('speed U (m/s)'),grid 
hold on;
plot(t2,U2,'g')
hold off;
legend('U1','U2')

