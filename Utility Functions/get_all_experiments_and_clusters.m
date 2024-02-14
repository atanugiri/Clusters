function [all_probabilities,list_of_all_clusters_for_current_experiment]  = get_all_experiments_and_clusters(dir_with_cluster_tables,spider_plot_dir_relative)
all_probabilities = containers.Map('KeyType','char','ValueType','any');
homeDir = cd(dir_with_cluster_tables);
absolute_file_path_of_cluster_tables = cd(homeDir);

if ~exist(spider_plot_dir_relative,"dir")
    mkdir(spider_plot_dir_relative)
end
cd(spider_plot_dir_relative)
spider_plot_dir_absolute = cd(homeDir);

cd(absolute_file_path_of_cluster_tables);
all_cluster_tables_list = ls(strcat(absolute_file_path_of_cluster_tables,"\*.xlsx"));
all_cluster_tables_list = string(all_cluster_tables_list);
all_cluster_tables_list = strtrim(all_cluster_tables_list);
% disp(all_cluster_tables_list(:,:))
all_experiments = split(all_cluster_tables_list, " ");
% disp(all_experiments)
unique_experiments = unique(all_experiments(:,1));
% disp(unique_experiments.')
for i=1:length(unique_experiments)
    current_experiment = unique_experiments(i);
%     disp(current_experiment)
%     disp("////////////////")
    disp(current_experiment);
    list_of_all_clusters_for_current_experiment = ls(strcat(absolute_file_path_of_cluster_tables,"\*",current_experiment,"*.xlsx"));
    list_of_all_clusters_for_current_experiment = string(list_of_all_clusters_for_current_experiment);
    list_of_all_clusters_for_current_experiment = strtrim(list_of_all_clusters_for_current_experiment);
    list_of_all_clusters_for_current_experiment = split(list_of_all_clusters_for_current_experiment," ");
    list_of_all_clusters_for_current_experiment = list_of_all_clusters_for_current_experiment(:,2);
    list_of_all_clusters_for_current_experiment = strrep(list_of_all_clusters_for_current_experiment,".xlsx","");
    % disp(list_of_all_clusters_for_current_experiment)
    
% disp(size(list_of_all_clusters_for_current_experiment))
    
    list_of_unique_feature_sets = strrep(list_of_all_clusters_for_current_experiment,"_1","");
    list_of_unique_feature_sets = strrep(list_of_unique_feature_sets,"_2","");
    list_of_unique_feature_sets = strrep(list_of_unique_feature_sets,"_3","");
    list_of_unique_feature_sets = strrep(list_of_unique_feature_sets,"_4","");
    list_of_unique_feature_sets = strrep(list_of_unique_feature_sets,"_5","");

    list_of_unique_feature_sets = unique(list_of_unique_feature_sets);
    % disp(list_of_unique_feature_sets)

    probabilities = get_sizes_of_data_sets(absolute_file_path_of_cluster_tables,current_experiment,list_of_all_clusters_for_current_experiment,list_of_unique_feature_sets); 
    all_probabilities(current_experiment) = probabilities.';
    table_of_probabilities_and_their_cluster_name = table(list_of_all_clusters_for_current_experiment,probabilities,'VariableNames',{'Cluster_Names','Probabilities'});
    % disp(table_of_probabilities_and_their_cluster_name);
    create_spider_plot(spider_plot_dir_absolute,list_of_all_clusters_for_current_experiment,probabilities,current_experiment,"get_all_experiments_and_clusters.m");
    disp(list_of_all_clusters_for_current_experiment.')
end
cd(homeDir)
end