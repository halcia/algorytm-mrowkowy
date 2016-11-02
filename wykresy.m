clc;

x  = zeros(7,1);
ui = -35*pi/180;
t_final = 700;          % final simulation time (sec)
t_rudderexecute = 100;   % time rudder is executed (sec)
h = 0.1;                 % sampling time (sec)
para = [-100e-5, 270e-5, -160e-5];

[t1,u1,v1,r1,x1,y1,psi1,U1,Nrudder1, advance, transfer] = MyTurncircle('MyMariner',x,ui,t_final,t_rudderexecute,h,para);

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

figure(2)
plot(x2,y2,x2(Nrudder),y2(Nrudder),'linewidth',2), hold on
plot(x2(Nrudder),y2(Nrudder),'*r',advance,transfer,'or'), hold on
grid,axis('equal'),xlabel('x-position'),ylabel('y-position')
title('Turning circle (* = rudder execute, o = 90 deg heading)')

plot(x1,y1,x1(Nrudder1),y1(Nrudder1),'linewidth',2), hold on
plot(x1(Nrudder1),y1(Nrudder1),'*r',advance1,transfer1,'or'), hold off
grid,axis('equal'),xlabel('x-position'),ylabel('y-position')
title('Turning circle (* = rudder execute, o = 90 deg heading)')

legend('Próba manewrowa cyrkulacji optymalna','Próba manewrowa cyrkulacji rzeczywista')
