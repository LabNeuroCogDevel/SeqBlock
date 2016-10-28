function [lsum, tsum] = analyzeSeq(subjid)

logdir = 'logs/';
mydir = pwd;


if isempty(subjid)
    cd(logdir);
    [filename, pathname, filterindex] = uigetfile( ...
           {'*.mat','MAT-files (*.mat)'}, ...
            'Pick a file', '');
    cd(mydir);

    load(fullfile(pathname, filename));
else
    files = dir(fullfile(logdir, sprintf('log_%s_*.mat', subjid)));
    pathname = logdir; filename = files(1).name;
    load(fullfile(logdir, files(1).name));
end

fprintf(1, '\n%s\n\n', filename);
% summarize performance
% [runnum blocktype seq repetition eval rt1 rt2 rt3 rt4
learndata = [];
lfc.run = 1; % learn


% [runnum blocktype seq NaN eval rt1 rt2 rt3 rt4
testdata = [];

[nruns, nblock, ntrials] = size(tasklog.response);
blockTypes = {'control','choice','yolked'};

% generate data tables
for runnum = 1:nruns
    for blocki = 1:nblock
        blockType = find(strcmp(tasklog.blockSeq{runnum}{blocki}, blockTypes));
        
        reps = [0 0];
        
        for triali = 1:ntrials
            this = tasklog.response(runnum, blocki, triali);
            
            if isfield(this, 'ret') && ~isempty(this.ret)
                
                reps(this.ret.sequence) = reps(this.ret.sequence) + 1;
                
                rtvec = this.ret.rtvec;
                if length(rtvec) < 4
                    rtvec = [rtvec nan*ones(1, 4-length(rtvec))];
                end
                
                learndata(end+1,:) = [runnum blockType this.ret.sequence reps(this.ret.sequence) this.ret.respeval rtvec];
                
            end
            
            
            if isfield(this, 'test_ret') && ~isempty(this.test_ret)
                testdata(end+1,:) = [runnum blockType this.test_ret.sequence NaN this.test_ret.respeval rtvec];
            end
        end
    end
end


%% print summary - learning data

% lsum = [ cnRT4 cyRT4 yoRT4 cnAcc cyAcc yoAcc cnRT4slope cyRT4slope yoRT4slope cnAccslope cyAccslope yoAccslope] 

% filter data to look at specific parts (i.e., individual runs, etc);
%rows = find(learndata(:,1) == 2);
rows = 1:size(learndata,1);
thislearn = learndata(rows, :);

% Mean performance
fprintf(1, '\n\nLearning phase:\n\n');
fprintf(1, 'Overall %% correct:\t\t%.2f%%\n', 100*nanmean(thislearn(:,5)));
fprintf(1, 'Overall RT by keypress (ms):\t'); fprintf(1, '%.0f ', 1000*nanmean(thislearn(:,6:9))); fprintf(1, '\n');

fprintf(1, '\nPerformance by repetition:\n');
ureps = unique(thislearn(:,4));
for repi = 1:length(ureps)
    rep = ureps(repi);
    rows = find(thislearn(:,4) == rep);
    fprintf(1, '%d (n=%d): \t%.2f%% correct\t\tRT:\t', rep, numel(rows), 100*nanmean(thislearn(rows,5)));
    fprintf(1, '%.0f ', 1000*nanmean(thislearn(rows,6:9))); fprintf(1, '\n');
end

fprintf(1, '\nPerformance by block type:\n');
ublocks = unique(thislearn(:,2));
for blocki = 1:length(ublocks)
    blockType = ublocks(blocki);
    rows = find(thislearn(:,2) == blockType);
    fprintf(1, '%s (n=%d): \t%.2f%% correct\t\tRT:\t', blockTypes{blockType}, numel(rows), 100*nanmean(thislearn(rows,5)));
    fprintf(1, '%.0f ', 1000*nanmean(thislearn(rows,6:9))); fprintf(1, '\n');
end


%% print summary - test data

% filter data to look at specific parts (i.e., individual runs, etc);
%rows = find(learndata(:,1) == 2);
rows = 1:size(testdata,1);
thislearn = testdata(rows, :);

% Mean performance
fprintf(1, '\n\nTesting phase:\n\n');
fprintf(1, 'Overall %% correct:\t\t%.2f%%\n', 100*nanmean(thislearn(:,5)));
fprintf(1, 'Overall RT by keypress (ms):\t'); fprintf(1, '%.0f ', 1000*nanmean(thislearn(:,6:9))); fprintf(1, '\n');


fprintf(1, '\nPerformance by block type:\n');
ublocks = unique(thislearn(:,2));
for blocki = 1:length(ublocks)
    blockType = ublocks(blocki);
    rows = find(thislearn(:,2) == blockType);
    fprintf(1, '%s (n=%d): \t%.2f%% correct\t\tRT:\t', blockTypes{blockType}, numel(rows), 100*nanmean(thislearn(rows,5)));
    fprintf(1, '%.0f ', 1000*nanmean(thislearn(rows,6:9))); fprintf(1, '\n');
end


