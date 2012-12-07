function imglist = getsiteimglist(archive_dir,sitename,startDT,endDT,getIR)
%
% Returns a list of imagepath names for ALL images in 
% archive for specified site.  Optional arguments:
%   startDT : Start datetime for image list
%   endDT   : End datetime for image list
%   getIR   : If set to true only return IR images.
% 
if nargin < 2
  usage();
  return;
elseif nargin == 2
  startDT=datenum(1990,1,1);
  endDT=now;
  getIR=false;
elseif nargin == 3
  endDT=now;
  getIR=false;
elseif nargin == 4
  getIR=false;
end

dbg=0;

if dbg
  disp(archive_dir);
  disp(sitename);
  disp(datestr(startDT));
  disp(datestr(endDT));
  if getIR
    disp('getIR: true');
  else
    disp('getIR: false');
  end
end

prefix=sitename;
if getIR
  prefix=strcat(prefix,'_IR');
end
nprefix=length(prefix);


% get start year and month
startDV = datevec(startDT);
startYear = startDV(1);
startMonth = startDV(2);

% get end year and month
endDV = datevec(endDT);
endYear = endDV(1);
endMonth = endDV(2);

% create output list
imglist=cell(1);
listlen=int32(0);

% set root for site images
sitepath = fullfile(archive_dir,sitename);
if ~exist(sitepath)
  disp(['Cannot find: ',sitepath]);
  return
end

% get a list of files in the site directory
yeardirs = dir(sitepath);

digit4 = [1, 1, 1, 1];
digit2 = [1, 1];

% loop over all files in sitepath
nydirs = length(yeardirs);
for nydir = 1:nydirs
  yeardir = yeardirs(nydir).name;
  yearpath = fullfile(sitepath,yeardir);
  
  % check if yeardir is a directory
  if ~isdir(yearpath)
    continue
  end
  
  % check if yeardir could be a 4-digit year.  if not skip
  if length(yeardir) ~= 4
    continue
  end
  if isstrprop(yeardir,'digit') ~= digit4
    continue;
  end
  
  % check if we're in specified year range
  if ( str2num(yeardir) < startYear ) | ...
	( str2num(yeardir) > endYear )
    continue;
  end

  
  % get a list of all files in the year directory
  mondirs = dir(yearpath);
    
  % loop over all month dirs
  nmdirs = length(mondirs);
  for nmdir = 1:nmdirs
    mondir = mondirs(nmdir).name;
    monpath = fullfile(yearpath,mondir);
    
    % check that monpath is directory
    if ~isdir(monpath)
      continue;
    end
    
    % check that mondir could be a 2-digit month
    if length(mondir) ~= 2
      continue
    end
    if isstrprop(mondir,'digit') ~= digit2
      continue;
    end
    
    % check start year/month
    if (str2num(yeardir) == startYear) && ...
	  str2num(mondir) < startMonth
      continue;
    end
    
    % check end year/month
    if(str2num(yeardir) == endYear) && ...
	  (str2num(mondir) > endMonth)
      continue
    end
    
    % okay get a listing of the month directory
    imgfiles=dir(monpath);
    
    nentry=length(imgfiles);
    for nimg = 1:nentry
      imgname = imgfiles(nimg).name;
      imgpath = fullfile(monpath,imgname);
      fnlen=length(imgname);

      % do a simple pattern-match check
      if fnlen < nprefix+22
	continue;
      end
      fnstart=imgname(1:nprefix);
      fnend=imgname(end-3:end);
      if ~strcmp(fnstart,prefix) | ...
	    ~strcmp(fnend,'.jpg')
	continue
      end
      
      % get image datenum
      img_dn = fn2datenum(sitename, imgname, getIR);
      
      if img_dn < startDT
	continue
      end
      
      if img_dn > endDT
	continue
      end
      
      % add image path to cell array
      listlen = listlen + 1;
      imglist{listlen}=imgpath;
      
    end
  end
end
    


return

function usage()
disp('Usage: ');
disp('  getsiteimglist(archive_dir,sitename);');
disp('  getsiteimglist(archive_dir,sitename,startDT);');
disp('  getsiteimglist(archive_dir,sitename,startDT,endDT);');
disp('  getsiteimglist(archive_dir,sitename,startDT,endDT,getIR);');
