close all; clear all; clc

% AT comands test

display('Serial comunication begin')
ssCOM = serial('COM30','BaudRate',57600);
% ssCOM = serial('/dev/tty.usbserial-A603H4MZ','BaudRate',57600);
set(ssCOM,'DataBits',8);
set(ssCOM,'StopBits',1);
% set(ssCOM,'Terminator','')
ssCOM.Terminator = 'CR';
fopen(ssCOM);


try

    display('Entering API mode')
%     cW = 30;
%     cV = 20;

    

%     APIframe1txt = ['7E';'00';'11';'00';'00';'00';'00';'00';'00';'C0';'A8';'01';'66';'00';'56';'33';'30';'57';'30';'30';'C0'];
%     APIframe2txt = ['7E';'00';'11';'00';'00';'00';'00';'00';'00';'C0';'A8';'01';'67';'00';'56';'33';'30';'57';'30';'30';'BF'];


    frame1 = buildFrame(30,0,'68');
    fwrite(ssCOM, frame1, 'uint8');
%     frame2 = buildFrame(00,0,'67');
%     fwrite(ssCOM, frame2, 'uint8');
    

    
    

catch err
    display(err)


end





fclose(ssCOM);
delete(ssCOM)
disp('Serial closed')
