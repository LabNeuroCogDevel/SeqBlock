function showFix(s)

oldSize = Screen('TextSize',s.display.w, 96);
DrawFormattedText(s.display.w,'+','center','center', s.display.textColor);
Screen('Flip', s.display.w);
Screen('TextSize',s.display.w, oldSize);
