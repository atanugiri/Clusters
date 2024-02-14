function rebin_cluster_tables(directory_of_cluster_tables,directory_for_rebinned_cluster_tables,list_of_experiments_to_check,bin_size)
directory_for_rebinned_cluster_tables_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_for_rebinned_cluster_tables);
cluster_table_path_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_of_cluster_tables);

for i=1:length(list_of_experiments_to_check)
    current_experiment = list_of_experiments_to_check(i);

    [unique_rat_list_for_current_experiment,unique_date_list_for_current_experiment,cluster_list]= get_unique_list_of_rats_and_dates_in_data_set(cluster_table_path_abs,current_experiment);

    home_dir =cd(directory_for_rebinned_cluster_tables_abs);

    directory_for_experiment = create_a_file_if_it_doesnt_exist_and_ret_abs_path(current_experiment);
    cd(directory_for_experiment)

    for current_bin=1:ceil(length(unique_date_list_for_current_experiment)/bin_size)

        bin_folder_name = strcat("Bin ", string(current_bin)," Of ", string(bin_size), " Days");
        bin_folder_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(bin_folder_name);
        cd(bin_folder_abs);

        for rat_counter=1:length(unique_rat_list_for_current_experiment)
            current_rat = unique_rat_list_for_current_experiment(rat_counter);
            current_rat_path_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(current_rat);
            cd(current_rat_path_abs);

            for date_counter=1+((current_bin-1)*(bin_size)):(current_bin*bin_size)
                if date_counter > length(unique_date_list_for_current_experiment)
                    continue;
                end
                current_date = unique_date_list_for_current_experiment(date_counter);

                for current_cluster=1:length(cluster_list)
                    empty_table = cell2table(cell(0,3),'VariableNames',{'clusterLabels','clusterX','clusterY'}); %create empty table
                    writetable(empty_table,strcat(current_rat," ",cluster_list(current_cluster)));
                end

                for current_cluster=1:length(cluster_list)
                    current_cluster_table = readtable(strcat(cluster_table_path_abs,"\",cluster_list(current_cluster)));
                    

                    for current_row=1:height(current_cluster_table)
                        if contains(current_cluster_table{current_row,1},current_rat) && contains(current_cluster_table{current_row,1},current_date)
                            single_row = current_cluster_table(current_row,:);
                            writetable(single_row,strcat(current_rat," ",cluster_list(current_cluster)),"WriteMode","append");
                        end
                    end

                end

            end
            cd(bin_folder_abs)

        end
        cd(directory_for_experiment);





        % end
    end
    cd(home_dir)
    
end
cd(home_dir)
end