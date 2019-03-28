%% sweep burst parameters 
clear
close all
clc

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end
cd ..

data_result_folder='Results\Results_mat\';
fig_folder='Results\Results_fig\';

load([data_result_folder 'results'])

%% defining burst parameters (note that first and last cycles have NaN in some of the relevant paramters for burst detection)

% 'param.amplitude_fraction_threshold',.3,
% 'param.amplitude_consistency_threshold',.4,
% 'param.period_consistency_threshold',.5, 
% 'param.monotonicity_threshold',.8,
% 'param.N_cycles_min',3

param.amplitude_fraction_threshold=[0 0 0 0];
param.amplitude_consistency_threshold=[0.4 0.4 0.4 0.4];
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
%% save again the origian table and the additional one (with bursts for the different combination of parameters)
save([data_result_folder 'results_table'],'result_table','signal_low_mat','signal','time_s','frequency_limits','fs_mat','param','is_burst_comb')
