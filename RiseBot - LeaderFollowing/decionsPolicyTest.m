clear all; close all; clc

% decision policy test file


beta(1,1) = 2*pi*rand;
beta(1,2) = 2*pi*rand;
while beta(1,2) < beta(1,1)
    beta(1,1) = 2*pi*rand;
    beta(1,2) = 2*pi*rand;
end
    
beta
cur = 2*pi*rand;
des = 2*pi*rand;


compass([cos(beta(1)),cos(beta(2))],[sin(beta(1)),sin(beta(2))],'b'), hold on
compass(cos(cur),sin(cur),'r')
compass(cos(des),sin(des),'--r')
pause
thd = decisionPolicy(cur,beta,des);

compass(cos(thd),sin(thd),'g')

