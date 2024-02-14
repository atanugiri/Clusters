function [map_of_individual_rats_to_sessions,all_files] = get_map_of_rats_to_unique_sessions_list(cluster_table_path_abs,experiment)
    all_files = ls(strcat(cluster_table_path_abs,"\*",experiment,"*.xlsx"));
    all_files = string(all_files);
    all_cluster_tables_together = readtable(strcat(cluster_table_path_abs,"\",all_files(1)));

    % get all data necessary
    for i=2:length(all_files)
        all_cluster_tables_together = [all_cluster_tables_together;readtable(strcat(cluster_table_path_abs,"\",all_files(i)))];

    end

    
    all_names_and_dates_from_cluster_tables = all_cluster_tables_together.clusterLabels;
    all_names_and_dates_from_cluster_tables = string(all_names_and_dates_from_cluster_tables);
    all_names_and_dates_from_cluster_tables = strrep(all_names_and_dates_from_cluster_tables,".mat","");
    all_names_and_dates_from_cluster_tables = strtrim(all_names_and_dates_from_cluster_tables);
    all_names_and_dates_from_cluster_tables = split(all_names_and_dates_from_cluster_tables, " ");
    all_names_from_cluster_tables = all_names_and_dates_from_cluster_tables(:,1);
    all_dates_from_cluster_tables = all_names_and_dates_from_cluster_tables(:,2);

    all_unique_names_from_cluster_tables = unique(all_names_from_cluster_tables);
    map_of_individual_rats_to_sessions = containers.Map('KeyType','char','ValueType','any');

    %add all rats which exist in the data to the map
    for i=1:length(all_unique_names_from_cluster_tables)
        map_of_individual_rats_to_sessions(all_unique_names_from_cluster_tables(i)) = [];
    end

    %get all dates which appear for eachr at
    for i=1:size(all_names_and_dates_from_cluster_tables,1)
        map_of_individual_rats_to_sessions(all_names_from_cluster_tables(i)) = [map_of_individual_rats_to_sessions(all_names_from_cluster_tables(i));all_dates_from_cluster_tables(i)];
    end

    all_keys = string(keys(map_of_individual_rats_to_sessions).');

    %get only unique dates for each rat
    for i=1:size(all_keys,1)
        map_of_individual_rats_to_sessions(all_keys(i)) = unique(map_of_individual_rats_to_sessions(all_keys(i)));
    end

    %organzie each rat's unique dates chronologically
    for i=1:size(all_keys,1)
        unique_list_of_dates_in_data_set = map_of_individual_rats_to_sessions(all_keys(i));
        month_day_year = split(unique_list_of_dates_in_data_set,"-");

        ids = 1:length(unique_list_of_dates_in_data_set);
        table_of_dates = table(month_day_year(:,1),month_day_year(:,2),month_day_year(:,3),ids.','VariableNames',{'month','day','year','id'});
        sorted_table_of_dates = sortrows(table_of_dates,[3,1,2]);

        unique_list_of_dates_in_data_set = strcat(sorted_table_of_dates{:,1},repelem("-",height(sorted_table_of_dates)).',sorted_table_of_dates{:,2},repelem("-",height(sorted_table_of_dates)).',sorted_table_of_dates{:,3});

        map_of_individual_rats_to_sessions(all_keys(i)) = unique_list_of_dates_in_data_set;

    end
    all_files = strtrim(all_files);
end