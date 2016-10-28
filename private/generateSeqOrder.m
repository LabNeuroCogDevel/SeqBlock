function [s, seqOrder] = generateSeqOrder(s, blockType, runnum, evType)

evType

switch evType
    case 'cue'
        switch blockType

            case 'control'
                seqOrder = [1 1 1 1 2 2 2 2];
                if rand>0.5
                    seqOrder = flipdim(seqOrder,2);
                end
                fprintf(1, 'Control block, order: '); fprintf('%d ', seqOrder); fprintf('\n');


            case 'choice'
                seqOrder = repmat(nan, [1 s.trials.num]);
                s.choiceHistory(runnum+2, :) = seqOrder; % should be initialized this way anyway
                fprintf(1, 'Choice block, order TBD\n');


            case 'yolked'
                avail = find(~isnan(s.choiceHistory(:,1)') & ~s.choiceHistoryUsed);
                thisHist = avail(randi(length(avail), [1 1]));

                s.choiceHistoryUsed(thisHist) = 1;
                seqOrder = s.choiceHistory(thisHist, :);
                fprintf(1, 'Yoked block, based on entry %d, order: ', thisHist); fprintf('%d ', seqOrder); fprintf('\n');

        end

    case 'test_cue'
        seqOrder = Shuffle([1 2]); % should this be yolked too?
end