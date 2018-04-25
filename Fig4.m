% Isolate storm events for Ballona Creek for both modeled and observed flow. Then calibrate/validate 
% using calcError function. This script can process hourly or
% daily data. 
% Written by J. Wolfand
% Modified on 4/25/18 to create Figure 4 of FIB modeling paper
clear all
close all

isHourly = false; % Choose to look at hourly or aggregated daily data. If false --> daily

% Create date time series, this is the full period of record
startDate = datetime(1997,10,1,0,0,0);
endDate = datetime(2015,9,30,23,0,0);

% Import hourly time series data. Must be hourly!
import = importdata('C:\SUSTAIN\PROJECTS\Ballona\Climatology\Modeled_precip_98_15_divisibleby24.txt'); %Modeled precip at Sawtelle gage
precip = import.data;
obsFlow = importdata('C:\SUSTAIN\PROJECTS\Ballona\Calibration\Flow\Observed_Flow_WY_98-15_without_2008.txt');
import = importdata('C:\SUSTAIN\PROJECTS\Ballona\Calibration\Flow_storms_only\Model_runs\Run_31.txt');
modFlow = import.data(:,4);

% Tranform to daily data if not hourly
if(isHourly)
    dates = [startDate:hours(1):endDate]';
else %Daily
    dates = [startDate:endDate]';
    precip = sum(reshape(precip,24,[]));
    obsFlow = mean(reshape(obsFlow,24,[]));
    modFlow = mean(reshape(modFlow,24,[]));   
end


% Find storm events
storms = findStorms(precip, obsFlow);

% Create vectors with only storm events, remove nans
stormDates = dates(storms);
obsStorms = obsFlow(storms);
modStorms = modFlow(storms);

nans = (~isnan(obsStorms));
obsStorms = obsStorms(nans);
modStorms = modStorms(nans);
stormDates = stormDates(nans);

%% Calibration figure 
% Date range of interest
startRange = datetime(1997,10,1,0,0,0);
endRange = datetime(2006,9,30,23,0,0);

% Create new vectors of storm data within that date range
dateRange1 = stormDates > startRange & stormDates < endRange;
obsRange = obsStorms(dateRange1);
modRange = modStorms(dateRange1);

% Calculate cal/val statistics for that date range
A = calcError(obsRange, modRange)

% Plot scatter plot of observed vs. modeled data 
figure(1)
subplot(1,2,1)
scatter(obsRange,modRange, '.')
hold on
x = [10^0:10^4];
y = x;
plot(x, y, 'Color', [0.5 0.5 0.5])
axis([10^0 10^4 10^0 10^4])

% Write stats on figure
%data = ['Abs. Error (cfs) = ';'RMSE (cfs) =       ';'% Bias =           '; 'NSE =              ';'R^2 =              '];
%celldata = cellstr(data);
%stats = horzcat(data, num2str(A, '%.3f'));
%text(1.5,10^3.4,stats, 'FontName', 'FixedWidth')

set(gca,'xscale','log')
set(gca,'yscale','log')
xlabel('Observed flow [cfs]')
ylabel('Modeled flow [cfs]')
formatOut = 'mm/dd/yy';
%title(['Storm Flow in Ballona Creek from ' datestr(startRange, formatOut) ' to ' datestr(endRange, formatOut)])
title('Water Years 1998 to 2006')
%% Validation Figure

% Date range of interest
startRange = datetime(2006,10,1,0,0,0);
endRange = datetime(2015,9,30,23,0,0);

% Create new vectors of storm data within that date range
dateRange2 = stormDates > startRange & stormDates < endRange;
obsRange = obsStorms(dateRange2);
modRange = modStorms(dateRange2);

% Calculate cal/val statistics for that date range
B = calcError(obsRange, modRange)

subplot(1,2,2)
scatter(obsRange,modRange, '.')
hold on
x = [10^0:10^4];
y = x;
plot(x, y, 'Color', [0.5 0.5 0.5])
axis([10^0 10^4 10^0 10^4])

% Write stats on figure
%data = ['Abs. Error (cfs) = ';'RMSE (cfs) =       ';'% Bias =           '; 'NSE =              ';'R^2 =              '];
%celldata = cellstr(data);
%stats = horzcat(data, num2str(B, '%.3f'));
%text(1.5,10^3.4,stats, 'FontName', 'FixedWidth')

set(gca,'xscale','log')
set(gca,'yscale','log')
xlabel('Observed flow [cfs]')
ylabel('Modeled flow [cfs]')
formatOut = 'mm/dd/yy';
%title(['Storm Flow in Ballona Creek from ' datestr(startRange, formatOut) ' to ' datestr(endRange, formatOut)])
title('Water Years 2007 to 2015')
