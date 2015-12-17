function flg = freeWayChk(curr,beta,des)

% returns 1 if desired is on free way, 0 if in VO
% curr: current heading
% beta: VO bounding angles --> assumes VO to be ccw from beta(1) to beta(2) 
% des: desired heading

% IMPORTANT: agent can never cross the VO. if VO is between curr and des,
% agent must turn all the way around

% !!! PAIRWISE CONFLICT ASSUMPTION !!!


flg = 0;
beta = mod(beta,2*pi);
curr = mod(curr,2*pi);
des = mod(des,2*pi);

if size(beta,1) > 1; disp('Too many agents. Invalid pathcheck!');end

beta_hat = beta - beta(1,1);
curr_hat = curr - beta(1,1);
des_hat = des - beta(1,1);

if des_hat < beta_hat(1,2) % if desired in 
    
end
    