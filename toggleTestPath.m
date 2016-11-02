function whichisset = toggleTestPath(whichtoset)
% TOGGLETESTPATH add or remove overload directory to/from path
%    useful for testing KbWait and overwritting 


  %% overload path is relative to this mfile
  thisdir = fileparts(mfilename('fullpath'));
  overloadpath = fullfile(thisdir,'overload');
  
  % make sure we have overload functions
  if ~exist(overloadpath,'dir'),  error('no path to %s', overloadpath); end
  
  %% figure out what toggle means if nothing is provided
  if nargin <1
      % need to escape all windows slashes
      pat=regexprep(overloadpath,'\\','\\\\');
      % seach path for overlad directory
      if isempty(regexp(path(),pat,'ONCE'))
          whichtoset='test';
      else
          whichtoset='notest';
      end
  end
  
  %% add or remove path
  % matlab seems to be nice and not allow
  % multiple instances of the same path
  if strncmp(whichtoset,'test',4)
      addpath(overloadpath)
  else
      rmpath(overloadpath)
  end
  
  % variable copy for clarity
  whichisset=whichtoset;
end