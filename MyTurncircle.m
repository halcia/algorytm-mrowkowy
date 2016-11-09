function [t,u,v,r,x,y,psi,U,Nrudder1,advance1,transfer1] = MyTurncircle(ship,x,ui,t_final,t_rudderexecute,h,ship_param)
% TURNCIRCLE  [t,u,v,r,x,y,psi,U] = turncircle(ship,x,ui,t_final,t_rudderexecute,h)
%             computes the turning circle maneuvering indexes, see ExTurnCircle.m
%
% Inputs :
% 'ship'          = ship model. Compatible with the models under .../gnc/VesselModels/
% x               = initial state vector for ship model
% ui              = [delta,:] where delta is the rudder command at time = t_rudderexecute
% t_final         = final simulation time
% t_rudderexecute = time control input is activated
% h               = sampling time
%
% Outputs :
% t               = time vector
% u,v,r,x,y,psi,U = time series
%
% Author:    Thor I. Fossen
% Date:      18th July 2001
% Revisions: 25th November 2002, expression for Nrudder1 was corrected, included
%                 plots for rudder execute, 90 deg heading angle
% ________________________________________________________________
%
% MSS GNC is a Matlab toolbox for guidance, navigation and control.
% The toolbox is part of the Marine Systems Simulator (MSS).
%
% Copyright (C) 2008 Thor I. Fossen and Tristan Perez
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% E-mail: contact@marinecontrol.org
% URL:    <http://www.marinecontrol.org>

if nargin~=7, error('number of inputs must be 7'); end
if t_final<t_rudderexecute, error('t_final must be larger than t_rudderexecute'); end

N = round(t_final/h);               % number of samples
xout = zeros(N+1,8);                % memory allocation
store1 = 1; store2 = 1;             % logical variables (0,1)

% disp('Simulating...')

for i=1:N+1,
    time = (i-1)*h;
    
    if round(abs(x(6))*180/pi)>=90 & store1==1, 
        transfer1=x(5);   % transfer1 at 90 deg
        advance1 =x(4);   % advance1 at 90 deg
        store1 = 0;
    end
    
    if round(abs(x(6))*180/pi)>=180 & store2==1, 
        tactical=x(5);   % tactical diameter at 180 deg
        store2 = 0;
    end
    
    u_ship = ui;
    if round(time) < t_rudderexecute, 
       u_ship(1) = 0;   % zero rudder angle
    end     
    
    [xdot,U] = feval(ship,x,u_ship,ship_param);       % ship model
    
    xout(i,:) = [time,x(1:6)',U];  
    
    x = euler2(xdot,x,h);                     % Euler integration
end

% time-series
t     = xout(:,1);
u     = xout(:,2); 
v     = xout(:,3);         
r     = xout(:,4)*180/pi; 
x     = xout(:,5);
y     = xout(:,6);
psi   = xout(:,7)*180/pi;
U     = xout(:,8);


Nrudder1 = round(t_rudderexecute/h); 
Nrudder1 = round(t_rudderexecute/h);


%turning radius, tactical diameter, advance1 and transfer1
% disp(' ')
% disp(sprintf('Rudder execute (x-coordinate)          : %4.0f m',abs(x(Nrudder1))))
% disp(sprintf('Steady turning radius                  : %4.0f m',U(N+1)/abs(r(N+1)*pi/180)))
% disp(sprintf('Maximum transfer1                       : %4.0f m',abs(max(abs(y)))))
% disp(sprintf('Maximum advance1                        : %4.0f m',abs(max(abs(x))-x(Nrudder1))))      
% disp(sprintf('transfer1 at 90 (deg) heading           : %4.0f m',abs(transfer1)))    
% disp(sprintf('advance1 at 90 (deg) heading            : %4.0f m',abs(advance1-x(Nrudder1))))        
% disp(sprintf('Tactical diameter at 180 (deg) heading : %4.0f m',abs(tactical)))
% 
% % plots
% figure(1)
% plot(x,y,x(Nrudder1),y(Nrudder1),'linewidth',2), hold on
% plot(x(Nrudder1),y(Nrudder1),'*r',advance1,transfer1,'or'), hold off
% grid,axis('equal'),xlabel('x-position'),ylabel('y-position')
% title('Turning circle (* = rudder execute, o = 90 deg heading)')
% figure(2)
% subplot(211),plot(t,r),xlabel('time (s)'),title('yaw rate r (deg/s)'),grid
% subplot(212),plot(t,U),xlabel('time (s)'),title('speed U (m/s)'),grid

