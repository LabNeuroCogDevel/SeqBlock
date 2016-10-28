function showBlockType(s,when,evType)
        endTime = when + s.dur.showBlockType;
        
        %Choice or fixed
        disptext=evType;
        if(strmatch(evType,'yolked'))
            disptext='Fixed';
        elseif(strmatch(evType,'choice'))
            disptext='Choice';
        end
        
        DrawFormattedText(s.display.w, disptext,'center','center');
        Screen('Flip', s.display.w);
        
        % wait until we're done
        while(GetSecs() < endTime )
           WaitSecs(0.005);
        end

end