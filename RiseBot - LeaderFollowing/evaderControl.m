function [V, Om] = evaderControl(X,X_Ag,Xg)

% X: evader state
% X_Ag: neighbour state

global BETA_V;

thd = atan2( Xg(2) - X(2) , Xg(1) - X(1) );  % evader desired heading theta_desired
thd = rad2deg(thd);
BETA_V = BetaAnalitic(X,X_Ag);

% if pathcheck(X,thd,BETA_V); 
%     thd = BETA_V(2);  % deconfliction policy: second beta
% end

K = 0.3;

thd = wrapTo180(thd);
error = (thd - X(3)); 

V = 40;
Om = K * error;


% saturation
if abs(Om) > 125
    Om = 125*Om/abs(Om);
end








