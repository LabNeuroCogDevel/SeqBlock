function testscreen()
    subjID='test';
    s = loadCues(initScreen(getSettings([],subjID)));

    disp(s)
    DrawFormattedText(s.display.w,'TEST','center','center');
    Screen('Flip', s.display.w);
end