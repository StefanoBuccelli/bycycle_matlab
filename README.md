# bycycle_matlab

The goal of this small repo is to use the Cycle-by-cycle analysis of neural oscillations in Matlab. Original [code](https://github.com/bycycle-tools/bycycle), [paper](https://www.biorxiv.org/content/biorxiv/early/2018/04/16/302000.full.pdf). 

A couple of slides to report the main outputs can be found [here](https://docs.google.com/presentation/d/1f_hgb8_cTH3FcLqAoRaLXrtmsiLkl_r8F2XAZn-bmzk/edit?usp=sharing). 

### Data
Contains a sample lfp recording

### Matlab_scripts
Contains 4 scrips so far:
- byc_get_table.m calls the bycycle functions lowpass_filter and compute_features to get a table with all the parameters described in the [paper](https://www.biorxiv.org/content/biorxiv/early/2018/04/16/302000.full.pdf). Saves the table and signal in the result_mat folder.
- byc_plot_table.m get the table from the Results_mat folder and plots different features in order to choose the best parameters for the burst detection. Figures are saved in Results_fig folder.
- byc_get_bursts.m get the table from the result_mat folder and runs the burst detection with a configurable combination of parameters. Overwrites the results in the Results_mat folder.
- byc_plot_bursts.m get the table and burst detection with the combination of parameters used and plots the results to choose the best parameters. Figures are saved in Results_fig folder.

### Results
Contains 2 folders:
- Results_mat contains table, band-pass signal, burst detection, combination of parameters to get burst detection.
- Results_fig contains all the figures that are generated by the plot scripts.
