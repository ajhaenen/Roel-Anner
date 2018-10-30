clear all;clc;tic
load('Y:\Roel-Anner_DATA\TrueFX_201601.mat')
fields = fieldnames(Exchange);

Mstr = ['04-Jan-2016 00:00:00'; '11-Jan-2016 00:00:00'; '18-Jan-2016 00:00:00'; '25-Jan-2016 00:00:00'];
Fstr = ['08-Jan-2016 20:59:59'; '15-Jan-2016 20:59:59'; '22-Jan-2016 20:59:59'; '29-Jan-2016 20:59:59'];
Mnum = datenum(Mstr);
Fnum = datenum(Fstr);
%%
SecondsPerWeek = 5*24*60*60-3*60*60;
TIME = linspace(Mnum(1),Fnum(1),(SecondsPerWeek*5));

%%
for i=1:15
    [time, index] = unique( Exchange.(fields{i}).time);
    Exchange2.(fields{i}).buy = interp1(time,Exchange.(fields{i}).buy(index),TIME);
    Exchange2.(fields{i}).sell = interp1(time,Exchange.(fields{i}).sell(index),TIME);
    Exchange2.(fields{i}).buy(1) = Exchange2.(fields{i}).buy(2);
    Exchange2.(fields{i}).sell(1) = Exchange2.(fields{i}).sell(2);
end

%%
Exchange5Hz = zeros(2*15,length(TIME));
for i = 1:15
    % buy
    Exchange5Hz(i,:) = Exchange2.(fields{i}).buy;
    Exchange5Hz_Fields{i} = strcat((fields{i}), '_buy');
    % sell
    Exchange5Hz(i+15,:) = Exchange2.(fields{i}).sell;
    Exchange5Hz_Fields{i+15} = strcat((fields{i}), '_sell');
    
end

%%
save('Y:\Roel-Anner_DATA\TrueFX_201601_5Hz_pythonready.mat', 'Exchange5Hz', 'Exchange5Hz_Fields', 'TIME')