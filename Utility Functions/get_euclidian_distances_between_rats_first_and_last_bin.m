function get_euclidian_distances_between_rats_first_and_last_bin(rebinned_dirs,experiment_list,exclude_or_dont,features_to_exclude,directory_to_save_figs_to,number_of_bins)
    
    function filtered_list_of_features = filter_out_features_which_should_be_removed(list_of_unique_features,features_to_exclude)
        filtered_list_of_features = [];
        for current_feature_count = 1:length(list_of_unique_features)
            current_feature = list_of_unique_features(current_feature_count);
            feature_should_be_excluded = false;
            for current_feature_to_exclude_count=1:length(features_to_exclude)
                current_feature_to_exclude = features_to_exclude(current_feature_to_exclude_count);
                if strcmpi(current_feature_to_exclude,current_feature)
                    feature_should_be_excluded = true;
                    break;
                end

            end
            if ~feature_should_be_excluded
                filtered_list_of_features = [filtered_list_of_features;current_feature];
            end
        end
    end
    function list_of_unique_features= get_list_of_unique_features(directory_of_clusters)
        name_experiment_and_cluster = split(strtrim(string(ls(strcat(directory_of_clusters,"\*.xlsx"))))," ");
        feature_and_cluster_number = split(name_experiment_and_cluster(:,2),"_");
        just_feature = strcat(feature_and_cluster_number(:,1),repelem("_",size(feature_and_cluster_number,1)).');
        
        list_of_unique_features = unique(just_feature);

    end
    function table_of_cluster_counts_and_feature_size = get_size_of_each_data_set(list_of_unique_features,dir_of_clusters)
        table_of_cluster_counts_and_feature_size = cell2table(cell(0,4),'VariableNames',{'feature','cluster','cluster_count','size'});
        for current_feature=1:length(list_of_unique_features)
            list_of_clusters = strtrim(string(ls(strcat(dir_of_clusters{1,4},"\*",list_of_unique_features(current_feature),"*.xlsx"))));
            current_size = 0;
            all_sizes_for_current_clusters = [];
            for current_cluster=1:length(list_of_clusters)
                current_size = current_size + height(readtable(strcat(dir_of_clusters{1,4},"\",list_of_clusters(current_cluster))));
                all_sizes_for_current_clusters = [all_sizes_for_current_clusters;height(readtable(strcat(dir_of_clusters{1,4},"\",list_of_clusters(current_cluster))))];
            end
            size_column = zeros(length(all_sizes_for_current_clusters),1) + current_size;
            rows_to_add = table( ...
                repelem(list_of_unique_features(current_feature),length(all_sizes_for_current_clusters)).', ...
                (1:length(all_sizes_for_current_clusters)).', ...
                all_sizes_for_current_clusters, ...
                size_column, ...
                'VariableNames',{'feature','cluster','cluster_count','size'});


            table_of_cluster_counts_and_feature_size = [table_of_cluster_counts_and_feature_size;rows_to_add];
        end

        table_of_cluster_counts_and_feature_size
    end
    function vector_of_cluster_probabilities = get_vector_of_cluster_probabilities(clusters_dir,exclude_or_dont,features_to_exclude)
        list_of_unique_features = get_list_of_unique_features(clusters_dir{1,4});
        if exclude_or_dont
            list_of_unique_features = filter_out_features_which_should_be_removed(list_of_unique_features,features_to_exclude);
        end

        table_of_cluster_counts_and_feature_size = get_size_of_each_data_set(list_of_unique_features,clusters_dir);

        vector_of_cluster_probabilities = table_of_cluster_counts_and_feature_size.cluster_count ./ table_of_cluster_counts_and_feature_size.size ;

        vector_of_cluster_probabilities(isnan(vector_of_cluster_probabilities)) =0;


        
    end
    function dist_between_first_and_last = get_euc_dist(first_bin_clusters_dir,last_bin_clusters_dir,exclude_or_dont,features_to_exclude)

        cluster_probabilities_1 = get_vector_of_cluster_probabilities(first_bin_clusters_dir,exclude_or_dont,features_to_exclude);
        cluster_probabilities_1 = cluster_probabilities_1.';
        cluster_probabilities_2 = get_vector_of_cluster_probabilities(last_bin_clusters_dir,exclude_or_dont,features_to_exclude);
        cluster_probabilities_2 = cluster_probabilities_2.';

        dist_between_first_and_last = cluster_probabilities_1 - cluster_probabilities_2;
        dist_between_first_and_last = sqrt(dist_between_first_and_last * dist_between_first_and_last.');

        
    end
directory_to_save_figs_to_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_to_save_figs_to);
for i=1:length(experiment_list)
    current_experiment = experiment_list(i);
    table_with_only_current_experiment = rebinned_dirs(contains(rebinned_dirs.experiment,current_experiment),:);
    unique_rats = unique(table_with_only_current_experiment.subject_id);
    all_euc_distances = [];
    for j=1:length(unique_rats)
        current_rat = unique_rats(j);
        table_with_only_current_rat = table_with_only_current_experiment(contains(table_with_only_current_experiment.subject_id,current_rat),:);
        first_bin_clusters_dir = table_with_only_current_rat(1,:);
        last_bin_clusters_dir = table_with_only_current_rat(height(table_with_only_current_rat),:);
        all_euc_distances = [all_euc_distances;get_euc_dist(first_bin_clusters_dir,last_bin_clusters_dir,exclude_or_dont,features_to_exclude)];
    end

    figure;
    histogram(all_euc_distances,'Normalization','probability');
    xlabel("Euclidian Distance");
    ylabel("Bin Count");
    title(strrep(current_experiment,"_","\_"));
    subtitle(strcat("Euclidian Distance Between Individual Rat's 1st Bin Vs Last Bin"));

    saveas(gcf,strcat(directory_to_save_figs_to_abs,"\",current_experiment,".fig"),'fig')
    close(gcf);
end
end