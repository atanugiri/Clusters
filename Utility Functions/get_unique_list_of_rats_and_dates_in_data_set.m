function [unique_list_of_rats_in_data_set,unique_list_of_dates_in_data_set,all_files] = get_unique_list_of_rats_and_dates_in_data_set(cluster_table_path_abs,experiment)
    all_files = ls(strcat(cluster_table_path_abs,"\*",experiment,"*.xlsx"));
    all_files = string(all_files);
    all_cluster_tables_together = readtable(strcat(cluster_table_path_abs,"\",all_files(1)));
    for i=2:length(all_files)
        all_cluster_tables_together = [all_cluster_tables_together;readtable(strcat(cluster_table_path_abs,"\",all_files(i)))];

    end
    all_names_from_cluster_tables = all_cluster_tables_together.clusterLabels;
    all_names_from_cluster_tables = string(all_names_from_cluster_tables);

    all_names_from_cluster_tables = split(all_names_from_cluster_tables," ");
    all_dates_from_cluster_tables = all_names_from_cluster_tables(:,2);

    all_dates_from_cluster_tables = strrep(all_dates_from_cluster_tables,".mat"," ");
    all_dates_from_cluster_tables = strtrim(all_dates_from_cluster_tables);
    % all_dates_from_cluster_tables = sort(all_dates_from_cluster_tables);

    all_names_from_cluster_tables = all_names_from_cluster_tables(:,1);
    all_names_from_cluster_tables = sort(all_names_from_cluster_tables);

    unique_list_of_rats_in_data_set = unique(all_names_from_cluster_tables);
    unique_list_of_dates_in_data_set = unique(all_dates_from_cluster_tables);

    month_day_year = split(unique_list_of_dates_in_data_set,"-");


    ids = 1:length(unique_list_of_dates_in_data_set);
    table_of_dates = table(month_day_year(:,1),month_day_year(:,2),month_day_year(:,3),ids.','VariableNames',{'month','day','year','id'});
    table_of_dates = sortrows(table_of_dates,[3,1,2]);

    unqiue_list_of_dates_in_data_set = strcat(table_of_dates{:,1},repelem("-",height(table_of_dates)).',table_of_dates{:,2},repelem("-",height(table_of_dates)).',table_of_dates{:,3});

    % all_files = strrep(all_files,".xlsx","");
    all_files = strtrim(all_files);
end