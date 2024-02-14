function get_euc_dist_between_rats_first_and_last_bin_for_sp_plts( ...
    rebinned_dirs, ...
    experiment_list, ...
    exclude_or_dont, ...
    features_to_exclude, ...
    directory_to_save_figs_to, ...
    filter_rats_out)
    function filtered_list_of_clusters = filter_out_clusters(list_of_clusters,features_to_exclude)
        filtered_list_of_clusters = [];
        for current_cluster_count = 1:length(list_of_clusters)
            current_cluster = list_of_clusters(current_cluster_count);
            cluster_should_be_excluded = false;
            for current_cluster_to_exclude_count=1:length(features_to_exclude)
                current_cluster_to_exclude = features_to_exclude(current_cluster_to_exclude_count);
                if contains(current_cluster,current_cluster_to_exclude)
                    cluster_should_be_excluded = true;
                    break;
                end

            end
            if ~cluster_should_be_excluded
                filtered_list_of_clusters = [filtered_list_of_clusters;current_cluster];
            end
        end
    end
    function clusters_list = get_clusters_list(file_path_with_clusters,exclude_features_or_dont,features_to_exclude)
        list_of_clusters= strtrim(string(ls(strcat(file_path_with_clusters,"\*.xlsx"))));
        subject_id_experiment_and_cluster = split(list_of_clusters," ");
        just_clusters = subject_id_experiment_and_cluster(:,2);
        just_clusters = strtrim(strrep(just_clusters,".xlsx",""));
        if exclude_features_or_dont
            clusters_list = filter_out_clusters(just_clusters,features_to_exclude);
        end
        clusters_list = strrep(clusters_list,"_","\_");
        strtrim(clusters_list);


    end
    function filtered_list_of_rats = filter_down_to_just_desired_rats(unique_list_of_rats)
        oldRatList = ["aladdin", "alexis", "andrea", "carl",...
            "fiona", "harley", "jafar", "jimi", ...
            "johnny", "jr", "juana", "kobe",...
            "kryssia", "mike","neftali", "raissa", ...
            "raven", "renata", "sarah", "scar",...
            "shakira", "simba", "sully"];

        filtered_list_of_rats = [];
        for p=1:length(unique_list_of_rats)
            outer_list_rat = unique_list_of_rats(p);
            % disp(outer_list_rat)
            for q=1:length(oldRatList)
                inner_list_rat = oldRatList(q);
                % disp(inner_list_rat)
                if strcmpi(outer_list_rat,inner_list_rat)
                    filtered_list_of_rats = [filtered_list_of_rats,outer_list_rat];
                end
            end
        end



    end
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
    function [dist_between_first_and_last,cluster_probabilities_1,cluster_probabilities_2] = get_euc_dist(first_bin_clusters_dir,last_bin_clusters_dir,exclude_or_dont,features_to_exclude)

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
    mkdir(strcat(directory_to_save_figs_to_abs,"\",current_experiment));
    home_dir = cd(strcat(directory_to_save_figs_to_abs,"\",current_experiment));
    experiment_dir_abs = cd(home_dir);
    table_with_only_current_experiment = rebinned_dirs(contains(rebinned_dirs.experiment,current_experiment),:);
    unique_rats = unique(table_with_only_current_experiment.subject_id);
    if strcmpi(current_experiment,"Baseline") && filter_rats_out
        unique_rats = filter_down_to_just_desired_rats(unique_rats);
    end
    if exclude_or_dont
        clusters_list = get_clusters_list(rebinned_dirs{1,4},exclude_or_dont,features_to_exclude);
    end
    all_euc_distances =containers.Map('KeyType','char','ValueType','any');
    all_first_prob_vectors = containers.Map('KeyType','char','ValueType','any');
    all_last_prob_vectors = containers.Map('KeyType','char','ValueType','any'); 
    for j=1:length(unique_rats)
        current_rat = unique_rats(j);
        table_with_only_current_rat = table_with_only_current_experiment(contains(table_with_only_current_experiment.subject_id,current_rat),:);
        first_bin_clusters_dir = table_with_only_current_rat(1,:);
        last_bin_clusters_dir = table_with_only_current_rat(height(table_with_only_current_rat),:);
        [dist_between_first_and_last,cluster_probabilities_1,cluster_probabilities_2]= get_euc_dist(first_bin_clusters_dir,last_bin_clusters_dir,exclude_or_dont,features_to_exclude);

         all_euc_distances(current_rat) = dist_between_first_and_last;
         all_first_prob_vectors(current_rat) = cluster_probabilities_1;
         all_last_prob_vectors(current_rat) = cluster_probabilities_2;
    end

    table_of_all_rats_euc_distances = table(string(keys(all_euc_distances).'), ...
        cell2mat(values(all_euc_distances).'), ...
        cell2mat(values(all_first_prob_vectors).'), ...
        cell2mat(values(all_last_prob_vectors).'), ...
        'VariableNames',{'subject_id','euc_distance','first_prob_vect','sec_prob_vector'});

    table_of_all_rats_euc_distances = sortrows(table_of_all_rats_euc_distances,"euc_distance");

    for m=1:height(table_of_all_rats_euc_distances)
        first_rat_probabilities = table_of_all_rats_euc_distances{m,3};
        second_rat_probabilities = table_of_all_rats_euc_distances{m,4};

        create_overlaid_spider_plots_for_single_rat(experiment_dir_abs, ...
        clusters_list,[first_rat_probabilities;second_rat_probabilities], ...
        [strcat(current_experiment," Early Bin ",table_of_all_rats_euc_distances{m,1}),strcat(current_experiment, " Late Bin ", table_of_all_rats_euc_distances{m,1})], ...
        "get_euc_dist_between_rats_first_and_last_bin_for_sp_plts.m",m);
    end
    
end
end