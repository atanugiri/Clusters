%locationOfFoodDepData = 'C:\Users\ldd77\OneDrive\Desktop\UTEP-Brain-Computation-Lab-Remote-Databases-and-Serendipity-App\Create Probability Tables\Food Deprivation';
% locationOfFoodDepData = 'C:\Users\ldd77\OneDrive\Desktop\UTEP-Brain-Computation-Lab-Remote-Databases-and-Serendipity-App\Create Probability Tables\Baseline Clusters';

function [all_euclidian_distances] = findEuclidianDistancesOfAllRatsFromEachOtherByExperiment(location_of_cluster_tables,experiment,excludeOrDont,onlyDoSingleVariable,singleVariable)
    function [abs_path] = get_abs_file_path(rel_file_path)
        home_dir = cd(rel_file_path);
        abs_path = cd(home_dir);
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
    function [entire_data_set] = get_entire_data_set(abs_path_of_cluster_tables,list_of_clusters)
        entire_data_set = readtable(strcat(abs_path_of_cluster_tables,"\",list_of_clusters(1)));
        for data_set_counter=2:length(list_of_clusters)
            entire_data_set = [entire_data_set;readtable(strcat(abs_path_of_cluster_tables,"\",list_of_clusters(data_set_counter)))];
        end

        % disp(entire_data_set)

    end
    function [unique_rats_in_data_set] = get_unique_list_of_rats_in_data_Set(entire_data_set)
        names_and_dates = entire_data_set.clusterLabels;
        names_and_dates = string(names_and_dates);
        names_and_dates = split(names_and_dates," ");
        names = names_and_dates(:,1);
        % disp(names);
        unique_rats_in_data_set = unique(names);
    end
    function [table_of_rats_to_total_appearences_in_dataset] = count_how_many_times_rat_appear_in_entire_dataset(unique_list_of_rats,entire_data_set)
        map_of_rats_to_number_of_appearences_in_data_set = containers.Map('KeyType','char','ValueType','any');
        just_names_from_data_set = entire_data_set.clusterLabels;
        just_names_from_data_set = split(just_names_from_data_set," ");
        just_names_from_data_set = just_names_from_data_set(:,1);

        for i=1:length(unique_list_of_rats)
            map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) = 0;
            for j=1:height(just_names_from_data_set)
                if strcmpi(just_names_from_data_set(j),unique_list_of_rats(i))
                    map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) = map_of_rats_to_number_of_appearences_in_data_set(unique_list_of_rats(i)) +1;
                end
            end
        end
        table_of_rats_to_total_appearences_in_dataset = table(keys(map_of_rats_to_number_of_appearences_in_data_set).',values(map_of_rats_to_number_of_appearences_in_data_set).','VariableNames',{'subject_id','number_of_appearences'});
    end
    function [filtered_list_of_rats] = filter_rats_out(unique_list_of_rats)
        oldRatList = ["aladdin", "alexis", "andrea", "carl",...
            "fiona", "harley", "jafar", "jimi", ...
            "johnny", "jr", "juana", "kobe",...
            "kryssia", "mike","neftali", "raissa", ...
            "raven", "renata", "sarah", "scar",...
            "shakira", "simba", "sully"];

        filtered_list_of_rats = [];
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
    function [table_of_rat_appearences] = count_how_many_times_rats_appear_in_each_cluster(unique_list_of_rats,list_of_clusters,abs_path)
        list_of_cluster_tables = cell(1,length(list_of_clusters));
        table_of_rat_appearences = table("","",nan,'VariableNames',{'subject_id','cluster','number_of_appearences'});
        for i=1:length(list_of_cluster_tables)
            list_of_clusters_tables{i} = readtable(strcat(abs_path,"\",list_of_clusters(i)));
        end
        for i=1:length(unique_list_of_rats)
            single_rats_appearences_per_cluster =get_table_of_single_rats_appearences_in_each_cluster(unique_list_of_rats(i),list_of_clusters_tables,list_of_clusters);
            table_of_rat_appearences = [table_of_rat_appearences;single_rats_appearences_per_cluster];
        end

        table_of_rat_appearences(strcmpi(table_of_rat_appearences.subject_id,""),:) = [];
    end
    function [table_of_probabilities] = get_probabilities_by_cluster(table_of_rats_total_appearences,table_of_rats_appearences_by_cluster)
        table_of_probabilities = table("","",0,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
        for i=1:height(table_of_rats_appearences_by_cluster)
            current_rat = table_of_rats_appearences_by_cluster{i,1};
            current_cluster = table_of_rats_appearences_by_cluster{i,2};
            current_number_of_appearences = table_of_rats_appearences_by_cluster{i,3};
            single_row = table_of_rats_total_appearences(strcmpi(table_of_rats_total_appearences.subject_id,current_rat),:);
            current_rats_total_number_of_appearences = single_row{1,2};
            current_rats_total_number_of_appearences = current_rats_total_number_of_appearences{1};
            % disp(current_number_of_appearences)
            % disp(current_rats_total_number_of_appearences)
            current_cluster_probability = current_number_of_appearences / current_rats_total_number_of_appearences;
            % probabilityRow = table(current_rat,current_cluster,current_cluster_probability,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
            probabilityRow = table(current_rat,current_cluster,current_cluster_probability,'VariableNames',{'subject_id','cluster','probability_of_appearence'});
            table_of_probabilities = [table_of_probabilities;probabilityRow];
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
    function [all_euclidian_distances] = get_euclidian_distances(table_of_probabilities)
        all_probabilities = [];
        all_euclidian_distances = [];
        for i=1:height(table_of_probabilities)
            all_probabilities = [all_probabilities;cell2mat(table_of_probabilities{i,2})];
        end
        % disp(table_of_probabilities)
        % disp(all_probabilities);
        % size(all_probabilities,1)
        
        for i=1:size(all_probabilities,1)
            first_vector = all_probabilities(i,:);
            for j=i+1:size(all_probabilities,1)
                second_vector = all_probabilities(j,:);

                euc_distance = first_vector-second_vector;
                euc_distance = sqrt(euc_distance * euc_distance.');
                all_euclidian_distances = [all_euclidian_distances,euc_distance];

            end
        end
        
    end

abs_location_of_cluster_tables = get_abs_file_path(location_of_cluster_tables);

list_of_clusters = get_list_of_files(abs_location_of_cluster_tables,experiment);

if onlyDoSingleVariable
    list_of_clusters = filter_to_only_desired_variable(list_of_clusters,singleVariable);
end
% disp(list_of_clusters)

entire_data_set = get_entire_data_set(abs_location_of_cluster_tables,list_of_clusters);

unique_list_of_rats_in_data_set = get_unique_list_of_rats_in_data_Set(entire_data_set);

if excludeOrDont
    unique_list_of_rats_in_data_set = filter_rats_out(unique_list_of_rats_in_data_set);
end

table_of_rats_to_their_appearences_in_data_set = count_how_many_times_rat_appear_in_entire_dataset(unique_list_of_rats_in_data_set,entire_data_set);

table_of_rats_appearences_in_data_set_per_cluster = count_how_many_times_rats_appear_in_each_cluster(unique_list_of_rats_in_data_set,list_of_clusters,abs_location_of_cluster_tables);

table_of_probabilities = get_probabilities_by_cluster(table_of_rats_to_their_appearences_in_data_set,table_of_rats_appearences_in_data_set_per_cluster);

% disp(table_of_probabilities);
table_of_probabilities = format_probabilities(table_of_probabilities);
% disp(table_of_probabilities);

all_euclidian_distances = get_euclidian_distances(table_of_probabilities);
% disp(all_euclidian_distances)


end