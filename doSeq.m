function doSeq

% AUTOPILOT
autopilot=0; 
% NB. ** toggleTestPath('notest') **  before auto -> no auto
% if 0 (normal)
%  - prompt for subject id
%  - wait on subject to continue with next run
% otherwise
%  - truncate timing
%  - generate key presses
%  - no iteraction

if autopilot
    subjID='test';
else
    subjID = input('Subject ID: ', 's');
end


% get settings and initscreen now b/c we want 
%  totalruns
%  s.display.w
s = initScreen(getSettings([],subjID));
s = loadCues(s);
s.autopilot=autopilot; % prop. autopilot to settings/all functions

if s.autopilot
  toggleTestPath()
else
  instructions(s)
end


for runnum = 1:s.totalruns
   
    % let user say when to go
    if(~s.autopilot)
        % start with a count down (behavioral indication of next run)
        for countdown=fliplr(1:3);
            disptext = sprintf('Run # %d/%d starts in %d seconds',runnum,s.totalruns,countdown);
            DrawFormattedText(s.display.w,disptext,'center','center');
            Screen('Flip', s.display.w);
            WaitSecs(1) 
        end

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