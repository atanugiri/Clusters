function get_individual_rats_spider_plots_for_every_feature(path_of_cluster_tables,experiment_list,features_to_exclude,fig_file_path,exclude_features_or_dont)
    function [list_of_clusters]  = get_clusters_list(unformatted_list_of_clusters,experiment)
        list_of_clusters = string(unformatted_list_of_clusters);
        list_of_clusters = strrep(list_of_clusters,".xlsx","");
        list_of_clusters = strrep(list_of_clusters,experiment," ");
        list_of_clusters = strrep(list_of_clusters,"_","\_");
        list_of_clusters = strtrim(list_of_clusters);
    end

if ~exist(fig_file_path,"dir")
    mkdir(fig_file_path)
end
home_dir = cd(fig_file_path);
fig_file_path_abs = cd(home_dir);

cd(path_of_cluster_tables);
cluster_table_path_abs = cd(home_dir);

for experiment1=1:1.5%length(experiment_list)
    current_experiment_1 = experiment_list(experiment1);
    % list_of_clusters = get_clusters_list(cluster_table_path_abs,current_experiment_1);
    if strcmpi(current_experiment_1,"Baseline")
        [experiment_1_probabilities_table,clusters_list] = find_rats_probabilities_for_spider_plots_all_features(path_of_cluster_tables,current_experiment_1,true,exclude_features_or_dont,features_to_exclude);
    else
        [experiment_1_probabilities_table,clusters_list] =find_rats_probabilities_for_spider_plots_all_features(path_of_cluster_tables,current_experiment_1,false,exclude_features_or_dont,features_to_exclude);
    end
    clusters_list = get_clusters_list(clusters_list,current_experiment_1);

    for outer_table_counter = 1:height(experiment_1_probabilities_table)
        rat_1 = string(experiment_1_probabilities_table{outer_table_counter,1});
        rat_1_probabilities = cell2mat(experiment_1_probabilities_table{outer_table_counter,2});
        for inner_table_counter=outer_table_counter+1:height(experiment_1_probabilities_table)
            scrnsz = get(0,'ScreenSize');
            figure('Position',scrnsz);
            rat_2 = string(experiment_1_probabilities_table{inner_table_counter,1});
            rat_2_probabilities = cell2mat(experiment_1_probabilities_table{inner_table_counter,2});
            create_overlaid_spider_plots(fig_file_path_abs,clusters_list,[rat_1_probabilities;rat_2_probabilities],[strcat(current_experiment_1," ",rat_1),strcat(current_experiment_1, " ", rat_2)],"get_individual_rats_spider_plots_for_every_feature.m");
        end
    end



end
end

