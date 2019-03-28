clear
close all
clc

data_result_folder='C:\Users\BuccelliLab\Documents\GitHub\bycycle_matlab\Results\Results_mat\';
load([data_result_folder 'results'])

%% plot signal and BP signal
figure
plot(time_s,signal)
hold on
plot(time_s,signal_low_mat)
legend({'signal','BP signal'})
title(['signal and BP signal [' num2str(frequency_limits) '] Hz'])
xlabel('Time [s]')

%% showing peaks and other cycle markers
figure
h(1)=subplot(3,1,1);
plot(time_s , signal_low_mat)
hold on
plot( time_s(result_table.sample_peak+1) , signal_low_mat(result_table.sample_peak+1),'bx')
plot( time_s(result_table.sample_last_trough+1) , signal_low_mat(result_table.sample_last_trough+1),'rx')
plot( time_s(result_table.sample_zerox_decay+1) , signal_low_mat(result_table.sample_zerox_decay+1),'mx')
plot( time_s(result_table.sample_zerox_rise+1) , signal_low_mat(result_table.sample_zerox_rise+1),'gx')
legend({'BP signal','sample peak','sample through','mid decay','mid rise'})
title('BP signal and peaks, valleys, decays and rise')
xlabel('Time [s]')

h(2)=subplot(3,1,2);
plot( time_s(result_table.sample_peak+1) , result_table.amp_fraction/fs_mat,'b')
hold on
% plot( time_s(result_table.sample_peak+1) , result_table.band_amp/fs_mat,'r')
xlabel('Time [s]')
title('ampl fraction')

h(3)=subplot(3,1,3);
% histogram(result_table.period/fs_mat,'normalization','probability')
plot( time_s(result_table.sample_peak+1) , result_table.amp_fraction/fs_mat,'r')
title('volt amplitude')
linkaxes(h,'x')

%% showing comparison between times

figure
subplot(3,1,1)
plot(result_table.time_trough./fs_mat,result_table.time_peak./fs_mat,'b.')
max_x_y=max(max(result_table.time_trough,result_table.time_peak))./fs_mat;
hold on
plot([0 max_x_y],[0 max_x_y],'r')
xlim([0 max_x_y*1.1])
ylim([0 max_x_y*1.1])
% axis square
ylabel('time peak [s]')
xlabel('time through [s]')
title('time through vs peak')

subplot(3,1,2)
plot(result_table.time_trough./fs_mat,result_table.time_rise./fs_mat,'b.')
max_x_y=max(max(result_table.time_trough,result_table.time_rise))./fs_mat;
hold on
plot([0 max_x_y],[0 max_x_y],'r')
xlim([0 max_x_y*1.1])
ylim([0 max_x_y*1.1])
% axis square
ylabel('time rise [s]')
xlabel('time through [s]')
title('time through vs rise')

subplot(3,1,3)
plot(result_table.time_ptsym,result_table.time_rdsym,'b.')
max_x_y=max(max(result_table.time_ptsym,result_table.time_rdsym));
hold on
plot([0 max_x_y],[0 max_x_y],'r')
xlim([0 max_x_y*1.1])
ylim([0 max_x_y*1.1])
% axis square
ylabel('time ptsym ')
xlabel('time rdsym')
title('time ptsym vs rdsym')

%% showing burst-related parameters
% 'amplitude_fraction_threshold',.3,
% 'amplitude_consistency_threshold',.4,
% 'period_consistency_threshold',.5, 
% 'monotonicity_threshold',.8,
% 'N_cycles_min',3
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

%% burst no burst cycle
figure
histogram(result_table.is_burst,'normalization','probability')
xticks([0 1])
xticklabels({'FALSE','TRUE'})
ylim([0 1])
ylabel('probability')
title('cycle is burst')