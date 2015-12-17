% Update a Matlab Plot with values from a single frame of mocap data
function UpdateUIleaderFollowing( frameOfData )

    % leader must be defined as body object n. 1


    persistent lastFrameTime;
    persistent lastFrameID;
    persistent Rob;
    persistent Lea;
    persistent arrayIndex;
    persistent bufferModulo;
    persistent agentsState;

    global frameRate;
    global ssCOM;
    
    if isempty(Rob) % first time - generate an array and a plot
        % initialize statics
        bufferModulo = 256;
        arrayIndex = 1;
        lastFrameTime = frameOfData.fLatency;
        lastFrameID = frameOfData.iFrame;
        agentsState = zeros(2,4); % [Z, X, angleY, V]
       
        Rob = plot([0;0],[0;0],'ob','Markersize',10,'MarkerEdgeColor','k','MarkerFaceColor','b');
        Lea = plot(0,0,'sg','Markersize',10,'MarkerEdgeColor','k','MarkerFaceColor','g');
        set(gca,'XLim',[-5 5],'YLim',[-5 5]);
        grid on;
        
    end

    newFrame = true;
    droppedFrames = false;
    frameTime = frameOfData.fLatency;
    frameID = frameOfData.iFrame;
    timeInc = frameTime - lastFrameTime;
    calcFrameInc = round( (frameTime - lastFrameTime) * frameRate );
    % clamp it to a circular buffer of 255 frames
    arrayIndex = mod(arrayIndex + calcFrameInc, bufferModulo);
    if(arrayIndex==0)
        arrayIndex = 1;
    end
    if(calcFrameInc > 1)
        % debug
        % fprintf('\nDropped Frame(s) : %d\n\tLastTime : %.3f\n\tThisTime : %.3f\n', calcFrameInc-1, lastFrameTime, frameTime);
        droppedFrames = true;
    elseif(calcFrameInc == 0)
        % debug
        % display('Duplicate Frame')      
        newFrame = false;
    end
    
    try
        if(newFrame)
            if(frameOfData.RigidBodies.Length() > 0)
                leaderBodyData = frameOfData.RigidBodies(1);        % extract leader data
                leaderState = [leaderBodyData.z leaderBodyData.x];
                
                
                for iaa = 1:2   % agents state construction (for 2 agents)
                    
                    if iaa == 1; IPadd = '66';else IPadd = '67'; end                  
                    rigidBodyData = frameOfData.RigidBodies(iaa+1);            
                    angleY = asin( 2*(rigidBodyData.qw*rigidBodyData.qy - rigidBodyData.qx*rigidBodyData.qz ) );
                    th = 90 + angleY*180/pi;
                    if rigidBodyData.qw < sin(pi/4)
                        th = -th;
                    end     
                    velocity = 1./timeInc*(sqrt( (rigidBodyData.z-agentsState(iaa,1))^2 + (rigidBodyData.x-agentsState(iaa,2))^2 ));
                    agentsState(iaa,1:4) = [rigidBodyData.z rigidBodyData.x th velocity];  
                    
                    goalDist = sqrt( (leaderState(1)-agentsState(iaa,1))^2 + (leaderState(2)-agentsState(iaa,2))^2 ); 

                    if goalDist < 0.4
                        fwrite(ssCOM, buildFrame(0,0,IPadd),'uint8');
                    else
                        omega=control(agentsState(iaa,:),agentsState(iaa+(-1)^(iaa+1),:),leaderState+0.1*(-1)^iaa,iaa); 
                        cW = double(round(omega));
                        cV = 50;
                        fwrite(ssCOM, buildFrame(cV,cW,IPadd),'uint8')
                    end    
                    
                    pause(0.1)
                end      

                if(droppedFrames)
                    
                    for i = 1 : calcFrameInc
                        fillIndex = arrayIndex - i;
                        if(fillIndex < 1)
                            fillIndex = bufferModulo-(abs(fillIndex)+1);
                        end
                    end
                end

                set(Rob,'XData',agentsState(1:2,1),'YData',agentsState(1:2,2));
                set(Lea,'XData',leaderState(1),'YData',leaderState(2));
                axis([-5 5 -5 5])

           end
        end
    catch err
        display(err);
    end
    
    lastFrameTime = frameTime;
    lastFrameID = frameID;

end