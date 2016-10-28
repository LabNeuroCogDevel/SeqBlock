function s = initScreen(s)

    if strcmp(s.display.mode, 'text')
        s.display.w = []; s.display.res = [];
        return;
    end

     % unix linux windows, who cares :)
     KbName('UnifyKeyNames')
     
     % Removes the blue screen flash and minimize extraneous warnings.
     % http://psychtoolbox.org/FaqWarningPrefs
     Screen('Preference', 'Verbosity', 2); % remove cli startup message 
     Screen('Preference', 'VisualDebugLevel', 3); % remove  visual logo
     %Screen('Preference', 'SuppressAllWarnings', 1);

     Screen('Preference', 'SkipSyncTests', 1);
     
     % Open a new window.
     %w = Screen('OpenWindow', screennum,backgroundColor, [0 0 screenResolution]);
     % add antialiasing by using 4
     screennum=max(Screen('Screens'));
     
     % open a PTB screen to draw thigns on
     [s.display.w, s.display.res] = Screen('OpenWindow', screennum, s.display.backgroundColor);
     

     %permit transparency
     Screen('BlendFunction', s.display.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

     % set font
     v=version();
     v=str2double(v(1:3));
     % if newer or are using octave
     if v>=8 || exist('OCTAVE_VERSION','builtin')
         Screen('TextFont', s.display.w, 'Arial');
         Screen('TextSize', s.display.w, 26);
     else
        % older matlab+linux:
        %Screen('TextFont', w, '-misc-fixed-bold-r-normal--13-100-100-100-c-70-iso8859-1');
        Screen('TextFont', s.display.w, '-misc-fixed-bold-r-normal--0-0-100-100-c-0-iso8859-16');
     end
    

     % Set process priority to max to minimize lag or sharing process time with other processes.
     Priority(MaxPriority(s.display.w));
    
     %do not echo keystrokes to MATLAB
     %ListenChar(2); %leaving out for now because crashing at MRRC
    
     HideCursor;


    % get absolute map locations
    s.display.targLocs.x = s.display.targLocs.relative.x * s.display.res(3);
    s.display.targLocs.y = s.display.targLocs.relative.y * s.display.res(4);

    s.cues.targLocs.x = s.cues.targLocs.relative.x * s.display.res(3);
    s.cues.targLocs.y = s.cues.targLocs.relative.y * s.display.res(4);
    
    s.cues.rect{1} = round([s.cues.targLocs.x(1)-s.cues.size/2 s.cues.targLocs.y(1)-s.cues.size/2 s.cues.targLocs.x(1)+s.cues.size/2 s.cues.targLocs.y(1)+s.cues.size/2]);
    s.cues.rect{2} = round([s.cues.targLocs.x(2)-s.cues.size/2 s.cues.targLocs.y(2)-s.cues.size/2 s.cues.targLocs.x(2)+s.cues.size/2 s.cues.targLocs.y(2)+s.cues.size/2]);
   
    s.flags.initScreen=1;
end