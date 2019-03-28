clear
close all
clc

data_result_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_mat\';
fig_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_fig\';
load([data_result_folder 'results'])

%% running different burst detections

% 'amplitude_fraction_threshold',.3,
% 'amplitude_consistency_threshold',.4,
% 'period_consistency_threshold',.5, 
% 'monotonicity_threshold',.8,
% 'N_cycles_min',3

amplitude_fraction_threshold=0;
amplitude_consistency_threshold=0;
period_consistency_threshold=0;
monotonicity_threshold=0;
N_cycles_min=0;