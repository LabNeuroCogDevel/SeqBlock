function doSeq
autopilot = 0; % prompt subject to continue with next run

subjID = input('Subject ID: ', 's');

% get settings and initscreen now b/c we want 
%  totalruns
%  s.display.w
s = initScreen(getSettings([],subjID));
s = loadCues(s);
instructions(s)

for runnum = 1:s.totalruns
    
    % start with a count down (behavioral indication of next run)
    for countdown=fliplr(1:3);
        disptext = sprintf('Run # %d/%d starts in %d seconds',runnum,s.totalruns,countdown);
        DrawFormattedText(s.display.w,disptext,'center','center');
        Screen('Flip', s.display.w);
        WaitSecs(1) 
    end
    
    % let user say when to go
    if(~autopilot)
        DrawFormattedText(s.display.w,'Push any key when you are ready','center','center');
        Screen('Flip', s.display.w);
        KbWait()
        Screen('Flip', s.display.w);
    end
    
    s = SeqBlock(subjID, runnum, s);
end

% clear the screen when we're done
sca

end