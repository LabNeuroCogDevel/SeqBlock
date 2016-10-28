function s = SeqBlock(subjID, runnum, s, seqi)

% Initialize
if nargin < 3
    s = [];
end

% reset settings if we are on run 1
%if runnum == 1
if isempty(s) || ~s.flags.keepSettings
    s = getSettings([], subjID);
    % dolog(s, 'init'); % done in getSettings
end

if nargin < 4 || isempty(seqi)
    seqi = randi(length(s.blocks.bestSeqs), [1 1]);
end

% Select event timing for this run
seqnum = s.blocks.bestSeqs(seqi);
ev = loadEvents(seqnum, s);
printEvents(ev, s);
sequences = s.sequences




% Select block order for this run
%blockSeq = Shuffle(s.blocks.types);
blockSeq = {s.blocks.types{Shuffle([2 3])}}; 

% Initialize screen and textures, show instructions, only on first run
% only do this if settings says we haven't yet 
%  probably b/c we are on run1
% TODO: move these checks into the actual functions being called?

% if runnum==1
if ~ s.flags.initScreen, s = initScreen(s); end
if ~ s.flags.loadCues,   s = loadCues(s)  ; end

% instruction display probably handled by wrapper
if runnum==1
  %instructions(s);
end


% Wait for scanner to start
startTime = waitForTrigger(s);
clearScreen(s);

blockSeq
dolog(s, 'startTime', runnum, startTime, seqi, blockSeq);

evi = 1;
done = 0;
allevs = ev.allevs;

trialseq = nan;

% Loop over all events (based on 1D files)
while ~done
    
    % next event = evi
    
    % prepare next event
    %   Nothing here yet.
    
    % wait until next event
    while (GetSecs - startTime) < allevs.times(evi)
        WaitSecs(0.001);
    end
    
    % do next event
    evTime = GetSecs - startTime;
    times.ev(evi) = evTime;
    
    %fprintf(1, '%.2f: Doing event %d (block %d, trial %d, type %s)\n', evTime, evi, allevs.block(evi), allevs.trial(evi), allevs.type{evi});
    [s, trialseq] = doEvent(s, startTime, runnum, blockSeq, trialseq, allevs, evi);
    
    % advance counter to next event
    evi = evi + 1;
    if evi > length(allevs.times)
        done = 1;
    end
end

% clean up if we're all done
if runnum == s.totalruns
    clearScreen(s);
end