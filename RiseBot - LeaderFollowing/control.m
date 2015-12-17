function omega = control(Xo,Xn,Xg,iaa)
% control function for bring robot in Xo (ownship) with heading Xo(3) towards target
% Xg avoiding neighbor Xn (neighbor)

global rZP;
global dt;
global beta;
persistent e_old;
persistent E;
% if iaa == 1
% Xo
% Xn
% Xg
% end
if isempty(E)
    E = 0;
    e_old = 0;
end

Kp = 0.5;
Ki = 0;
Kd = 0;

omegaMAX = 80;

% Decision
thd = mod(atan2(Xg(2) - Xo(2) , Xg(1) - Xo(1)),2*pi);

% if iaa == 1
%     % Collision avoidance
%     beta = velocityObstacle(Xo,Xn,beta);
% 
%     thd = decisionPolicy(Xo(3),beta,thd);
% 
% end

thd = rad2deg(thd);
d180 = (wrapTo180(thd) - wrapTo180(Xo(3)));
d360 = (wrapTo360(thd) - wrapTo360(Xo(3)));
derr = [d180,d360];
[~,which] = min(abs(derr));
e = derr(which);
e_dot = e - e_old;
E = E + e;

omega = Kp*e + Ki*E + Kd*e_dot;


if abs(omega) > omegaMAX; omega = omegaMAX*omega/abs(omega); end












