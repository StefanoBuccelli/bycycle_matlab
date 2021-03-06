%% this script plots some of the features related to burst detection with different parameters

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
figure
h(1)=subplot(5,1,1);
plot(time_s , signal_low_mat)
hold on
colors=['r','g','m','y'];
molt=[1.1 1.2 1.3 1.4];
for curr_comp=1:length(param.amplitude_consistency_threshold)
    burst_pos=find(is_burst_comb(:,curr_comp));
    plot( time_s(result_table.sample_peak(burst_pos)+1) , is_burst_comb(burst_pos,curr_comp).*nanmean(signal_low_mat)*molt(curr_comp),[colors(curr_comp) 'x'])
end
title('BP signal and bursts detected for different params')
legend('BP signal','param 1','param 2','param 3','param 4','param 5')


h(2)=subplot(5,1,2);
plot( time_s(result_table.sample_peak+1) , result_table.amp_consistency,'b')
hold on
for curr_comp=1:length(param.amplitude_consistency_threshold)
    plot([0 time_s(end)] , [param.amplitude_consistency_threshold(curr_comp) param.amplitude_consistency_threshold(curr_comp)],colors(curr_comp))
end
title('amp consistency')

h(3)=subplot(5,1,3);
plot( time_s(result_table.sample_peak+1) , result_table.amp_fraction,'b')
hold on
for curr_comp=1:length(param.amplitude_consistency_threshold)
    plot([0 time_s(end)] , [param.amplitude_fraction_threshold(curr_comp) param.amplitude_fraction_threshold(curr_comp)],colors(curr_comp))
end
title('amp fraction')

h(4)=subplot(5,1,4);
plot( time_s(result_table.sample_peak+1) , result_table.period_consistency,'b')
hold on
for curr_comp=1:length(param.amplitude_consistency_threshold)
    plot([0 time_s(end)] , [param.period_consistency_threshold(curr_comp) param.period_consistency_threshold(curr_comp)],colors(curr_comp))
end
title('period consistency')

h(5)=subplot(5,1,5);
plot( time_s(result_table.sample_peak+1) , result_table.monotonicity,'b')
hold on
for curr_comp=1:length(param.amplitude_consistency_threshold)
    plot([0 time_s(end)] , [param.monotonicity_threshold(curr_comp) param.monotonicity_threshold(curr_comp)],colors(curr_comp))
end
title('monotonicity')
xlabel('Time [s]')

linkaxes(h,'x')
linkaxes(h(2:5),'xy') 
savefig([fig_folder 'signal_bursts_comb_and_params'])





