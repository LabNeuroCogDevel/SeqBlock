function s=testscreen()
    subjID='test';
    s = loadCues(initScreen(getSettings([],subjID)));

    ev=loadEvents(s.blocks.bestSeqs(1),s)
    
    disp(s)
    DrawFormattedText(s.display.w,'TEST','center','center');
    Screen('Flip', s.display.w);
    sca;
end