%% load all experiment names
%I selected these names and dates from live_database using SQL queries, and more can be gotten by querying live_database
load('alcohol_names_and_dates.mat');
load('baseline_names_and_dates.mat');
load('food_deprivation_names_and_dates.mat')
load('ghrelin_names_and_dates.mat')
load('oxy_names_and_dates.mat')
load('saline_names_and_dates.mat')
%% put everything into array to loop through
% all_experiment_names = {all_names_baseline,all_names_oxy,all_names_food_deprivation,all_names_lg_boost_and_etho,all_names_ghrelin,all_names_saline};
% all_experiment_dates = {all_dates_baseline,all_dates_oxy,all_dates_food_deprivation,all_dates_lg_boost_and_etho,all_dates_ghrelin,all_dates_saline};
% all_experiments = {"Baseline","Oxy","Food_Deprivation","Boost_and_Etho","Ghrelin","Saline"};

%% Testing (For Atanu)
all_experiment_names = {all_names_ghrelin};
all_experiment_dates = {all_dates_ghrelin};
all_experiments = {"Ghrelin"};

%% Get Psychometric functions for all experiments
clc;
where_psych_func_table_will_be_rel = "Psych"; %folder where psychometric function tables will be saved
run_psychometric_functions(where_psych_func_table_will_be_rel,all_experiment_names,all_experiment_dates,all_experiments) %create the psychometric function tables

%% Run The Sigmoid Analysis
run_sigmoid_analysis_updated("Psych","Sigmoids");

%% Get directories with sigmoid data
all_dirs = get_all_directories_with_sigmoid_data("Sigmoids",[]);
% disp(all_dirs)
%% Get Individual Plots and create their adjoining cluster tables
create_individual_plots_2(all_dirs,"Individual_Plots","Cluster_Tables")

%% NOT NEEDED

%% Calculate Probabilities of Each Cluster and create individual spider plots
[all_probabilities,list_of_clusters] = get_all_experiments_and_clusters("Cluster_Tables","Spider_Plots");
table_of_all_probabilities = array2table(cell2mat(values(all_probabilities).'),"RowNames",string(keys(all_probabilities).'),"VariableNames",list_of_clusters);


%% put all spider plots into single pdf
concatenate_many_plots("Spider_Plots","Spider_plots.pdf","All_PDFS");

%% Create Overlay Spider Plots
create_overlay_spider_plots(table_of_all_probabilities, "Overlaid_Spider_Plots");

%% put all overlaid spider plots into single pdf
concatenate_many_plots("Overlaid_Spider_Plots","Overlain_Spider_plots.pdf","All_PDFS");

%% create migration plots
clc;
create_migration_plots_2("Cluster_Tables","Migration_Plots","Migration_Plots_As_PDFS");

%% Put all migration plots into single pdf
concatenate_many_plots("Migration_Plots","Migration_Plots.pdf","All_PDFS")
%% measure skewness of datasets
clc
get_skewness_comparison("Cluster_Tables","Skewness_Plots")

%% put all skewness plots into single pdf
concatenate_many_plots("Skewness_Plots","Skewness Plots.pdf","All_PDFS");
%% get distributions of each individual rat's probabilities
clc;
close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];

get_all_euclidian_distance_plots("Cluster_Tables",experiment_list,feature_list,"Euc_Distance_Plots",true);


%% put all euclidian Distance plots into single pdf
concatenate_many_plots("Euc_Distance_Plots","Euc_dist.pdf","All_PDFS");

%% get distributions of each individual rat's euclidian distance compared to other rats 
clc;close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];
get_individual_rats_euc_distance_plots("Cluster_Tables",experiment_list,feature_list,"Euc_Distance_Plots_Individual");

%% get spider plots of each individual rat's probabilities compared to other rats
clc;close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
experiment_list = ["Oxy"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];
get_individual_rats_spider_plots("Cluster_Tables",experiment_list,feature_list,"Spider_Plots_Individual");



%% put individual spider plots of each individual rat's probabilities compared to other rats into pdf
concatenate_many_plots("Spider_Plots_Individual","Individual Rats Spider Plots.pdf","All_PDFS");

%% get spider plots comparing baseline rats to all other experiment rats
clc;close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];
get_spider_plots_comparing_rats_between_experiments("Cluster_Tables",experiment_list,feature_list,"SP_Baseline_To_other");

%% concatenate spider plots which compare baseline rats to all other experiment rats
concatenate_many_plots("SP_Baseline_To_other","Baseline Rats To Other Rats.pdf","All_PDFS");

%% get distributions of each individual rat's probabilities without normalizing for probability
clc;
close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];

get_all_euclidian_distance_plots("Cluster_Tables",experiment_list,feature_list,"Euc_Distance_Plots_Not_Norm",false);


%% put all euclidian Distance plots into single pdf
concatenate_many_plots("Euc_Distance_Plots_Not_Norm","Euc_dist_not_norm.pdf","All_PDFS");

