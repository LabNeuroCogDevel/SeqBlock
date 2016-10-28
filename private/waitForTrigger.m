function MRstart = waitForTrigger(s)


% are we ready? if not behave, we're waiting for the scan trigger
% s.visittype set in getSettings
if strcmp(s.visittype,'behave')
    MRstart=GetSecs();
    return;
    %ready=1;
else
    ready=0;
end

switch s.display.mode

    case 'text' 
       if(~ready)
        fprintf('Press enter to start\n');
        pause
        MRstart=GetSecs(); 
       end

    case 'graphics'

        disptext='Get Ready! (Waiting for scanner to start)';
        keyidx = KbName('=+');

        DrawFormattedText(s.display.w,disptext,'center','center');
        Screen('Flip', s.display.w);
        
        while(~ready)
            [keyPressed, MRstart, keyCode] = KbCheck;
            if keyPressed && any(keyCode(keyidx)  )
               ready=1;
            end
        end

    case 'both'
        %fprintf('Press = to start\n');
        disptext='Get Ready! (Waiting for scanner to start)';
        keyidx = KbName('=+');

        DrawFormattedText(s.display.w, disptext, 'center','center', s.display.textColor);
        Screen('Flip', s.display.w);

        while(~ready)
            [keyPressed, MRstart, keyCode] = KbCheck;
            if keyPressed && any(keyCode(keyidx)  )
               ready=1;
            end
        end

end