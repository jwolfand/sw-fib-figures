%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Figure 3 -- Compare FIB timeseries

% This function will compare the distribution of bacteria data from
% observed grab samples and matching time points from a simulated data
% series. 

% Written by J. Wolfand on 11/23/16
% Updated 4/25/18 to create Figure 3 for publication

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% IMPORT DATA
% Import simulated timeseries
% Import observed bacteria grab samples

clear all
close all

% Import observed grab sample data
import1 = importdata('C:\SUSTAIN\Projects\Ballona\Quality\FIB\1710_Observed_E_coli_at_BCB-5.txt', '\t', 0);
obsEC = import1.data; 
obsECdates = datetime(import1.textdata, 'InputFormat', 'MM/dd/yy h:mm');

% Import simulated time series
%import2 = importdata('C:\SUSTAIN\Projects\Ballona\Quality\FIB\Simulated_EC_Timeseries\Concentration_FIB_26.txt');
import2 = importdata('C:\SUSTAIN\PROJECTS\Ballona\R files\Input\simulated_FIB_timeseries.txt');
simEC_hourly = import2.data; % hourly data
simEC = geomean(reshape(simEC_hourly,24,[])); % daily data
simECdates = [datetime(1997,10,1,0,0,0):datetime(2015,9,30,23,0,0)]';

%% Match data points

matchedEC = zeros(length(obsEC),2);
for i = 1:length(matchedEC)
  
    index = find(simECdates ==  obsECdates(i));
    matchedEC(i,1) = obsEC(i);
    matchedEC(i,2) = simEC(index);
end
%% Plot results

figure()
cdfplot(log10(matchedEC(:,1)))
hold on
cdfplot(log10(matchedEC(:,2)))
%axis([0 12 0 1])
TMDL = log10(576);
line([TMDL,TMDL],ylim, 'Color', 'black', 'Linestyle', '--')
title('{\it E. coli} in Ballona Creek');
xlabel('Concentration [log_1_0(MPN/100 mL)]');
ylabel('Cumulative Probability');
legend('Observed','Simulated','Location','NW')

% Just look at distribution for values over 100
subset1 = matchedEC(:,1)>100;
subset2 = matchedEC(:,2)>100;
[h,p] = kstest2(log(matchedEC(subset1,1)),log(matchedEC(subset2,2)))
