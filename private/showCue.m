function showCue(s, blocki, thisSeq, evType, endTime)


    seqCues = 'AB';
    if any(strcmp(s.display.mode, {'text','both'}))
        switch evType
            case 'cue'
                fprintf(1, 'Learning sequence %s\n', seqCues(thisSeq));
            case 'test_cue'
                fprintf(1, 'Testing sequence %s\n', seqCues(thisSeq));
        end
    end

    if any(strcmp(s.display.mode, {'graphics','both'}))
        DrawFormattedText(s.display.w, seqCues(thisSeq), 'center','center', s.display.textColor);
        Screen('Flip', s.display.w);
    end


    while GetSecs < endTime
        WaitSecs(0.01);
    end

    clearScreen(s);