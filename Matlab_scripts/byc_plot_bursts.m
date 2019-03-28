clear
close all
clc

data_result_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_mat\';
fig_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_fig\';
load([data_result_folder 'results'])

%% showing burst-related parameters
figure
h_hist(1)=subplot(2,2,1);
histogram(result_table.amp_consistency,'normalization','probability')
title('amp consistency')
h_hist(2)=subplot(2,2,2);
histogram(result_table.amp_fraction,'normalization','probability')
title('amp fraction')
h_hist(3)=subplot(2,2,3);
histogram(result_table.period_consistency,'normalization','probability')
title('period consistency')
h_hist(4)=subplot(2,2,4);
histogram(result_table.monotonicity,'normalization','probability')
title('monotonicity')
savefig([fig_folder 'histogram_burst_params'])

%% burst no burst cycle
figure
histogram(result_table.is_burst,'normalization','probability')
xticks([0 1])
xticklabels({'FALSE','TRUE'})
ylim([0 1])
ylabel('probability')
title('cycle is burst')
savefig([fig_folder 'histogram_burst_cycle_prob'])