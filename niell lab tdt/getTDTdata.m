function tdtData= getTDTdata(Tank_Name, Block_Name, chans, flags);
%%% function to read in all relevant data from a block
%%% and convert to matlab data structure
%%% cmn 06/2011


tdtData=struct('streamV',[],'streamT',[],'MUspikeT',[], 'snips',[], 'spikeT',[],  'lfpT' ,[],...
    'lfpData',[], 'spectT',[], 'spectF',[], 'spectData' ,[], ...
    'frameEpocs' ,[],'stimEpocs' ,[], ...
    'mouseT',[], 'mouseV' ,[],'laserT',[], 'laserTTL',[])

TTX = openTTX(Tank_Name,Block_Name);
invoke(TTX,'CreateEpocIndexing');
ep = invoke(TTX, 'GetEpocsV', 'xTrg', 0,0, 1000);


max_events = 10^6;
max_time = 10^9;
if isfield(flags,'MUspike') && flags.MUspike
    Event_Name_Snip='Snip'
    
    for ch = chans
        ch
        N= invoke(TTX, 'ReadEventsV', max_events, Event_Name_Snip, ch, 0, 0,max_time,'ALL')
        tdtData.MUspikeT{ch} = invoke(TTX, 'ParseEvInfoV', 0, N, 6)  ;  %   3  = event codes
        if isfield(flags,'snips')&&flags.snips
            tdtData.snips{ch} = invoke(TTX, 'ParseEvV', 0, N);
        end
    end
end

    

if isfield(flags,'stream') && flags.stream
    event_code = 'pAll';
    max_events = 10^6;
    max_t = 10^9;
for ch = chans
        [tdtData.streamV{ch} tdtData.streamT{ch}] = readWave(TTX,ch, event_code,max_events,max_t);
    end
end

if isfield(flags,'oldCluster') && flags.oldCluster
    tdtData.spikeT= getBlockSpikes;
elseif isfield(flags,'newCluster') && flags.newCluster
    [afname, apname] = uigetfile('*.mat','analysis data');
    if afname~=0
        afile = fullfile(apname,afname);
        load(afile,spikeT);
        tdtData.spikeT=spikeT
    end
    
end

if isfield(flags,'lfpTseries') && (flags.lfpTseries | flags.lfpSpectra)
    [tdtData.lfpT tdtData.lfpData tdtData.spectT tdtData.spectF tdtData.spectData] =...
        analyzeLFP_chronux(TTX,chans,flags.lfpTseries,flags.lfpSpectra);
end

if isfield(flags,'visStim') && flags.visStim
    tdtData.frameEpocs = invoke(TTX, 'GetEpocsV', 'fTrg',0,0,max_events);
    tdtData.stimEpocs = invoke(TTX, 'GetEpocsV', 'xTrg', 0,0,max_events);
end

if isfield(flags,'laserOn') && flags.laserOn
    display('laser')
    [tdtData.laserT tdtData.laserTTL] = read_laser(TTX);
end

if isfield(flags,'mouseOn') && flags.mouseOn
    [tdtData.mouseT tdtData.mouseV groomstate] =getBlockVelocity_groom(Tank_Name,Block_Name);
end

invoke(TTX, 'CloseTank');
invoke(TTX, 'ReleaseServer');