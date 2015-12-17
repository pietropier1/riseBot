function NatNet()

    display('NatNet Sample Begin')
    
    global frameRate;
    global logid;
    global ssCOM;
    global Xgvec;

    lastFrameTime = -1.0;
    lastFrameID = -1.0;
    usePollingLoop = false;         % approach 1 : poll for mocap data in a tight loop using GetLastFrameOfData
    usePollingTimer = false;        % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
    useFrameReadyEvent = true;      % approach 3 : use event callback from NatNet (no polling)
    useUI = true;

    persistent arr;
    % Open figure
    if(useUI)
        hFigure = figure('Name','RISEbot guidance system','NumberTitle','off',...
            'Position',[400, 600, 1600, 800]); hold on
        
        
    end

    try
        % Add NatNet .NET assembly so that Matlab can access its methods, delegates, etc.
        % Note : The NatNetML.DLL assembly depends on NatNet.dll, so make sure they
        % are both in the same folder and/or path if you move them.
        display('[NatNet] Creating Client.')
        % TODO : update the path to your NatNetML.DLL file here
        dllPath = fullfile('c:','NatNet_SDK_2.6','lib','x64','NatNetML.dll');
        assemblyInfo = NET.addAssembly(dllPath);

        % Create an instance of a NatNet client
        theClient = NatNetML.NatNetClientML(0); % Input = iConnectionType: 0 = Multicast, 1 = Unicast
        version = theClient.NatNetVersion();
        fprintf( '[NatNet] Client Version : %d.%d.%d.%d\n', version(1), version(2), version(3), version(4) );

        % Connect to an OptiTrack server (e.g. Motive)
        display('[NatNet] Connecting to OptiTrack Server.')
        hst = java.net.InetAddress.getLocalHost;
        %HostIP = char(hst.getHostAddress);
        HostIP = char('127.0.0.1');
        flg = theClient.Initialize(HostIP, HostIP); % Flg = returnCode: 0 = Success
        if (flg == 0)
            display('[NatNet] Initialization Succeeded')
        else
            display('[NatNet] Initialization Failed')
        end
        
        % print out a list of the active tracking Models in Motive
        GetDataDescriptions(theClient)
        
        % Test - send command/request to Motive
        [byteArray, retCode] = theClient.SendMessageAndWait('FrameRate');
        if(retCode ==0)
            byteArray = uint8(byteArray);
            frameRate = typecast(byteArray,'single');
        end
        
        % get the mocap data
        if(usePollingTimer)
            % approach 2 : poll using a Matlab timer callback ( better for UI based apps )
            framePerSecond = 200;   % timer frequency
            TimerData = timer('TimerFcn', {@TimerCallback,theClient},'Period',1/framePerSecond,'ExecutionMode','fixedRate','BusyMode','drop');
            start(TimerData);
            % wait until figure is closed
            uiwait(hFigure);
        else
            if(usePollingLoop)
                % approach 1 : get data by polling - just grab 5 secs worth of data in a tight loop
                for idx = 1 : 1000   
                   % Note: sleep() accepts [mSecs] duration, but does not process any events.
                   % pause() processes events, but resolution on windows can be at worst 15 msecs
                   java.lang.Thread.sleep(5);  

                    % Poll for latest frame instead of using event callback
                    data = theClient.GetLastFrameOfData();
                    frameTime = data.fLatency;
                    frameID = data.iFrame;
                    if(frameTime ~= lastFrameTime)
                        fprintf('FrameTime: %0.3f\tFrameID: %5d\n',frameTime, frameID);
                        lastFrameTime = frameTime;
                        lastFrameID = frameID;
                    else
                        display('Duplicate frame');
                    end
                 end
            else
                % approach 3 : get data by event handler (no polling)
                % Add NatNet FrameReady event handler
%                 logid = fopen('RobotLogEvent.txt','w');
%                 fprintf(logid,'%s\r\n',' *** New Robot Session ***');
                ls = addlistener(theClient,'OnFrameReady2',@(src,event)FrameReadyCallback(src,event));
                display('[NatNet] FrameReady Listener added.');
                % wait until figure is closed
                uiwait(hFigure);
            end
        end

    catch err
        display(err);
    end

    % cleanup
    if(usePollingTimer)
        stop(TimerData);
        delete(TimerData);
    end
    theClient.Uninitialize();
    if(useFrameReadyEvent)
        if(~isempty(ls))
            delete(ls);
        end
    end
%     fclose(logid);
    fwrite(ssCOM, buildFrame(0,0,'66'),'uint8');   % STOP robot
    fwrite(ssCOM, buildFrame(0,0,'67'),'uint8');   % STOP robot
    display('Robot Log Event Closed')
    clear functions;

    display('NatNet Sample End')
    
end

% Test : process data in a Matlab Timer callback
function TimerCallback(obj, event, theClient)

    frameOfData = theClient.GetLastFrameOfData();
    UpdateUI( frameOfData );
    
end

% Test : Process data in a NatNet FrameReady Event listener callback
function FrameReadyCallback(src, event)
    
    frameOfData = event.data;
    UpdateUIleaderFollowing( frameOfData );
    
end

% Print out a description of actively tracked models from Motive
function GetDataDescriptions( theClient )

    dataDescriptions = theClient.GetDataDescriptions();
    
    % print out 
    fprintf('[NatNet] Tracking Models : %d\n\n', dataDescriptions.Count);
    for idx = 1 : dataDescriptions.Count
        descriptor = dataDescriptions.Item(idx-1);
        if(descriptor.type == 0)
            fprintf('\tMarkerSet \t: ');
        elseif(descriptor.type == 1)
            fprintf('\tRigid Body \t: ');                
        elseif(descriptor.type == 2)
            fprintf('\tSkeleton \t: ');               
        else
            fprintf('\tUnknown data type : ');               
        end
        fprintf('%s\n', char(descriptor.Name));
    end

    for idx = 1 : dataDescriptions.Count
        descriptor = dataDescriptions.Item(idx-1);
        if(descriptor.type == 0)
            fprintf('\n\tMarkerset : %s\t(%d markers)\n', char(descriptor.Name), descriptor.nMarkers);
            markerNames = descriptor.MarkerNames;
            for markerIndex = 1 : descriptor.nMarkers
                name = markerNames(markerIndex);
                fprintf('\t\tMarker : %-20s\t(ID=%d)\n', char(name), markerIndex);             
            end
        elseif(descriptor.type == 1)
            fprintf('\n\tRigid Body : %s\t\t(ID=%d, ParentID=%d)\n', char(descriptor.Name),descriptor.ID,descriptor.parentID);
        elseif(descriptor.type == 2)
            fprintf('\n\tSkeleton : %s\t(%d bones)\n', char(descriptor.Name), descriptor.nRigidBodies);
            %fprintf('\t\tID : %d\n', descriptor.ID);
            rigidBodies = descriptor.RigidBodies;
            for boneIndex = 1 : descriptor.nRigidBodies
                rigidBody = rigidBodies(boneIndex);
                fprintf('\t\tBone : %-20s\t(ID=%d, ParentID=%d)\n', char(rigidBody.Name), rigidBody.ID, rigidBody.parentID);
            end               
        end
    end

end



 