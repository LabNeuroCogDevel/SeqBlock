function ev = loadEvents(seqnum, s)

% stims/seq_02580_01_cue1.1D
% stims/seq_02580_02_view1.1D
% stims/seq_02580_03_ret1.1D
% stims/seq_02580_04_cue2.1D
% stims/seq_02580_05_view2.1D
% stims/seq_02580_06_ret2.1D
% stims/seq_02580_07_cue3.1D
% stims/seq_02580_08_view3.1D
% stims/seq_02580_09_ret3.1D
% stims/seq_02580_10_cue4.1D
% stims/seq_02580_11_view4.1D
% stims/seq_02580_12_ret4.1D
% stims/seq_02580_13_cue5.1D
% stims/seq_02580_14_view5.1D
% stims/seq_02580_15_ret5.1D
% stims/seq_02580_16_cue6.1D
% stims/seq_02580_17_view6.1D
% stims/seq_02580_18_ret6.1D
% stims/seq_02580_19_cue7.1D
% stims/seq_02580_20_view7.1D
% stims/seq_02580_21_ret7.1D
% stims/seq_02580_22_cue8.1D
% stims/seq_02580_23_view8.1D
% stims/seq_02580_24_ret8.1D
% stims/seq_02580_25_test_cue1.1D
% stims/seq_02580_26_test_ret1.1D
% stims/seq_02580_27_test_cue2.1D
% stims/seq_02580_28_test_ret2.1D
% stims/seq_02580_29_fix.1D

ev = [];
ev.info.seqnum = seqnum;


for triali = 1:s.trials.num
    
%    ev.trial(triali) = [];
    ev.trial(triali).cue = dlmread( sprintf('stims/seq_%.05d_%02d_cue%d.1D', seqnum, 3*(triali-1)+1, triali));
    ev.trial(triali).view = dlmread( sprintf('stims/seq_%.05d_%02d_view%d.1D', seqnum, 3*(triali-1)+2, triali));
    ev.trial(triali).ret = dlmread( sprintf('stims/seq_%.05d_%02d_ret%d.1D', seqnum, 3*(triali-1)+3, triali));
    
end

ev.test(1).cue = dlmread( sprintf('stims/seq_%.05d_25_test_cue1.1D', seqnum));
ev.test(1).ret = dlmread( sprintf('stims/seq_%.05d_26_test_ret1.1D', seqnum));
ev.test(2).cue = dlmread( sprintf('stims/seq_%.05d_27_test_cue2.1D', seqnum));
ev.test(2).ret = dlmread( sprintf('stims/seq_%.05d_28_test_ret2.1D', seqnum));


allevs.times = [];
allevs.block = [];
allevs.trial = [];
allevs.type = {};

for blocki = 1:s.blocks.num
    for triali = 1:s.trials.num
    
        % cue
        allevs.times(end+1) = ev.trial(triali).cue(blocki);
        allevs.block(end+1) = blocki;
        allevs.trial(end+1) = triali;
        allevs.type{end+1} = 'cue';
        
        % view
        allevs.times(end+1) = ev.trial(triali).view(blocki);
        allevs.block(end+1) = blocki;
        allevs.trial(end+1) = triali;
        allevs.type{end+1} = 'view';
        
        % ret
        allevs.times(end+1) = ev.trial(triali).ret(blocki);
        allevs.block(end+1) = blocki;
        allevs.trial(end+1) = triali;
        allevs.type{end+1} = 'ret';
    end

    
    % cue
    allevs.times(end+1) = ev.test(1).cue(blocki);
    allevs.block(end+1) = blocki;
    allevs.trial(end+1) = 1;
    allevs.type{end+1} = 'test_cue';

    % ret
    allevs.times(end+1) = ev.test(1).ret(blocki);
    allevs.block(end+1) = blocki;
    allevs.trial(end+1) = 1;
    allevs.type{end+1} = 'test_ret';
    
    % cue
    allevs.times(end+1) = ev.test(2).cue(blocki);
    allevs.block(end+1) = blocki;
    allevs.trial(end+1) = 2;
    allevs.type{end+1} = 'test_cue';

    % ret
    allevs.times(end+1) = ev.test(2).ret(blocki);
    allevs.block(end+1) = blocki;
    allevs.trial(end+1) = 2;
    allevs.type{end+1} = 'test_ret';
end

ev.allevs = allevs;