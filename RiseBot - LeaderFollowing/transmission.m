function transmission(V,W,address)

global ssCOM;

try
    % display('Entering AT mode')
    fwrite(ssCOM,'+++');
    readSerial(ssCOM);        
    display( strcat('Desired destination address:',address) )
    fprintf( ssCOM, address );
    display('Current destination address:');
    fprintf( ssCOM, 'ATDL');
    readSerial(ssCOM);
    display('Closing AT mode')
    fprintf( ssCOM, 'ATCN');
    readSerial(ssCOM);
    flushinput(ssCOM);

    display('Sending message...')
    cW = int8(W);
    cV = int8(V);
    comm = strcat('V',num2str(cV),'W',num2str(cW));
    fprintf(ssCOM,comm,'sync');
    display(comm)
    
    display('...done!')
    pause(2)

catch err
        display(err)
end