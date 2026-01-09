function [y,cs,cv,cr] =f3_f(time,theta,ydata)
pop=1000000;
[y,cs,cv,cr] = f4_f(time,theta,ydata); %.*pop
y=y*pop;
% options = odeset('Mass',@(t)[t,0;0,-t],'MaxStep',1,'InitialStep',1,'RelTol',1e-2,'AbsTol',1e-3);
% 
% [t,y]=ode45(@algaesys_for,time,[],theta,options);
% y = f4(time,theta,xdata);




