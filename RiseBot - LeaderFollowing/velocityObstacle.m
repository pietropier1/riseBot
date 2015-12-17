% Analytical computation of Beta

function BETA = velocityObstacle(Xo,Xn,oldBeta)

global rPZ;

DIS = sqrt( (Xo(1)-Xn(1))^2 + (Xo(2)-Xn(2))^2 )
psi = mod( asin(rPZ ./ ( DIS ) ) , 2*pi );
theta = mod( atan2( (-Xo(2)+Xn(2)),(-Xo(1)+Xn(1))) , 2*pi);

Lam = mod([(theta - psi) (theta + psi)],2*pi); % lambda_1 & lambda_2;each danger aircrafts

BETA = zeros(size(Lam,1),2);

if isempty(oldBeta)
    oldBeta = BETA;
end

for l = 1:size(Lam,1)

    oldDeltaBeta = mod(oldBeta(l,2) - oldBeta(l,1),2*pi);
    
    Thi = Xn(l,3); % weighted heading of agent l
    for jj = 1:2
        A = Xo(4)*tan(Lam(l,jj));
        B = -Xo(4);
        C = Xn(l,4)*sin(Thi)-Xn(l,4)*cos(Thi)*tan(Lam(l,jj));
% Solutor: fsolve works also with InitValue(l) ---> Theta

        BETA(l,jj) = fsolve( @(b) A*cos(b) + B*sin(b) + C,...
            theta(l),optimset('Display','off'));
    end

    BETA(l,:) = mod(BETA(l,:),2*pi);
    newDeltaBeta = mod(BETA(l,2) - BETA(l,1),2*pi);

    if abs(oldDeltaBeta - newDeltaBeta) > pi  % avoid jump > pi in beta value between 2 iter
        BETA(l,:) = BETA(l,end:-1:1);
    end

    if abs(BETA(l,1)-BETA(l,2)) < 1e-3
        BETA(l,2) = BETA(l,1);
    end
    
end
    
end