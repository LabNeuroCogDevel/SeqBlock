function testscreen()
    s=getSettings([],'test')
    s=initScreen(s)
    DrawFormattedText(s.display.w,'TEST','center','center');
    Screen('Flip', s.display.w);

    sca
end