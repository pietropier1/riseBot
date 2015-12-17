% This function gives a value of +1 if the shortest way for the desired
% heading is with positive rotation, gives value of -1 if it is not.

function alp_w = direction(T,TD)
% T: actual direction
% TD: desired direction


DD = TD - T;

if DD < 0
    alp_w = 1*(DD<=-pi) - 1*(DD>-pi);
elseif DD >= 0
    alp_w = 1*(DD<=pi) - 1*(DD>pi);
else
    disp('something not expected is happening')
end

end
    






