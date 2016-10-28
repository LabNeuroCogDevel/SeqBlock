function [s, seqOrder] = getCueChoice(s, runnum, blocki, triali, seqOrder, startTime, evTime, blockType, evType)

for seq = 1:2
    tex(seq) = s.cues.instruct_texture(seq); 
    texFade(seq) = s.cues.instruct_texture(seq);
end

% tex and faded created by loadCues and saved into s
% size(s.cues.texture) =     5     2     2
% size(tex)= 1 2 --probably dont need to reshape, but looks nice debugging
tex     = reshape( s.cues.texture(runnum,blocki,:),      1,2);
texFade = reshape( s.cues.texture_faded(runnum,blocki,:),1,2);

if strcmp(evType, 'instructions') | strcmp(evType, 'instructions_test')
    
    if strcmp(evType, 'test_cue')
        forceSelect = triali;
    elseif strcmp(blockType, 'choice')
        forceSelect = [];
    else
        forceSelect = randi(2, [1 1]);
    end

    resptime = 3;
    
else
    
    resptime = s.dur.cueRespTime;

    if strcmp(evType, 'test_cue')
        forceSelect = seqOrder(triali);
        
    elseif strcmp(blockType, 'choice')
        forceSelect = [];
    else
        forceSelect = seqOrder(triali);

    end
end

% show choices
seqs = 'AB';
seqVis = repmat('.', [1 8]);
seqVis(4) = seqs(1);
seqVis(5) = seqs(2);
for seqvisi = 1:length(seqVis)
    fprintf(1, '%s\t', seqVis(seqvisi));
    if seqvisi == 4
        fprintf(1, '|\t');
    end
end
fprintf(1, '\n');

% get input
%s.responses.cueKeys = {s.responses.keyNames{[4 5]}};
%s.responses.cueKeyMap = [1:2];

if strcmp(evType, 'cue') | strcmp(evType, 'instructions')
    boxColor = s.cues.forceSelectColor; %s.cues.selectColor;
else
    boxColor = s.cues.testPromptColor;
end

if any(strcmp(s.display.mode, {'graphics','both'}))
    if ~isempty(forceSelect)
        Screen('FillRect', s.display.w, boxColor, s.cues.rect{forceSelect} + 10*[-1 -1 1 1] );
    end
    Screen('DrawTexture', s.display.w, tex(1), [], s.cues.rect{1});
    Screen('DrawTexture', s.display.w, tex(2), [], s.cues.rect{2});
    evtime = Screen('Flip', s.display.w);
    if ~strcmp(evType, 'instructions') & ~strcmp(evType, 'instructions_test')
        dolog(s, 'event', runnum, blocki, triali, sprintf('%s_showcue', evType), evtime)
    end
end



valid = 0; done = 0;
respEndTime = startTime + evTime + resptime;

while ~done

    if GetSecs >= respEndTime
        done = 1;
    end

    if done == 1
        break;
    end

    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([]);
%        [secs, keyCode, deltaSecs] = KbWait([], 0, startTime + evTime + s.dur.cueRespTime);
    if ~keyIsDown
        WaitSecs(0.001);
        continue;
    end

    keyName = KbName(find(keyCode, 1, 'first'));

    if any( strcmp(keyName, s.responses.cueKeys) )
        respi = find(strcmp(keyName, s.responses.cueKeys), 1, 'first');
        selection = s.responses.cueKeyMap(respi);

        if ~isempty(forceSelect) % not a choice block
            if selection ~= forceSelect % didn't pick the right one, ignore
                continue
            end
        end

        valid = 1; done = 1;
        if ~strcmp(evType, 'instructions') & ~strcmp(evType, 'instructions_test')
            dolog(s, 'event', runnum, blocki, triali, 'cueselect', secs);
        end
    end
end

if ~valid
    if ~isempty(forceSelect)
        selection = forceSelect;
    else
        selection = randi(2, [1 1]);
    end
    fprintf(1, 'No response given, selecting %d\n', selection);
end
    

if strcmp(evType, 'cue') | strcmp(evType, 'instructions')
    boxColor = s.cues.selectColor;
else % test or instructions_test
    boxColor = s.cues.testColor;
end


tex(3-selection) = texFade(3-selection);
if any(strcmp(s.display.mode, {'graphics','both'}))
    Screen('FillRect', s.display.w, boxColor, s.cues.rect{selection} + 10*[-1 -1 1 1] );
    Screen('DrawTexture', s.display.w, tex(1), [], s.cues.rect{1});
    Screen('DrawTexture', s.display.w, tex(2), [], s.cues.rect{2});
    Screen('Flip', s.display.w);
end

if strcmp(blockType, 'choice')
    seqOrder(triali) = selection; 
    s.choiceHistory(runnum+2, triali) = seqOrder(triali);
end

while GetSecs < startTime + evTime + s.dur.cue
    WaitSecs(0.005);
end

clearScreen(s);