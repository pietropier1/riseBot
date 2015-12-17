function thd = decisionPolicy(cur,beta,des)

% returns desired heading after policy evaluation
% 
% cur: current heading 
% beta: VO bounding angles --> assumes VO to be ccw from beta(1) to beta(2) 
% des: desired heading
% all angles in radiant

% IMPORTANT: agent can never cross the VO. if VO is between cur and des,
% agent must turn all the way around

% !!! PAIRWISE CONFLICT ASSUMPTION !!!

% prelim
beta = mod(beta,2*pi);
cur = mod(cur,2*pi);
des = mod(des,2*pi);

if size(beta,1) > 1; disp('Too many agents. Invalid pathcheck!'); pause; end


beta_hat = mod(beta - beta(1,1),2*pi);            % bring beta_1 to origin and change reference system for all angles
cur_hat = mod(cur - beta(1,1),2*pi);
des_hat = mod(des - beta(1,1),2*pi);

% ShrtDr: Shortest direction from cur to des
% d_dc = [wrapToPi(des)-wrapToPi(cur) wrapTo2Pi(des)-wrapTo2Pi(cur)];
% [~,which] = min(abs(d_dc));
% d_dc = d_dc(which);
% if d_dc <= 0
%     ShrtDr = -1;                        % shortest direction is cw
% else
%     ShrtDr = 1;                         % shortest direction is ccw
% end

thd = 0;
delta_dc = des_hat - cur_hat;           % difference between desired and current 

if cur_hat > beta_hat(1,2)              % current not in VO
    
    if des_hat > beta_hat(1,2)          % if desired outside beta region
        if abs(delta_dc) <= pi          % shortest path (PID rule) is good --> original desired is thd
            thd = des;
            return
        else                            % shortest path is not good --> turn around with intermediate step
            thd = cur + pi*(delta_dc)/abs(delta_dc);
            return
        end  
    else                                % deisred inside beta region 
        if cur_hat - beta_hat(1,2) > 2*pi - cur_hat
            thd = beta(1,1);
            return
        else
            thd = beta(1,2);
            return
        end

    end 

else                                    % current in VO
    if cur_hat > beta_hat(1,2)/2
        thd = beta(1,2);
    else
        thd = beta(1,1);
    end
end

