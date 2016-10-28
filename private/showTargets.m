function fliptime = showTargets(s, lineColor, fillColor, fillWhich)

if nargin < 3
    fillWhich = [];
    fillColor = [];
end

if strcmp(s.display.mode, 'text')
    return;
end


for targi = 1:length(s.display.targLocs.x)

    cx = s.display.targLocs.x(targi);
    cy = s.display.targLocs.y(targi);

    rect = [cx-s.display.targRadius cy-s.display.targRadius cx+s.display.targRadius cy+s.display.targRadius];

    Screen('FrameOval', s.display.w, lineColor, rect, s.display.lineWidth, s.display.lineWidth);

    if targi == fillWhich
        Screen('FillOval', s.display.w, fillColor, rect, 2*s.display.targRadius);
    end
end
fliptime = Screen('Flip', s.display.w);

%s.display.lineWidth
%    Screen('FrameOval', windowPtr [,color] [,rect] [,penWidth] [,penHeight] [,penMode]);
%    Screen('FillOval', windowPtr [,color] [,rect] [,perfectUpToMaxDiameter]);
