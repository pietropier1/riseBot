function flagCK = pathcheck(X,G,BETA)
% flagCK = 0 --> free way between the actual heading and the desired one
%          1 --> agents on track between the actual heading and the desired
%          one

flagCK = 0;
AT = X(3);

alp_w = direction(AT,G);

dd1 = AT - BETA(:,1);
dd2 = AT - BETA(:,2);

for nn = 1:size(BETA,1)
    if isBetween(AT,BETA(nn,:))
    flagCK = 1;
    AT = G;
    end
end

while abs( mod(AT,2*pi) - G ) > 0.01
    
    if sum(dd1.*(AT - BETA(:,1))<0) || sum(dd2.*(AT - BETA(:,2))<0)
        flagCK = 1;
        break
    end
    
    dd1 = AT - BETA(:,1);
    dd2 = AT - BETA(:,2);
    
    AT = AT + 0.001*alp_w;
    
end