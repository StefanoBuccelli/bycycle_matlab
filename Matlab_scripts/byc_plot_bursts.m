%% this script plots some of the features related to burst detection with different parameters

clear
close all
clc

data_result_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_mat\';
fig_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_fig\';
load([data_result_folder 'results'])

%% burst no burst cycle
n_params=length(param.amplitude_consistency_threshold);
figure
for curr_comb=1:n_params
    subplot(ceil(sqrt(n_params)),round(sqrt(n_params)),curr_comb)
    histogram(is_burst_comb(:,curr_comb),'normalization','probability')
    xticks([0 1])
    xticklabels({'FALSE','TRUE'})
    ylim([0 1])
    ylabel('probability')
    title(['curr comb: ' num2str(curr_comb)])
end
savefig([fig_folder 'histogram_burst_cycle_prob'])

%%








