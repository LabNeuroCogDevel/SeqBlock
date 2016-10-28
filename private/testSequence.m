function [s, retseq, eval, rtvec] = testSequence(s, runnum, blocki, triali, thisTrialSeq, endTime, evType)

    if thisTrialSeq == -1 % instructions
        instruct = 1;
        size(s.sequences)
        [nruns, nblock, nseq] = size(s.sequences);
        runi = randi(nruns, [1 1]);
        blocki = randi(nblock, [1 1]);
        thisTrialSeq = randi(nseq, [1 1]);
        
        seq = num2str(s.sequences(runi, blocki, thisTrialSeq));

    else
        
        instruct = 0;
        seq = num2str(s.sequences(runnum, blocki, thisTrialSeq));
    end
    
    
    fprintf(1,'Repeat sequence:\n');
    promptTime = GetSecs;
    
    numValid = 0;
    retseq = '';
    rtvec = [];

    lastResp = NaN;
    lastRespTime = NaN;

    if any(strcmp(s.display.mode, {'graphics','both'}))
        fliptime = showTargets(s, s.display.retColor);
    end
    
    done = 0;

    if ~instruct
        dolog(s, 'event', runnum, blocki, triali, sprintf('%s_testsequence', evType), fliptime);
    end
    
    while ~done
        %(numValid<4 | GetSecs<lastRespTime+s.display.retDispTime) & (GetSecs < endTime)
        if numValid >= 4 & GetSecs>lastRespTime+s.display.retDispTime
            done = 1;
        end

        if GetSecs >= endTime
            done = 1;
        end

        if done == 1
            break;
        end
        
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([]); %, 0, startTime + evTime + s.dur.ret);

        % show last valid response, unless enough time has elapsed
        %GetSecs - lastRespTime
        if any(strcmp(s.display.mode, {'graphics','both'}))
            if ~isnan(lastResp) && GetSecs<(lastRespTime + s.display.retDispTime)
                fliptime = showTargets(s, s.display.retColor, s.display.viewColor, lastResp);
            else
                fliptime = showTargets(s, s.display.retColor);
            end
        end

        
        
        if ~keyIsDown
            WaitSecs(0.001);
            continue
        end

        keyName = KbName(find(keyCode, 1, 'first'));

        if any( strcmp(keyName, s.responses.keyNames) )

            respi = find(strcmp(keyName, s.responses.keyNames), 1, 'first');
            if isempty(respi)
                % invalid key, ignore it and keep watching
                continue
            end

            resp = s.responses.keyMap(respi);

            if ~isempty(strfind(retseq, num2str(resp)))
                % already detected this response, probably a held button
                continue
            else
                % store reaction time for this trial
                rtvec(end+1) = GetSecs - promptTime;
                
                retseq = [retseq num2str(resp)];
                numValid = numValid + 1;

                if any(strcmp(s.display.mode, {'graphics','both'}))
                    lastResp = resp;
                    lastRespTime = GetSecs;
                end

                if any(strcmp(s.display.mode, {'text','both'}))
                    seqVis = repmat('.', [1 s.responses.numTargets]);
                    seqVis(resp) = 'X';
                    for seqvisi = 1:length(seqVis)
                        fprintf(1, '%s\t', seqVis(seqvisi));
                        if seqvisi == s.responses.numTargets/2;
                            fprintf(1, '|\t');
                        end
                    end
                    fprintf(1, '\n');
                end
            end
        end

        WaitSecs(0.001);


    end

    % function dolog(s, 'response', runnum, blocknum, trialnum, seqnum, evtype, response, eval, rtvec)
    if ~instruct
        dolog(s, 'response', runnum, blocki, triali, thisTrialSeq, evType, retseq, strcmp(seq, retseq), rtvec);

        if strcmp(seq, retseq)
            fprintf(1, 'Correct!\n');
            eval = 1;
        else
            fprintf(1, 'Incorrect (expected=%s, got=%s)\n', seq, retseq);
            eval = 0;
        end        
    end
    
    clearScreen(s);
%    showTargets(s, s.display.retColor);


    fprintf(1, '\n+\n');