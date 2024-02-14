function get_spider_plots_comparing_rats_between_experiments(path_of_cluster_tables,experiment_list,feature_list,fig_file_path)
    function [list_of_clusters]  = get_clusters_list(path_of_cluster_tables,experiment,feature)
        list_of_clusters = ls(strcat(path_of_cluster_tables,"\*",experiment,"*",feature,"*.xlsx"));
        list_of_clusters = string(list_of_clusters);
        list_of_clusters = strrep(list_of_clusters,".xlsx","");
        list_of_clusters = strrep(list_of_clusters,experiment," ");
        list_of_clusters = strtrim(list_of_clusters);
    end

if ~exist(fig_file_path,"dir")
    mkdir(fig_file_path)
end
home_dir = cd(fig_file_path);
fig_file_path_abs = cd(home_dir);

cd(path_of_cluster_tables);
cluster_table_path_abs = cd(home_dir);

for feature=1:1.5%length(feature_list)
    current_feature = feature_list(feature);
    for experiment1=1:1.5%length(experiment_list)
        current_experiment_1 = experiment_list(experiment1);
        list_of_clusters = get_clusters_list(cluster_table_path_abs,current_experiment_1,current_feature);
        if strcmpi(current_experiment_1,"Baseline")
            experiment_1_probabilities_table = find_rats_probabilities_for_spider_plots(path_of_cluster_tables,current_experiment_1,true,true,current_feature);
        else
            experiment_1_probabilities_table =find_rats_probabilities_for_spider_plots(path_of_cluster_tables,current_experiment_1,false,true,current_feature);
        end

        for experiment2=experiment1+1:length(experiment_list)
            current_experiment_2 = experiment_list(experiment2);
            if strcmpi(current_experiment_2,"Baseline")
                experiment_2_probabilities_table = find_rats_probabilities_for_spider_plots(path_of_cluster_tables,current_experiment_2,true,true,current_feature);
            else
                experiment_2_probabilities_table = find_rats_probabilities_for_spider_plots(path_of_cluster_tables,current_experiment_2,false,true,current_feature);
            end
            for outer_table_counter = 1:1.5%height(experiment_1_probabilities_table)
                rat_1 = string(experiment_1_probabilities_table{outer_table_counter,1});
                rat_1_probabilities = cell2mat(experiment_1_probabilities_table{outer_table_counter,2});
                for inner_table_counter=outer_table_counter+1:height(experiment_2_probabilities_table)
                    scrnsz = get(0,'ScreenSize');
                    figure('Position',scrnsz);
                    rat_2 = string(experiment_2_probabilities_table{inner_table_counter,1});
                    rat_2_probabilities = cell2mat(experiment_2_probabilities_table{inner_table_counter,2});
                    create_overlaid_spider_plots(fig_file_path_abs,list_of_clusters,[rat_1_probabilities;rat_2_probabilities],[strcat(current_experiment_1," ",rat_1),strcat(current_experiment_2, " ", rat_2)],"get_individual_rats_spider_plots.m");
                end
            end
        end

        
        

    end
end

end