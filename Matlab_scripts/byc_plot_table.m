%% this script plots some of the features reported in the table

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

%% plot signal and BP signal
figure
plot(time_s,signal)
hold on
plot(time_s,signal_low_mat)
legend({'signal','BP signal'})
title(['signal and BP signal [' num2str(frequency_limits) '] Hz'])
xlabel('Time [s]')
savefig([fig_folder 'signal_band_pass'])

%% showing peaks and other cycle markers
figure
plot(time_s , signal_low_mat)
hold on
plot( time_s(result_table.sample_peak+1) , signal_low_mat(result_table.sample_peak+1),'bx')
plot( time_s(result_table.sample_last_trough+1) , signal_low_mat(result_table.sample_last_trough+1),'rx')
plot( time_s(result_table.sample_zerox_decay+1) , signal_low_mat(result_table.sample_zerox_decay+1),'mx')
plot( time_s(result_table.sample_zerox_rise+1) , signal_low_mat(result_table.sample_zerox_rise+1),'gx')
legend({'BP signal','sample peak','sample through','mid decay','mid rise'})
title('BP signal and peaks, valleys, decays and rise')
xlabel('Time [s]')
savefig([fig_folder 'band_pass_peaks'])

%% showing comparison between times
figure
subplot(3,1,1);
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
savefig([fig_folder 'time_peaks'])

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