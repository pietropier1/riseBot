clear all; close all; clc

global rPZ;
rPZ = 0.3;
global ssCOM;
global beta;
beta = [0 0];

display('Serial comunication begin')
ssCOM = serial('COM30','BaudRate',57600);
set(ssCOM,'DataBits',8);
set(ssCOM,'StopBits',1);
set(ssCOM,'Terminator','')
fopen(ssCOM);

NatNet();


fclose(ssCOM)
delete(ssCOM)
disp('Serial closed')
