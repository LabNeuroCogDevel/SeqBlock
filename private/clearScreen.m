function clearScreen(s)

if any(strcmp(s.display.mode, {'graphics','both'}))
    %Screen('Flip', s.display.w);
    showFix(s);
end