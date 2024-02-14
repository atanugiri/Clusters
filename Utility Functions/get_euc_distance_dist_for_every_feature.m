function get_euc_distance_dist_for_every_feature(path_of_cluster_tables,experiment_list,features_to_exclude,fig_file_path,exclude_features_or_dont)
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
        [experiment_1_euc_dist] = find_euc_dist_for_all_features(path_of_cluster_tables,current_experiment_1,true,exclude_features_or_dont,features_to_exclude);
    else
        [experiment_1_euc_dist] = find_euc_dist_for_all_features(path_of_cluster_tables,current_experiment_1,false,exclude_features_or_dont,features_to_exclude);
    end
    

    for j=experiment1+1:length(experiment_list)
        current_experiment_2 = experiment_list(j);

        if strcmpi(current_experiment_2,"Baseline")
            [experiment_2_euc_dist] = find_euc_dist_for_all_features(path_of_cluster_tables,current_experiment_2,true,exclude_features_or_dont,features_to_exclude);
        else
            [experiment_2_euc_dist] = find_euc_dist_for_all_features(path_of_cluster_tables,current_experiment_2,false,exclude_features_or_dont,features_to_exclude);
        end

        figure;
        histogram(experiment_1_euc_dist,'Normalization','probability','BinEdges',0:0.05:3);
        hold on;
        histogram(experiment_2_euc_dist,'Normalization','probability','BinEdges',0:0.05:3);

        ylabel("Probability");
        xlabel("Euclidian Distance");

        [h,p] = kstest2(experiment_1_euc_dist,experiment_2_euc_dist);
        title(strcat(current_experiment_1, " Vs ", current_experiment_2, "All Features"));
        subtitle(strcat("From KS2Test we have h:",string(h)," p:", string(p)));

        legend(current_experiment_1,current_experiment_2)

        saveas(gcf,strcat(fig_file_path_abs,"\zzzz ",current_experiment_1, " Vs ", current_experiment_2, "All Features.fig"),'fig')
        % close(gcf)

    end




end
end

