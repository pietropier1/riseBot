% frame builder
% assamble the frame and convert it into decimal format

function frame = buildFrame(V,W,address)
V,W
frmLgt = 12;
if V < 0; frmLgt = frmLgt + 1; end
if W < 0; frmLgt = frmLgt + 1; end

frmLgt = num2str(frmLgt);


vel = num2str(V);
ome = num2str(W);
if abs(V) < 10 && V >= 0; vel = strcat('0',num2str(abs(V)));end 
if abs(V) < 10 && V < 0; vel = strcat('-','0',num2str(abs(V)));end 
if abs(W) < 10 && W >= 0; ome = strcat('0',num2str(abs(W)));end 
if abs(W) < 10 && W < 0; ome = strcat('-','0',num2str(abs(W)));end 

frame(1,:) = '7E';              % Frame Class Name for reading only
frame(2,:) = '00';              % length 1
frame(3,:) = frmLgt;            % length 2
frame(4:5,:) = ['00';'00'];     % type & ID
frame(6:12,:) = ['00';'00';'00';'00';'C0';'A8';'01'];
frame(13,:) = address;  
frame(14,:) = '00';                 % options

frame(15,:) = '56'; %56 is V in hex
frameIndex = 15;
for ll = 1:size(vel,2)
    frameIndex = frameIndex + 1;
    frame(frameIndex,:) = dec2hex(vel(ll));
end

frameIndex = frameIndex + 1;
frame(frameIndex,:) = '57'; %57 is W in hex
for oo = 1:size(ome,2)
    frameIndex = frameIndex + 1;
    frame(frameIndex,:) = dec2hex(ome(oo));
end
frameIndex = frameIndex + 1;
frame(frameIndex,:) = '0D'; % 0D is carriage return in hex

sumfr = 0;
for xx = 4:frameIndex

    sumfr = sumfr + hex2dec(strcat(frame(xx,1),frame(xx,2)));

end
sumfr = dec2hex(sumfr); sumfr = hex2dec(sumfr(end-1:end));

checksum = hex2dec('FF') - sumfr;
checksum = dec2hex(checksum);


frame(frameIndex+1,:) = checksum;

frame = hex2dec(frame);









