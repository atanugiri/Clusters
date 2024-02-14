function get_ind_rats_euc_distance_dist_from_each_other_all_features(path_of_cluster_tables,experiment_list,features_to_exclude,fig_file_path,exclude_features_or_dont)
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
            second_rat = strcat("Similar", second_rat);
        elseif p==2 %medium Closest
            second_rat = string(nearest_neighbor_table{round(height(nearest_neighbor_table)/2),2});
            second_rat_probabilities = table_of_probabilities(strcmpi(table_of_probabilities.subject_id,second_rat),:);
            second_rat_probabilities = second_rat_probabilities{1,2};
            second_rat_probabilities = cell2mat(second_rat_probabilities);

            first_rat = strcat("Somewhat Similar ",first_rat);
            second_rat = strcat("Somewhat Similar", second_rat);
        elseif p==3 %Furthest
            second_rat = string(nearest_neighbor_table{height(nearest_neighbor_table),2});
            second_rat_probabilities = table_of_probabilities(strcmpi(table_of_probabilities.subject_id,second_rat),:);
            second_rat_probabilities = second_rat_probabilities{1,2};
            second_rat_probabilities = cell2mat(second_rat_probabilities);
            first_rat = strcat("Not Similar ",first_rat);
            second_rat = strcat("Not Similar", second_rat);
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
    current_experiment = experiment_list(experiment1);
    % list_of_clusters = get_clusters_list(cluster_table_path_abs,current_experiment_1);
    if strcmpi(current_experiment,"Baseline")
        [experiment_1_euc_dist_map,~,~,~] = find_rats_euc_distance_for_spider_plots(path_of_cluster_tables,current_experiment,true,exclude_features_or_dont,features_to_exclude);
    else
        [experiment_1_euc_dist_map,~,~,~] =find_rats_euc_distance_for_spider_plots(path_of_cluster_tables,current_experiment,false,exclude_features_or_dont,features_to_exclude);
    end
    table_of_euc_distance = table(keys(experiment_1_euc_dist_map).',values(experiment_1_euc_dist_map).','VariableNames',{'subject_id','euc_dist_from_other_rats'});

    for j=1:height(table_of_euc_distance)
        rat_1 = string(table_of_euc_distance{j,1});
        rat_1_euc_distances = cell2mat(table_of_euc_distance{j,2});
        for k=j+1:height(table_of_euc_distance)
            rat_2 = string(table_of_euc_distance{k,1});
            rat_2_euc_distances = cell2mat(table_of_euc_distance{k,2});

            figure; hold on;
            histogram(rat_1_euc_distances,'normalization','probability','BinEdges',0:0.05:3);
            histogram(rat_2_euc_distances,'normalization','probability','BinEdges',0:0.05:3);

            legend(rat_1,rat_2);
            title(strcat(current_experiment," ", rat_1," Vs ", rat_2))
            ylabel("Probability");
            xlabel("Euclidian Distance");
            [h,p] = kstest2(rat_1_euc_distances,rat_2_euc_distances);

            the_title = strcat(current_experiment," ", rat_1," Vs ", rat_2);
            subtitle(strcat("From KSTEST2 we have h:",string(h)," p:",string(p)));

            saveas(gcf,strcat(fig_file_path_abs,the_title,".fig"),"fig");
            close(gcf);
        end
    end
end
end
