clear
clc
close all

data_result_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_mat\';
%% creating sine wave (sampled at 1kHz), freq = 14Hz
fs_mat = 1e3;     
time_s=(1:1:60*fs_mat)/fs_mat; % 60 seconds
signal=sin(2*pi*14*time_s).*100+(rand(size(time_s))-0.5)*5; 
% signal=a;
% time_s=(1:1:length(signal))/fs_mat; % 60 seconds
%% moving to python
signal_py = py.numpy.array(signal);
frequency_limits=[12,20];
f_range = py.list(frequency_limits);
fs = py.float(fs_mat);

signal_low = py.bycycle.filt.lowpass_filter(signal_py, fs, py.float(35));

%% setting parameters for burst detection
% 'amplitude_fraction_threshold',.3,
% 'amplitude_consistency_threshold',.4,
% 'period_consistency_threshold',.5, 
% 'monotonicity_threshold',.8,
% 'N_cycles_min',3

% burst_kwargs = py.dict(pyargs('amplitude_fraction_threshold',0.5,'amplitude_consistency_threshold',.5,'period_consistency_threshold',.5, 'monotonicity_threshold',.8,'N_cycles_min',3));
burst_kwargs = py.dict(pyargs('amplitude_consistency_threshold',.996,'period_consistency_threshold',.5, 'monotonicity_threshold',.8,'N_cycles_min',3));

%% computing features
bycyc = py.bycycle.features.compute_features(signal_low, fs, f_range, py.str('P'), py.str('cycles'),burst_kwargs);
df = bycyc.to_dict;
curr_chan_results = [];

for row = 1:(double(py.len(df{'sample_peak'})))
    curr_chan_results(row,1) = df{'sample_peak'}{row-1};
    curr_chan_results(row,2) = df{'sample_zerox_decay'}{row-1};
    curr_chan_results(row,3)= df{'sample_zerox_rise'}{row-1};
    curr_chan_results(row,4)= df{'sample_last_trough'}{row-1};
    curr_chan_results(row,5) = df{'sample_next_trough'}{row-1};
    curr_chan_results(row,6) = df{'period'}{row-1};
    curr_chan_results(row,7) = df{'time_peak'}{row-1};
    curr_chan_results(row,8) = df{'time_trough'}{row-1};
    curr_chan_results(row,9) = df{'volt_peak'}{row-1};
    curr_chan_results(row,10) = df{'volt_trough'}{row-1};
    curr_chan_results(row,11) = df{'time_rise'}{row-1};
    curr_chan_results(row,12) = df{'volt_decay'}{row-1};
    curr_chan_results(row,13) = df{'volt_rise'}{row-1};
    curr_chan_results(row,14) = df{'volt_amp'}{row-1};
    curr_chan_results(row,15) = df{'time_rdsym'}{row-1};
    curr_chan_results(row,16) = df{'time_ptsym'}{row-1};
    curr_chan_results(row,17) = df{'band_amp'}{row-1};
    curr_chan_results(row,18) = df{'amp_fraction'}{row-1};
    curr_chan_results(row,19) = df{'amp_consistency'}{row-1};
    curr_chan_results(row,20) = df{'period_consistency'}{row-1};
    curr_chan_results(row,21) = df{'monotonicity'}{row-1};
    curr_chan_results(row,22) = df{'is_burst'}{row-1};
end

%% putting  results in a matlab table
var_names={'sample_peak','sample_zerox_decay','sample_zerox_rise'...
    'sample_last_trough','sample_next_trough','period','time_peak',...
    'time_trough','volt_peak','volt_trough','time_rise','volt_decay',...
    'volt_rise','volt_amp','time_rdsym','time_ptsym','band_amp',...
    'amp_fraction','amp_consistency','period_consistency',...
    'monotonicity','is_burst'};
result_table=array2table(curr_chan_results,'VariableNames',var_names);

%% deleting NaN rows, converting ndarrays to matlab arrays
result_table(isnan(result_table.sample_peak),:)=[];
signal_low_mat=double(signal_low);


%% defining burst parameters (note that first and last cycles have NaN in some of the relevant paramters for burst detection)

% 'param.amplitude_fraction_threshold',.3,
% 'param.amplitude_consistency_threshold',.4,
% 'param.period_consistency_threshold',.5, 
% 'param.monotonicity_threshold',.8,
% 'param.N_cycles_min',3

param.amplitude_fraction_threshold=[0 0 0 0];
param.amplitude_consistency_threshold=[0.996 0.996 0.996 0.996];
param.period_consistency_threshold=[.5 .5 .5 .5];
param.monotonicity_threshold=[.8 .8 .8 .8];
param.N_cycles_min=[2 3 4 5];

%% 
n_combinations=size(param.amplitude_fraction_threshold,2);
is_burst_before_n_cycle=zeros(height(result_table),n_combinations,'logical');
is_burst_comb=zeros(height(result_table),n_combinations);

for curr_combination=1:n_combinations
    amp_frac=result_table.period_consistency>param.amplitude_fraction_threshold(curr_combination);
    amp_cons=result_table.amp_consistency>param.amplitude_consistency_threshold(curr_combination);
    period_cons=result_table.period_consistency>param.period_consistency_threshold(curr_combination);
    mono=result_table.monotonicity>param.monotonicity_threshold(curr_combination);
    is_burst_before_n_cycle(:,curr_combination)=[amp_frac & amp_cons & period_cons & mono];
    
    %% remove
    holes_pos_in_is_burst=find(is_burst_before_n_cycle(:,curr_combination)==0);
    seq_len=diff(holes_pos_in_is_burst)-1;
    start_seq=holes_pos_in_is_burst(1:end-1)+1;
    
    pos_above_N_in_holes=find(seq_len>=param.N_cycles_min(curr_combination));
    start_seq_above_N=start_seq(pos_above_N_in_holes);
    seq_len_above_N=seq_len(pos_above_N_in_holes);

    for curr_seq_above=1:length(start_seq_above_N)
        start=start_seq_above_N(curr_seq_above);
        is_burst_comb(start:start+seq_len_above_N(curr_seq_above)-1,curr_combination)=1;
    end
end

%%
save([data_result_folder 'results'],'result_table','signal_low_mat','signal','time_s','frequency_limits','fs_mat','param','is_burst_comb')
