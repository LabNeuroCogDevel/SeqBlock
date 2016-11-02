function     [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(keys)
%KBCHECK  Overload PTB function 
%   returns fixed keys
persistent count;
if(isempty(count)), count=1; end
keyCode=zeros(1,256);
keytopush=Shuffle([32 74:76 186]);
global testkeypushes;
if(isempty(testkeypushes) || length(testkeypushes) < count)
    warning('ran out of keypushes in global "testkeypushs" on %d, using %d',...
        count,keytopush);
    
else
    keytopush=testkeypushes(count);
end

keyCode(keytopush(1))=1;
keyIsDown=1;
secs=GetSecs();
deltaSecs=0;

%WaitSecs(.05);
count=count+1;

end

