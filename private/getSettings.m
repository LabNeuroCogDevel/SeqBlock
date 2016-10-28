function s = getSettings(s, subjID)

s.visittype='behave';

s.info.ID = subjID;
s.info.datenum = now;
s.info.numruns = 5;

s.blocks.num = 2;
s.blocks.bestSeqs = [491	735	712	337	115	568	90	16	662	86	934	951	683	751	219	847	3	721	81];
s.blocks.types = {'control','choice','yolked'};

s.totalruns  = 5;
s.trials.num = 8;


s.dur.cue = 2;
s.dur.cueRespTime = 1.5;
s.dur.view = 2;
s.dur.ret = 3;

s.dur.test_cue = 2;
s.dur.test_ret = 3;

s.params.seqLength = 4;
s.params.seqPerBlock = 2;

%s.responses.keyNames = {'1!','2@','3#','4$','5%','6^','7&','8*'};

s.display.config = '5 fingers'; % 'one row', 'two rows'
switch s.display.config
    case 'one row'
        s.display.targLocs.relative.x = [.1:.1:.4 .6:.1:.9];
        s.display.targLocs.relative.y = [.5 .5 .5 .5 .5 .5 .5 .5];
        s.display.targRadius = 50;
        s.responses.keyNames = {'1!','2@','3#','4$','7&','8*','9(','0)'};
        s.responses.keyMap = [1:8];
        s.responses.keyLabels = {'1','2','3','4','5','6','7','8'};
        s.responses.choiceKeys = [4 5];
        s.responses.numTargets = 8;
        badseqs = {'1234','2345','3456','4567','5678','4321','5432','6543','7654','8765'};

    case 'two rows'
        s.display.targLocs.relative.x = [.25 .4 .6 .75 .25 .4 .6 .75];
        s.display.targLocs.relative.y = [.25 .25 .25 .25 .75 .75 .75 .75];
        s.display.targRadius = 100;
        s.responses.keyNames = {'1!','2@','3#','4$','7&','8*','9(','0)'};
        s.responses.keyMap = [1:8];
        s.responses.keyLabels = {'1','2','3','4','7','8','9','0'};
        s.responses.choiceKeys = [4 5];
        s.responses.numTargets = 8;
        badseqs = {'1234','2345','3456','4567','5678','4321','5432','6543','7654','8765'};
        
    case 'one hand'
        s.display.targLocs.relative.x = [.2 .4 .6 .8];
        s.display.targLocs.relative.y = [.5 .5 .5 .5];
        s.display.targRadius = 120;
%        s.responses.keyNames = {'7&','8*','9(','0)'};
        s.responses.keyNames = {'1!','2@','3#','4$'};
        s.responses.keyMap = [1:4];
        s.responses.keyLabels = {'1','2','3','4'};
        s.responses.choiceKeys = [1 2];
        s.responses.numTargets = 4;
        badseqs = {'1234','4321'};
        
    case '6 fingers one row'
        s.display.targLocs.relative.x = [.18 .3 .42 .58 .7 .82];
        s.display.targLocs.relative.y = [.5 .5 .5 .5 .5 .5];
        s.display.targRadius = 90;
%        s.responses.keyNames = {'7&','8*','9(','0)'};
        s.responses.keyNames = {'1!','2@','3#','7&','8*','9('};
        s.responses.keyMap = [1:6];
        s.responses.keyLabels = {'1','2','3','7','8','9'};
        s.responses.choiceKeys = [3 4];
        s.responses.numTargets = 6;
        badseqs = {'1234','2345','3456','4321','5432','6543'};
        
    case '5 fingers'
        s.display.targLocs.relative.x = [.25 .37 .5 .6 .7];
        s.display.targLocs.relative.y = [.65 .4 .35 .4 .5];
        s.display.targRadius = 70;
%        s.responses.keyNames = {'7&','8*','9(','0)'};
        s.responses.keyNames = {'space','j','k','l',';'}; % a la KbName
        s.responses.keyLabels = {'space','j','k','l',';'};
        s.responses.keyMap = [1:5];
        s.responses.choiceKeys = [2 3];
        s.responses.numTargets = 5;      
        badseqs = {'1234','2345','4321','5432'};
        
end
s.display.targLocs.x = [];
s.display.targLocs.y = [];
s.display.lineWidth = 3;

s.display.viewColor = [1 1 1]*256;
s.display.retColor = [224 163 46];
s.display.retDispTime = 0.2;
s.display.mode = 'both'; % {'text','graphics','both'}
s.display.res = [];
s.display.backgroundColor = [.2 .2 .2]*256;
s.display.textColor = [1 1 1]*256;
s.display.w = [];

s.responses.cueKeys = {s.responses.keyNames{s.responses.choiceKeys}};
s.responses.cueKeyMap = [1:2];


s.cues.dir = 'cueimgs';
s.cues.size = 250;
s.cues.fadeLevel = 0.3;
s.cues.targLocs.relative.x = [.35 .65];
s.cues.targLocs.relative.y = [.5 .5];
s.cues.selectColor = [224 163 46];
s.cues.forceSelectColor = s.cues.selectColor/1.6;
s.cues.testColor = [70 148 73];
s.cues.testPromptColor = s.cues.testColor/1.6;

% pregenerate all sequences
allseqs = [];
s.sequences = zeros(s.blocks.num, s.params.seqPerBlock);

nchoices = 7;
s.choiceHistory = nan*ones(nchoices, s.trials.num); % # runs + 2
% preload first two choice histories
s.choiceHistory(1,:) = Shuffle([1 1 1 1 2 2 2 2]);
s.choiceHistory(2,:) = Shuffle([1 1 1 1 2 2 2 2]);
s.choiceHistoryUsed = zeros(1,nchoices);

for runnum = 1:s.info.numruns
    for blocki = 1:s.blocks.num
        for seqi = 1:s.params.seqPerBlock

            repeated = 1;
            while repeated | badseq
                randorder = Shuffle( sprintf('%d',1:s.responses.numTargets) );
                s.sequences(runnum, blocki, seqi) = str2double( randorder(1:s.params.seqLength) );

                if ~isempty(allseqs)
                    repeated = any(s.sequences(runnum, blocki, seqi) == allseqs);
                else
                    repeated = 0;
                end
                
                badseq = any(strcmp(s.sequences(runnum, blocki, seqi), badseqs));

            end

            allseqs(end+1) = s.sequences(runnum, blocki, seqi);
        end
    end
end

%% flags -- checks for when something happened

% have initilization functions been run?
% these should all be set before run1 starts
s.flags.initScreen=0;   
s.flags.loadCues=0;     

% used in seqBlock to not overwrite settings
% TODO: should that conditional go at the top of this function?
s.flags.keepSettings=1;

%% log what we've done
allseqs
dolog(s, 'init');


