function viewSequence(s, runnum, blocki, triali, thisTrialSeq)

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
seq


    viewTime = s.dur.view / s.params.seqLength;
    for i = 1:s.params.seqLength

        seqVis = repmat('.', [1 s.responses.numTargets]);
        seqVis(str2double(seq(i))) = 'X';
        for seqvisi = 1:length(seqVis)
            fprintf(1, '%s\t', seqVis(seqvisi));
            if seqvisi == s.responses.numTargets/2
                fprintf(1, '|\t');
            end
        end
        fprintf(1, '\n');
%            fprintf(1, '%s\t', seq(i));

        if any(strcmp(s.display.mode, {'graphics','both'}))
            fliptime = showTargets(s, s.display.viewColor, s.display.viewColor, str2double(seq(i)));
            if i == 1 && ~instruct
                dolog(s, 'event', runnum, blocki, triali, 'viewsequence', fliptime);
            end
        end
        
        
        
        
        WaitSecs(viewTime);
        
        % clear targets
        showTargets(s, s.display.viewColor);

    end
    fprintf(1, '\n+\n');
    
    showFix(s);