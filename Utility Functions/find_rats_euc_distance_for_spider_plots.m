function [map_of_euc_distances,list_of_clusters,map_of_nearest_neighbors,table_of_probabilities] = find_rats_euc_distance_for_spider_plots(location_of_cluster_tables,experiment,excludeOrDont,exclude_features_or_dont,features_to_exclude)
    function [abs_path] = get_abs_file_path(rel_file_path)
        home_dir = cd(rel_file_path);
        abs_path = cd(home_dir);
    end
    function [filtered_list_of_clusters] = remove_features_from_list(list_of_clusters,features_to_remove)
        filtered_list_of_clusters = [];
        for i=1:length(list_of_clusters)
            contains_feature_to_remove = false;
            for j=1:length(features_to_remove)
                if contains(list_of_clusters(i),features_to_remove(j))
                    contains_feature_to_remove=true;
                end
            end
            if ~contains_feature_to_remove
                filtered_list_of_clusters = [filtered_list_of_clusters;list_of_clusters(i)];
            end
        end
    end
    function [list_of_clusters] = get_list_of_files(abs_path,experiment)
        list_of_clusters = ls(strcat(abs_path,"\*",experiment,"*.xlsx"));
        list_of_clusters = string(list_of_clusters);
        list_of_clusters = strtrim(list_of_clusters);
    end
    function [filtered_list] = filter_to_only_desired_variable(list_of_clusters,single_variable)
        filtered_list = [];
        for i=1:length(list_of_clusters)
            if contains(list_of_clusters(i),single_variable,'IgnoreCase',true)
                filtered_list = [filtered_list,list_of_clusters(i)];
            end
        end
    end
    function [unique_features] = get_only_unique_features(list_of_clusters)
        unique_features = split(list_of_clusters," ");
        unique_features = unique_features(:,2);
        unique_features = split(unique_features,"_");
        unique_features = unique_features(:,1);
        unique_features = unique(unique_features);
        unique_features = sort(unique_features);



    end
    function [entire_data_set_by_feature] = get_entire_data_set_for_each_feature(abs_path_of_cluster_tables,list_of_clusters)
        unique_features = get_only_unique_features(list_of_clusters);
        entire_data_set_by_feature = cell(1,length(unique_features));
        for i=1:length(unique_features)
            for j=1:length(list_of_clusters)
                if contains(list_of_clusters(j),unique_features{i},'IgnoreCase',true)
                    if isempty(entire_data_set_by_feature{i})
                        entire_data_set_by_feature{i} = readtable(strcat(abs_path_of_cluster_tables,"\",list_of_clusters(j)));
                    else
                        entire_data_set_by_feature{i} = [entire_data_set_by_feature{i};readtable(strcat(abs_path_of_cluster_tables,"\",list_of_clusters(j)))];
                    end
                end
            end
        end

    end
    function [unique_rats_in_data_set_by_feature] = get_unique_list_of_rats_in_data_Set(entire_data_set)
        unique_rats_in_data_set_by_feature = cell(1,length(entire_data_set));
        for i=1:length(entire_data_set)
            names_and_dates = entire_data_set{i}.clusterLabels;
            names_and_dates = string(names_and_dates);
            names_and_dates = split(names_and_dates," ");
            names = names_and_dates(:,1);
            % disp(names);
            unique_rats_in_data_set_by_feature{i} = unique(names);
        end
    end
    function [tables_of_rats_to_total_appearences_in_dataset] = count_how_many_times_rat_appear_in_entire_dataset(unique_list_of_rats_by_feature,entire_data_set)
        tables_of_rats_to_total_appearences_in_dataset = cell(1,length(unique_list_of_rats_by_feature));
        for k=1:length(unique_list_of_rats_by_feature)
            map_of_rats_to_number_of_appearences_in_data_set = containers.Map('KeyType','char','ValueType','any');
            just_names_from_data_set = entire_data_set{k}.clusterLabels;
            just_names_from_data_set = split(just_names_from_data_set," ");
            just_names_from_data_set = just_names_from_data_set(:,1);
            unique_list_of_rats = unique_list_of_rats_by_feature{k};
            for i=1:length(unique_list_of_rats)
                map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) = 0;
                for j=1:height(just_names_from_data_set)
                    if strcmpi(just_names_from_data_set(j),unique_list_of_rats(i))
                        map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) = map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) +1;
                    end
                end
            end
            table_of_rats_to_total_appearences_in_dataset = table(keys(map_of_rats_to_number_of_appearences_in_data_set).',values(map_of_rats_to_number_of_appearences_in_data_set).','VariableNames',{'subject_id','number_of_appearences'});
            tables_of_rats_to_total_appearences_in_dataset{k} = table_of_rats_to_total_appearences_in_dataset;
        end
    end
    function [filtered_list_of_rats_by_feature] = filter_rats_out(unique_list_of_rats_by_feature)
        oldRatList = ["aladdin", "alexis", "andrea", "carl",...
            "fiona", "harley", "jafar", "jimi", ...
            "johnny", "jr", "juana", "kobe",...
            "kryssia", "mike","neftali", "raissa", ...
            "raven", "renata", "sarah", "scar",...
            "shakira", "simba", "sully"];

        filtered_list_of_rats_by_feature = cell(1,length(unique_list_of_rats_by_feature));
        for k=1:length(unique_list_of_rats_by_feature)
            filtered_list_of_rats = [];
            unique_list_of_rats = unique_list_of_rats_by_feature{k};
            for i=1:length(unique_list_of_rats)
                outer_list_rat = unique_list_of_rats(i);
                % disp(outer_list_rat)
                for j=1:length(oldRatList)
                    inner_list_rat = oldRatList(j);
                    % disp(inner_list_rat)
                    if strcmpi(outer_list_rat,inner_list_rat)
                        filtered_list_of_rats = [filtered_list_of_rats,outer_list_rat];
                    end
                end
            end
            filtered_list_of_rats_by_feature{k} = filtered_list_of_rats;

        end
    end
    function [table_of_single_rats_appearences_in_each_cluster] = get_table_of_single_rats_appearences_in_each_cluster(rat,cluster_tables_list,list_of_clusters)
        table_of_single_rats_appearences_in_each_cluster = table("","",nan,'VariableNames',{'subject_id','cluster','number_of_appearences'});
        for i=1:length(cluster_tables_list)
            current_cluster = cluster_tables_list{i};
            current_cluster_names = current_cluster.clusterLabels;
            current_cluster_names = string(current_cluster_names);
            current_cluster_names = split(current_cluster_names," ");
            current_cluster_names = current_cluster_names(:,1);
            name_of_current_cluster = list_of_clusters(i);
            name_of_current_cluster = string(name_of_current_cluster);
            name_of_current_cluster = split(name_of_current_cluster," ");
            name_of_current_cluster = name_of_current_cluster(2);
            name_of_current_cluster = strrep(name_of_current_cluster,".xlsx","");

            
            current_rats_total_appearences_in_current_cluster = 0;
            for j=1:height(current_cluster)
                if strcmpi(rat,current_cluster_names(j))
                    current_rats_total_appearences_in_current_cluster = current_rats_total_appearences_in_current_cluster+1;
                end
            end
            table_of_current_rat = table(rat,name_of_current_cluster,current_rats_total_appearences_in_current_cluster,'VariableNames',{'subject_id','cluster','number_of_appearences'});
            % display(table_of_current_rat);
            table_of_single_rats_appearences_in_each_cluster = [table_of_single_rats_appearences_in_each_cluster;table_of_current_rat];
        end

    end
    function [table_of_rat_appearences] = count_how_many_times_rats_appear_in_each_cluster_by_feature(unique_list_of_rats_by_feature,list_of_clusters,abs_path)
        %populate the cluster tables
        list_of_clusters_tables = cell(1,length(list_of_clusters));
        for i=1:length(list_of_clusters_tables)
            list_of_clusters_tables{i} = readtable(strcat(abs_path,"\",list_of_clusters(i)));
        end

        %determine which rats rat list has the most rats in it, the one with the most should be a superset which contains all the others
        longest_list =unique_list_of_rats_by_feature{1};
        for i=1:length(unique_list_of_rats_by_feature)
            if length(unique_list_of_rats_by_feature{i}) > length(longest_list)
                longest_list = unique_list_of_rats_by_feature{i};
            end
        end
        unique_list_of_rats = longest_list;
        table_of_rat_appearences = table("","",nan,'VariableNames',{'subject_id','cluster','number_of_appearences'});

        for i=1:length(unique_list_of_rats)
            single_rats_appearences_per_cluster =get_table_of_single_rats_appearences_in_each_cluster(unique_list_of_rats(i),list_of_clusters_tables,list_of_clusters);
            table_of_rat_appearences = [table_of_rat_appearences;single_rats_appearences_per_cluster];
        end

        table_of_rat_appearences(strcmpi(table_of_rat_appearences.subject_id,""),:) = [];

    end
    function [table_of_probabilities] = get_probabilities_by_cluster(table_of_rats_total_appearences_by_data_set,table_of_rats_appearences_by_cluster,list_of_clusters)
        table_of_probabilities = table("","",0,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
        unique_features_to_be_used_for_dynamic_single_row_selection = get_only_unique_features(list_of_clusters);
        for i=1:height(table_of_rats_appearences_by_cluster)
            current_rat = table_of_rats_appearences_by_cluster{i,1};
            current_cluster = table_of_rats_appearences_by_cluster{i,2};
            current_number_of_appearences = table_of_rats_appearences_by_cluster{i,3};


            helpful_index =0;
            for p=1:length(unique_features_to_be_used_for_dynamic_single_row_selection)
                if contains(current_cluster,unique_features_to_be_used_for_dynamic_single_row_selection(p))
                    helpful_index=p;
                end
            end
            table_of_rats_total_appearences = table_of_rats_total_appearences_by_data_set{helpful_index};


            single_row = table_of_rats_total_appearences(strcmpi(table_of_rats_total_appearences.subject_id,current_rat),:);

            if ~(height(single_row)<1)
                current_rats_total_number_of_appearences = single_row{1,2};
                current_rats_total_number_of_appearences = current_rats_total_number_of_appearences{1};
                % disp(current_number_of_appearences)
                % disp(current_rats_total_number_of_appearences)
                current_cluster_probability = current_number_of_appearences / current_rats_total_number_of_appearences;
                % probabilityRow = table(current_rat,current_cluster,current_cluster_probability,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
                probabilityRow = table(current_rat,current_cluster,current_cluster_probability,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
                table_of_probabilities = [table_of_probabilities;probabilityRow];
            else
                current_cluster_probability = 0;
                probabilityRow = table(current_rat,current_cluster,current_cluster_probability,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
                table_of_probabilities = [table_of_probabilities;probabilityRow];
            end
        end
        table_of_probabilities(strcmpi(table_of_probabilities.subject_id,""),:) = [];
    end
    function [formatted_probabilities] = format_probabilities(table_of_probabilities)
        all_rats_in_probability_table = table_of_probabilities.subject_id;
        all_rats_in_probability_table = unique(all_rats_in_probability_table);
        map_of_rats_to_probability_vectors = containers.Map('KeyType','char','ValueType','any');

        for i=1:height(table_of_probabilities)
            current_rat = table_of_probabilities{i,1};
            if ~isKey(map_of_rats_to_probability_vectors,current_rat)
                map_of_rats_to_probability_vectors(current_rat) = [table_of_probabilities{i,3}];
            else
                map_of_rats_to_probability_vectors(current_rat) = [map_of_rats_to_probability_vectors(current_rat),table_of_probabilities{i,3}];
            end
        end

        formatted_probabilities = table(keys(map_of_rats_to_probability_vectors).',values(map_of_rats_to_probability_vectors).','VariableNames',{'subject_id','probability_vectors'});
        
    end
    function [map_of_rat_to_euc_dist_array,map_of_rat_to_nearest_neighbors_array] = get_euclidian_distances(table_of_probabilities)
        all_probabilities = [];
        map_of_rat_to_euc_dist_array = containers.Map('KeyType','char','ValueType','any');
        map_of_rat_to_nearest_neighbors_array = containers.Map('KeyType','char','ValueType','any');
        for i=1:height(table_of_probabilities)
            current_rat = table_of_probabilities{i,1};
            current_rat = string(current_rat);
            map_of_rat_to_euc_dist_array(current_rat) = [];
            map_of_rat_to_nearest_neighbors_array(current_rat) = [];
            all_probabilities = [all_probabilities;cell2mat(table_of_probabilities{i,2})];
        end

        for i=1:size(all_probabilities,1)
            first_vector = all_probabilities(i,:);
            current_rat = table_of_probabilities{i,1};
            current_rat = string(current_rat);
            for j=1:size(all_probabilities,1)
                second_vector = all_probabilities(j,:);
                second_rat = table_of_probabilities{j,1};
                second_rat = string(second_rat);
                if i~=j
                    euc_distance = first_vector-second_vector;
                    euc_distance = sqrt(euc_distance * euc_distance.');
                    map_of_rat_to_euc_dist_array(current_rat) = [map_of_rat_to_euc_dist_array(current_rat),euc_distance];
                    map_of_rat_to_nearest_neighbors_array(current_rat) = [map_of_rat_to_nearest_neighbors_array(current_rat),second_rat];
                end

            end
        end

    end

abs_location_of_cluster_tables = get_abs_file_path(location_of_cluster_tables);

list_of_clusters = get_list_of_files(abs_location_of_cluster_tables,experiment);

if exclude_features_or_dont
    list_of_clusters = remove_features_from_list(list_of_clusters,features_to_exclude);
end


% disp(list_of_clusters)

entire_data_set_by_feature = get_entire_data_set_for_each_feature(abs_location_of_cluster_tables,list_of_clusters);

unique_list_of_rats_in_data_by_feature = get_unique_list_of_rats_in_data_Set(entire_data_set_by_feature);

if excludeOrDont
    unique_list_of_rats_in_data_by_feature = filter_rats_out(unique_list_of_rats_in_data_by_feature);
end



table_of_rats_to_their_appearences_in_data_set = count_how_many_times_rat_appear_in_entire_dataset(unique_list_of_rats_in_data_by_feature,entire_data_set_by_feature);

table_of_rats_appearences_in_data_set_per_cluster = count_how_many_times_rats_appear_in_each_cluster_by_feature(unique_list_of_rats_in_data_by_feature,list_of_clusters,abs_location_of_cluster_tables);

table_of_probabilities = get_probabilities_by_cluster(table_of_rats_to_their_appearences_in_data_set,table_of_rats_appearences_in_data_set_per_cluster,list_of_clusters);

% disp(table_of_probabilities);
table_of_probabilities = format_probabilities(table_of_probabilities);
% disp(table_of_probabilities);

[map_of_euc_distances,map_of_nearest_neighbors ]= get_euclidian_distances(table_of_probabilities);

end