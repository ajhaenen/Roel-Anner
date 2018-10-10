clear all;clc;tic
%% Read csv data from TrueFX
directory = 'C:\Users\ahaenen\Documents\GitHub\Roel-Anner_DATA\';
subdirectory = 'TrueFX_201601';
formatIn = 'yyyymmdd HH:MM:SS.FFF';
listing = dir(strcat(subdirectory,'\*.csv'));

for i = 1:length(listing)
    Name{i} = listing(i).name(1:6); %#ok<SAGROW>
    fprintf('Adding %s to Exchange, the time is %i \n',Name{i}, toc)
    filename = strcat('\', Name{i}, '-2016-01.csv');
    fid = fopen(strcat(directory,subdirectory,filename)); out = textscan(fid,'%s%s%f%f','delimiter',','); fclose(fid);
    Exchange.(Name{i}).time = datenum(out{2},formatIn); Exchange.(Name{i}).sell = out{3}; Exchange.(Name{i}).buy = out{4};
end

save(subdirectory, 'Exchange')