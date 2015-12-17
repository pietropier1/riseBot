function bb = isBetween(a,b)
% isBetween checks if angle a belongs to interval [b(1) b(2)]
% angles are in Radians

bb = false; %initialize

a = mod(a,2*pi); 
b = mod(b,2*pi); %makes sure angles are presented in [0,2*pi) interval

if b(1) > b(2) %should check in [b(1) 2*pi] & [0 b(2)]
    bb = (a >= b(1)) || (a <= b(2));
else
    bb = (a >= b(1)) && (a <= b(2)); %check in [b(1) b(2)]
end
    
end