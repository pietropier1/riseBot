function outmsg = readSerial(ssCOM)


timeoutMax = 4;
timeout = 0;
readInterval = 0.5;

while timeout < timeoutMax
    if (ssCOM.BytesAvailable > 0)
        outmsg = char(fread(ssCOM, ssCOM.BytesAvailable))';
        display(outmsg)
        return
    end
    
    pause(readInterval);
    timeout = timeout + readInterval;
    
end
        
        
display('!!! Serial read timed out\n !!!');