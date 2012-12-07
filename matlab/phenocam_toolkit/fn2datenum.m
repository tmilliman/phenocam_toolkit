function fdtnum = fn2datenum(sitename, filename, irFlag)
%
%    Function to extract the datetime from a "standard" filename based on a
%     sitename.  Here we assume the filename format is the standard:
%
%          sitename_YYYY_MM_DD_HHNNSS.jpg
% 
%    So we just grab components from fixed positions.  If irFlag is 
%    True then the "standard" format is:
%
%          sitename_IR_YYYY_MM_DD_HHNNSS.jpg
%
%
if nargin < 3
  irFlag=false;
end

if irFlag
  prefix = strcat(sitename,'_IR');
else
  prefix = sitename;
end

% set the start of the datetime part of the name
nstart = length(prefix)+2;

% assume a 3-letter extension e.g. ".jpg"
dtstring = filename(nstart:end-4);

% extract the date-time pieces
year=str2num(dtstring(1:4));
mon=str2num(dtstring(6:7));
day=str2num(dtstring(9:10));
hours=str2num(dtstring(12:13));
mins=str2num(dtstring(14:15));
secs=str2num(dtstring(16:17));

fdtnum=datenum(year,mon,day,hours,mins,secs);

return;

