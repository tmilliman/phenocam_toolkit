function fdoy = datenum2fdoy(myDateNum)
%
% Given a datenum value return the fractional day-of-year.
%
myDateVec = datevec(myDateNum);
myYear = myDateVec(1);
jan1 = datenum(myYear,1,1,0,0,0);

fdoy = myDateNum - jan1 + 1;

return;