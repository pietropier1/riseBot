function [V,theta] = potential(R,theta0,V0,goal,dt,rep,at,m)

%R is matrix with position of AGENTS are column vectors
%theta0 is initial orientations of agents
%V0 is initial velocities of agents
%goal is column vector of goal
% dt is time step
%rep is vector of negative "charge" for the agents
%at is positive charge on goal
%m is column vector of mass factor for each agent

n= size(R,2); %number of agents
% switch nargin
%     
%     case 6
%         at = 1;
%     case 5
%         rep = ones(n,1);
%         at = 1;
%     otherwise
%         ;
%         
% end

for i=1:n
    sum(:,i)=zeros(2,1);
    for j=1:n
       if i == j
           k(i,j) = 0;
       else
       
           k(i,j) = rep(i)*rep(j)/distance(R(:,i),R(:,j))^3;
           
       end
        
        sum(:,i) = sum(:,i) + k(i,j)*(R(:,j)-R(:,i));
        
    end
    size(R(:,i))
     size(goal)
    sum(:,i) = sum (:,i) + (at*rep(i)/distance(R(:,i),goal)^3)*(R(:,i)-goal);
    sum(:,i) = sum(:,i)/m(i)*dt + [V0(i)*cos(theta0(i));V0(i)*sin(theta0(i))];
    V(i) = norm(sum(:,i));
    theta(i) = atan2(sum(2,i),sum(1,i));
end


end