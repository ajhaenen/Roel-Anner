clear all;clc;tic
load('Y:\Roel-Anner_DATA\TrueFX_201601.mat')
fields = fieldnames(Exchange);

%% Time comparison
figure
hold on
grid on
for i=1:15
    plot(Exchange.(fields{i}).time, 'DisplayName', fields{i})      
end
legend('show')
ylabel('Date','FontSize',20)
xlabel('Datapoints','FontSize',20)
datetick('y',6)

%% Scatter
figure
hold on
grid on
scatter(Exchange.USDCHF.time, Exchange.USDCHF.sell,'.', 'DisplayName', 'sell')
scatter(Exchange.USDCHF.time, Exchange.USDCHF.buy,'.', 'DisplayName', 'buy')
title('USDCHF')
xlabel('Seconds','FontSize',20)
ylabel('Rate','FontSize',20)
datetick('x',0)

%%
sell = Exchange.USDCHF.sell;
buy = Exchange.USDCHF.buy;
t = Exchange.USDCHF.time;
dt = gradient(t);
dsell = gradient(sell);
dbuy = gradient(buy);
spread = buy-sell;
figure
hold on
grid on
plot(t,dt,'DisplayName', 'dt')
plot(t,dbuy,'DisplayName', 'dbuy')
plot(t,dsell,'DisplayName', 'dsell')
plot(t,spread,'DisplayName', 'spread')
title('USDCHF')
xlabel('Seconds','FontSize',20)
datetick('x',0)
legend('show')

%% Theoretisch maximum
BROKERabs = eps;
BROKERper = 1.0001;

BS = 0; i = 1; k = 1; j = 2;
SELLPEAK(1) = sell(i);
SELLPEAKidx(1) = i;

try
while i < length(buy)
    i=i+1;
    disp(i/length(buy))
    
    if BS == 0
        if buy(i) < SELLPEAK(j-1)
            ii = i;
            BUYTROUGH(k) = buy(i);
            BUYTROUGHidx(k) = ii;
            
            while sell(i)/BROKERper-BROKERabs < BUYTROUGH(k)
                i = i+1;
                if buy(i) < BUYTROUGH(k)
                    BUYTROUGH(k) = buy(i);
                    BUYTROUGHidx(k) = i;
                end
            end
            
            BS = 1;
            i = BUYTROUGHidx(k);
            k = k+1;
        end
    elseif BS == 1
        if sell(i) > BUYTROUGH(j-1)
            ii = i;
            SELLPEAK(j) = sell(i);
            SELLPEAKidx(j) = ii;
            
            while buy(i)*BROKERper+BROKERabs > SELLPEAK(j)
                i = i+1;
                if sell(i) > SELLPEAK(j)
                    SELLPEAK(j) = sell(i);
                    SELLPEAKidx(j) = i;
                end
            end
                       
            BS = 0;
            i = SELLPEAKidx(j);
            j = j+1;
        end
    end
end
catch
end

figure
hold on 
grid on
plot(t,buy,'DisplayName','buy')
plot(t,sell,'DisplayName','sell')
scatter(t(SELLPEAKidx), SELLPEAK,'LineWidth',1)
scatter(t(BUYTROUGHidx), BUYTROUGH,'LineWidth',1)
legend('show')
xlabel('Time','FontSize',20)
ylabel('Rate','FontSize',20)
title('Ideal trading algorithm','FontSize',30)

%datetick('x',9)
%findpeaks(buy,'MinPeakProminence',1e-4,'Annotate','extents')

try
    Gainsper = (SELLPEAK(1:end)-BUYTROUGH)+1;
catch
    Gainsper = (SELLPEAK(2:end)-BUYTROUGH)+1;
end
E0 = 1;
E1 = E0;
for i = 1:length(Gainsper)
    E1 = E1 * Gainsper(i);
end
disp(E1-1)

