function dolog(s, func, varargin)

persistent tasklog

logfile = fullfile('logs',sprintf('log_%s_%s.txt', s.info.ID, datestr(s.info.datenum, 'yyyy.mm.dd-HH.MM.SS')));
matfile = fullfile('logs',sprintf('log_%s_%s.mat', s.info.ID, datestr(s.info.datenum, 'yyyy.mm.dd-HH.MM.SS')));

switch func
    case 'init'
        % function dolog(s, 'init')
        clear tasklog
        tasklog.response = [];
        tasklog.event = [];
        tasklog.startTime = [];

        
        fid = fopen(logfile, 'w');
        fprintf(fid, 'ID: %s\n', s.info.ID);
        fprintf(fid, 'Date: %s\n', datestr(s.info.datenum, 'yyyy.mm.dd-HH.MM.SS'));
        fprintf(fid, '\n\n');
        fclose(fid);
        
        
    case 'response'
        % function dolog(s, 'response', runnum, blocknum, trialnum, seqnum, evtype, response, eval, rtvec)
        
        runnum = varargin{1};
        blocknum = varargin{2};
        trialnum = varargin{3};
        seqnum = varargin{4};
        evtype = varargin{5};
        resp = varargin{6};
        respeval = varargin{7};
        rtvec = varargin{8};
        
        tasklog.response(runnum, blocknum, trialnum).(evtype).response = resp;
        tasklog.response(runnum, blocknum, trialnum).(evtype).respeval = respeval;
        tasklog.response(runnum, blocknum, trialnum).(evtype).rtvec = rtvec;
        tasklog.response(runnum, blocknum, trialnum).(evtype).sequence = seqnum;
        
        fid = fopen(logfile, 'a');
        fprintf(fid, '%s,Run %d,Block %d,Trial %d,Sequence %d,Response %s,Eval %d,RT ', evtype, runnum, blocknum, trialnum, seqnum, resp, respeval);
        fprintf(fid, '%.4f ', rtvec);
        fprintf(fid, '\n');
        fclose(fid);
        
        tasklog.response(runnum, blocknum, trialnum).(evtype)
        
    case 'startTime'
        % function dolog(s, 'startTime', runnum, evtime, seqi, blockSeq)
        runnum = varargin{1};
        evtime = varargin{2};
        seqi = varargin{3};
        blockSeq = varargin{4};
        
        tasklog.startTime(runnum) = evtime;
        tasklog.seqi(runnum) = seqi;
        tasklog.evseq(runnum) = s.blocks.bestSeqs(seqi);
        tasklog.blockSeq{runnum} = blockSeq;
        
        fid = fopen(logfile, 'a');
        fprintf(fid, 'Run %d,StartTime %0f\n',evtime);
        fprintf(fid, 'Sequence %d (%d)\n', seqi, s.blocks.bestSeqs(seqi));
        fprintf(fid, 'Block order: '); fprintf(fid, '%s ', blockSeq{:}); fprintf(fid, '\n');
        fclose(fid);
        
    case 'event'
        % function dolog(s, 'event', runnum, blocknum, trialnum, evtype, evtime
        % evtime is raw time (a la GetSecs), not adjusted
        runnum = varargin{1};
        blocknum = varargin{2};
        trialnum = varargin{3};
        evtype = varargin{4};
        evtime = varargin{5} - tasklog.startTime(runnum);
        
        tasklog.event(runnum, blocknum, trialnum).(evtype) = evtime;
        
        fid = fopen(logfile, 'a');
        fprintf(fid, '%s,Run %d,Block %d,Trial %d,Event %s,%.4f\n', evtype, runnum, blocknum, trialnum, evtype, evtime);
        fclose(fid);
        
end

save(matfile, 's', 'tasklog');