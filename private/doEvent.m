function [s, seqOrder] = doEvent(s, startTime, runnum, blockseq, seqOrder, allevs, evi)

evType = allevs.type{evi};
blocki = allevs.block(evi);
triali = allevs.trial(evi);
evTime = allevs.times(evi);
blockType = blockseq{blocki};

if triali == 1 & any(strcmp(evType, {'cue','test_cue'}))
    [s, seqOrder] = generateSeqOrder(s, blockType, runnum, evType);
end

thisTrialSeq = seqOrder(triali);

switch evType
    
    case 'cue'
        endTime = startTime + evTime + s.dur.cue;
        % Get cue selection
        [s, seqOrder] = getCueChoice(s, runnum, blocki, triali, seqOrder, startTime, evTime, blockType, evType);
        thisTrialSeq = seqOrder(triali);
        
    case 'test_cue'
        [s, seqOrder] = getCueChoice(s, runnum, blocki, triali, seqOrder, startTime, evTime, blockType, evType);
%        endTime = startTime + evTime + s.dur.cue;
%        showCue(s, blocki, thisTrialSeq, evType, endTime);

    case 'view'
        viewSequence(s, runnum, blocki, triali, thisTrialSeq);

    case {'ret','test_ret'}
        endTime = startTime + evTime + s.dur.ret;
        [s, retseq, eval, rtvec] = testSequence(s, runnum, blocki, triali,thisTrialSeq, endTime, evType);
        
        
        
end

