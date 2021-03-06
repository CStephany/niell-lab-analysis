%function analyzeEEG
% Matlab codes for reading EEG data
% For each condition, goes by epoc and plots power spectrum
% cmn 06-06, based on code by Jianhua Cang 06-27-03



%%% read in cluster data, (only needed to get block name and start/stop time)
%%% then connect to the tank and read the block

%%% read in cluster data, then connect to the tank and read the block
close all
clear all
cells =1;
[fname, pname] = uigetfile('*.mat','cluster data');
load(fullfile(pname,fname));
for i =1:length(Block_Name);
    sprintf('%d : %s ',i,Block_Name{i})
end
block = input('which block to analyze ? ');
Block_Name = Block_Name{block}

time1= 0;
time2=0;
max_events = 50000;
Tank_Name = '022009_awake_linear';
Block_Name = 'drift2'


thresh_velocity=1;

[afname, apname] = uigetfile('*.mat','analysis data');
if afname~=0
    afile_bar = fullfile(apname,afname);
    save(afile_bar, 'afile_bar','apname','-append'); %%% to make sure it's not overwritten
    load(afile_bar);
    use_afile=1;
else
    sprintf('no analysis file')
    return
end

%[v_tstamp vsmooth groomstate] =getBlockVelocity_groom(Tank_Name,Block_Name);

TTX = openTTX(Tank_Name,Block_Name); % to initialize

Event_Name_EEG='Lfpx'
Event_Name_trace = 'PDec'
Event_Name_stim = 'Stim'


for ch=1:15
W=0;
[trace trace_tstamp] = readtrace(TTX,'Lfpx',ch);

figure
plot(trace_tstamp,trace);
end

invoke(TTX, 'CloseTank');
invoke(TTX, 'ReleaseServer');