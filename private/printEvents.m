function printEvents(ev, s)

    cueISIs = [];
    viewISIs = [];
    testISIs = [];

    for evi = 1:length(ev.allevs.times)
        
        if evi < length(ev.allevs.times)
            isi = ev.allevs.times(evi+1) - (ev.allevs.times(evi) + s.dur.(ev.allevs.type{evi}));
        else
            isi = 0;
        end
        
        switch ev.allevs.type{evi}
            case 'cue'
                cueISIs(end+1) = isi;
            case 'view'
                viewISIs(end+1) = isi;
            case 'ret'
                testISIs(end+1) = isi;
        end
        
        fprintf(1, '%02d:\t%.1f\tblock=%d\ttrial=%d\t%s%s\tdur=%d\tisi=%.1f\n', ...
            evi, ev.allevs.times(evi), ev.allevs.block(evi), ev.allevs.trial(evi), ...
            ev.allevs.type{evi},repmat(' ', [1 10-length(ev.allevs.type{evi})]), ...
            s.dur.(ev.allevs.type{evi}), isi);
    end
    

    fprintf(1, '\n\nCue:  %.1f - %.1f\tmean = %.1f\tstd = %.1f\n', min(cueISIs), max(cueISIs), mean(cueISIs), std(cueISIs));
    fprintf(1, 'View: %.1f - %.1f\tmean = %.1f\tstd = %.1f\n', min(viewISIs), max(viewISIs), mean(viewISIs), std(viewISIs));
    fprintf(1, 'Test: %.1f - %.1f\tmean = %.1f\tstd = %.1f\n', min(testISIs), max(testISIs), mean(testISIs), std(testISIs));
    
end

