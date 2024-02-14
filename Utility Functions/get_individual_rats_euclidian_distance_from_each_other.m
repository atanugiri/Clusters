function get_individual_rats_euclidian_distance_from_each_other(path_of_cluster_tables,experiment_list,features_to_exclude,fig_file_path,exclude_features_or_dont)
    function [list_of_clusters]  = get_clusters_list(unformatted_list_of_clusters,experiment)
        list_of_clusters = string(unformatted_list_of_clusters);
        list_of_clusters = strrep(list_of_clusters,".xlsx","");
        list_of_clusters = strrep(list_of_clusters,experiment," ");
        list_of_clusters = strrep(list_of_clusters,"_","\_");
        list_of_clusters = strtrim(list_of_clusters);
    end

    function [all_rats,all_rats_nn_table_sorted] = find_furthest_closest_and_med_neighbors_for_each_rat(map_of_nn,map_of_euc_dist)
        all_rats = keys(map_of_nn).';
        all_rats = string(all_rats);
        all_rats_nn_table_sorted = cell(1,length(all_rats));

        for i=1:length(all_rats)
            current_rat = all_rats(i);
            table_of_current_rats_euclidian_distances_and_nn = table(map_of_euc_dist(current_rat).',map_of_nn(current_rat).','VariableNames',{'Euc_Distance','From_which_rat'});
            table_of_current_rats_euclidian_distances_and_nn = sortrows(table_of_current_rats_euclidian_distances_and_nn,"Euc_Distance");

            all_rats_nn_table_sorted{i} = table_of_current_rats_euclidian_distances_and_nn;
        end
        
    end
    function get_comparison(p,nearest_neighbor_table,table_of_probabilities,first_rat,clusters_list,current_experiment_1,fig_file_path_abs)
        first_rat_probabilities = table_of_probabilities{strcmpi(table_of_probabilities.subject_id,first_rat),2};
        first_rat_probabilities = cell2mat(first_rat_probabilities);
        if p==1 % closest
            second_rat = string(nearest_neighbor_table{1,2});
            second_rat_probabilities = table_of_probabilities(strcmpi(table_of_probabilities.subject_id,second_rat),:);
            second_rat_probabilities = second_rat_probabilities{1,2};
            second_rat_probabilities = cell2mat(second_rat_probabilities);

            first_rat = strcat("Similar ",first_rat);
            second_rat = strcat("Similar ", second_rat);
        elseif p==2 %medium Closest
            second_rat = string(nearest_neighbor_table{round(height(nearest_neighbor_table)/2),2});
            second_rat_probabilities = table_of_probabilities(strcmpi(table_of_probabilities.subject_id,second_rat),:);
            second_rat_probabilities = second_rat_probabilities{1,2};
            second_rat_probabilities = cell2mat(second_rat_probabilities);

            first_rat = strcat("Somewhat Similar ",first_rat);
            second_rat = strcat("Somewhat Similar ", second_rat);
        elseif p==3 %Furthest
            second_rat = string(nearest_neighbor_table{height(nearest_neighbor_table),2});
            second_rat_probabilities = table_of_probabilities(strcmpi(table_of_probabilities.subject_id,second_rat),:);
            second_rat_probabilities = second_rat_probabilities{1,2};
            second_rat_probabilities = cell2mat(second_rat_probabilities);
            first_rat = strcat("Not Similar ",first_rat);
            second_rat = strcat("Not Similar ", second_rat);
        end

        
        create_overlaid_spider_plots(fig_file_path_abs,clusters_list,[first_rat_probabilities;second_rat_probabilities],[strcat(current_experiment_1," ",first_rat),strcat(current_experiment_1, " ", second_rat)],"get_individual_rats_euclidian_distance_from_each_other.m");

    end

if ~exist(fig_file_path,"dir")
    mkdir(fig_file_path)
end
home_dir = cd(fig_file_path);
fig_file_path_abs = cd(home_dir);

cd(path_of_cluster_tables);
cluster_table_path_abs = cd(home_dir);

for experiment1=1:length(experiment_list)
    current_experiment_1 = experiment_list(experiment1);
    % list_of_clusters = get_clusters_list(cluster_table_path_abs,current_experiment_1);
    if strcmpi(current_experiment_1,"Baseline")
        [experiment_1_euc_dist_map,clusters_list,map_of_nn,table_of_probabilities] = find_rats_euc_distance_for_spider_plots(path_of_cluster_tables,current_experiment_1,true,exclude_features_or_dont,features_to_exclude);
    else
        [experiment_1_euc_dist_map,clusters_list,map_of_nn,table_of_probabilities] =find_rats_euc_distance_for_spider_plots(path_of_cluster_tables,current_experiment_1,false,exclude_features_or_dont,features_to_exclude);
    end
    clusters_list = get_clusters_list(clusters_list,current_experiment_1);
    [list_of_rats,array_of_nearest_neighbor_tables]= find_furthest_closest_and_med_neighbors_for_each_rat(map_of_nn,experiment_1_euc_dist_map);

    for rat_counter=1:length(list_of_rats)
        for p=1:3
            random_sample = rat_counter;
            first_rat = list_of_rats(random_sample);
            nearest_neighbor_table = array_of_nearest_neighbor_tables{random_sample};
            get_comparison(p,nearest_neighbor_table,table_of_probabilities,first_rat,clusters_list,current_experiment_1,fig_file_path_abs);

        end
    end

    % for outer_table_counter = 1:height(experiment_1_euc_dist)
    %     rat_1 = string(experiment_1_euc_dist{outer_table_counter,1});
    %     rat_1_probabilities = cell2mat(experiment_1_euc_dist{outer_table_counter,2});
    %     for inner_table_counter=outer_table_counter+1:height(experiment_1_euc_dist)
    %         scrnsz = get(0,'ScreenSize');
    %         figure('Position',scrnsz);
    %         rat_2 = string(experiment_1_euc_dist{inner_table_counter,1});
    %         rat_2_probabilities = cell2mat(experiment_1_euc_dist{inner_table_counter,2});
    %         create_overlaid_spider_plots(fig_file_path_abs,clusters_list,[rat_1_probabilities;rat_2_probabilities],[strcat(current_experiment_1," ",rat_1),strcat(current_experiment_1, " ", rat_2)],"get_individual_rats_spider_plots_for_every_feature.m");
    %     end
    % end



end
end
