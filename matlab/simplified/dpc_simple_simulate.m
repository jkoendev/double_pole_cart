function dpc_simple_simulate
  
  % parameters (not modifiable as the parameters are hardcoded in the equations below)
  p = struct;
  p.r_1 = 1;
  p.r_2 = 1;
  p.m_c = 5;
  p.m_1 = 1;
  p.m_2 = 1;
  p.g   = 9.81;
  
  % get a random starting state between min state and max state
  x_min = [-1; -pi; -pi; -.05; -1; -1];
  x_max = -x_min;
  x0 = rand(6,1) .* (x_max-x_min)+x_min;
  
  % simulate
  tspan = [0:0.01:8];
  [tspan, X] = ode45(@dpc_simple_ode, tspan, x0);
  
  dpc_simple_draw(tspan, X, x_min, x_max, p);
 
end

function xdot = dpc_simple_ode(t, x)
  
  f = 0;
  
  q_0 = x(1);
  q_1 = x(2);
  q_2 = x(3);
  
  qdot_0 = x(4);
  qdot_1 = x(5);
  qdot_2 = x(6);
  
  qddot_0 = (-f.*cos(2*q_2)+3*f-4*qdot_1.^2.*cos(q_1)-qdot_1.^2.*cos(q_1-q_2) ...
             -qdot_1.^2.*cos(q_1+q_2)-2*qdot_1.*qdot_2.*cos(q_1-q_2)-...
             2*qdot_1.*qdot_2.*cos(q_1+q_2)-qdot_2.^2.*cos(q_1-q_2) ... 
             -qdot_2.^2.*cos(q_1+q_2)+981*sin(2*q_1)/50) ...
             ./ (-2*cos(2*q_1)+5*cos(2*q_2)-17);
  qddot_1 = (3*f.*sin(q_1)-f.*sin(q_1+2*q_2)-2*qdot_1.^2.*sin(2*q_1) ...
             -11*qdot_1.^2.*sin(q_2)-5*qdot_1.^2.*sin(2*q_2) ...
             -qdot_1.^2.*sin(2*q_1+q_2)-22*qdot_1.*qdot_2.*sin(q_2) ...
             -2*qdot_1.*qdot_2.*sin(2*q_1+q_2)-11*qdot_2.^2.*sin(q_2) ...
             -qdot_2.^2.*sin(2*q_1+q_2)+18639*cos(q_1)/100 ...
             -981*cos(q_1+2*q_2)/20)./(-2*cos(2*q_1)+5*cos(2*q_2)-17); 
  qddot_2 = (-300*f.*sin(q_1)-200*f.*sin(q_1-q_2)+200*f.*sin(q_1+q_2) ...
             +100*f.*sin(q_1+2*q_2)+200*qdot_1.^2.*sin(2*q_1) ...
             +3100*qdot_1.^2.*sin(q_2)+1000*qdot_1.^2.*sin(2*q_2) ...
             +100*qdot_1.^2.*sin(2*q_1+q_2)+2200*qdot_1.*qdot_2.*sin(q_2) ...
             +1000*qdot_1.*qdot_2.*sin(2*q_2)+200*qdot_1.*qdot_2.*sin(2*q_1+q_2) ...
             +1100*qdot_2.^2.*sin(q_2)+500*qdot_2.^2.*sin(2*q_2) ...
             +100*qdot_2.^2.*sin(2*q_1+q_2)-18639*cos(q_1)-9810*cos(q_1-q_2) ...
             +9810*cos(q_1+q_2)+4905*cos(q_1+2*q_2))./(100*(-2*cos(2*q_1)+5*cos(2*q_2)-17));
  
  xdot = [qdot_0;qdot_1;qdot_2;qddot_0;qddot_1;qddot_2];
end