%% get probability table for every rat and every experiment
clc; close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
feature_list = ["DT_","ET_","M_","RP1_","RP4_","SP_"];
get_every_probabilty_table_for_every_rat("Cluster_Tables",experiment_list,feature_list,"AVG_SP_PLT")


%% Get Spider Plots for each individual Rat for all features exclude RP Method 4
clc; close all;
experiment_list = ["Baseline"];
features_to_exclude = ["RP4_"];
get_individual_rats_spider_plots_for_every_feature("Cluster_Tables",experiment_list,features_to_exclude,"Spider_Plots_All_Features",true);

%% concatenate the above into single pdf
concatenate_many_plots("Spider_Plots_All_Features","Spider_plots_aladdin_to_other_baseline_animals.pdf","ALL_PDFS")

%% Get Spider Plots for each individual Rat in Oxy for all features exclude SP Method 4
% clc; close all;
experiment_list = ["Oxy"];
features_to_exclude = ["RP4_"];
get_individual_rats_spider_plots_for_every_feature("Cluster_Tables",experiment_list,features_to_exclude,"Spider_Plots_All_Features_Oxy",true);
%% concatenate the above into single pdf
concatenate_many_plots("C:\Users\ldd77\OneDrive\Desktop\ghrelin_paper\Spider_Plots_All_Features_Oxy","Spider_Plots_Oxy_animals_compared_to_eachother.pdf","ALL_PDFS")


%% get spider plots which are very similar, not very similar, and kind of similar for each rat in each experiment
clc; close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
features_to_exclude = ["RP4_"];
get_individual_rats_euclidian_distance_from_each_other("Cluster_Tables",experiment_list,features_to_exclude,"Spider Plots For RECORD paper",true);

%% get Euclidian Distance Plots for all features comparing rats within the same experiment
clc;
close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
features_to_exclude = ["RP4_"];
get_ind_rats_euc_distance_dist_from_each_other_all_features("Cluster_Tables",experiment_list,features_to_exclude,"Histogram for RECORD Paper",true);


%% Move Plot Pairs From Separate folders into same folder
%in this case I'm plotting spider plots to their histogram of euclidian distance pairs
clc;
first_path_of_files = "Spider Plots For RECORD paper";
second_path_of_files = "Histogram for RECORD Paper";
path_to_copy_files_to = "Similar Not Similar Somewhat Similar Spider Plots and Histograms for RECORD paper";
copy_plots_from_2_folders_to_single_folder(first_path_of_files,second_path_of_files,path_to_copy_files_to)

%% concatenate the above into single pdf
concatenate_many_plots("Similar Not Similar Somewhat Similar Spider Plots and Histograms for RECORD paper","Histograms_and_Spider_plots_together.pdf","ALL_PDFS")

%% Bin Cluster Tables by 28 days
clc;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
rebin_cluster_tables("Cluster_Tables","Rebinned Cluster Tables",experiment_list,28)


%% get euclidian distance plots for all features 
clc; close all;
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Food_Deprivation"];
features_to_exclude = ["RP4_"];
get_euc_distance_dist_for_every_feature("Cluster_Tables",experiment_list,features_to_exclude,"Euc_Dist_All_Features",true);

%% concatenate the above
concatenate_many_plots("A Figures For RECORD paper","All Features Together Histograms.pdf","ALL_PDFS")

%% divide each individual rat's cluster data into 2 bins
clc;
% cd("C:\Users\ldd77\OneDrive\Desktop\ghrelin_paper")
% rmdir("Rebinned Cluster Tables Version 2",'s')
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
rebin_individual_rats_cluster_info("Cluster_Tables","Rebinned Cluster Tables Version 2",experiment_list,2)

%% get directories with rebinned data
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
rebinned_dirs = get_rebinned_directories("Rebinned Cluster Tables Version 2",experiment_list);

%% get euclidian distance between each rats first and last bin
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
get_euclidian_distances_between_rats_first_and_last_bin(rebinned_dirs,experiment_list,true,["RP4_"],"First_and_last_bin_euc_dist_hist");

%% concatenate the above into single file
concatenate_many_plots("First_and_last_bin_euc_dist_hist","all_first_and_last_bin_euc_dist_histograms.pdf","ALL_PDFS")

%% get directories with rebinned data
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
rebinned_dirs = get_rebinned_directories("Rebinned Cluster Tables",experiment_list);

%% get euclidian distance between each rats first and last bin
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
get_euclidian_distances_between_rats_first_and_last_bin_overlay(rebinned_dirs,experiment_list,true,["RP4_"],"First_and_last_bin_overlay_plots",2);

%% concatenate the above into single file
concatenate_many_plots("First_and_last_bin_overlay_plots","First_and_last_bin_overlay_plots.pdf","ALL_PDFS")

%% get examples of rats with a great change between first/last bin, no change between first/last bin, and med change between their first and last bin
experiment_list = ["Baseline", "Oxy","Boost_And_Etho","Ghrelin","Saline","Food_Deprivation"];
get_euc_dist_between_rats_first_and_last_bin_for_sp_plts(rebinned_dirs,experiment_list,true,["RP4_"],"First_and_last_bin_Spider_plots",true);

