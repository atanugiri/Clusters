function rebin_individual_rats_cluster_info(directory_of_cluster_tables,directory_for_rebinned_cluster_tables,list_of_experiments_to_check,number_of_bins)
directory_for_rebinned_cluster_tables_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_for_rebinned_cluster_tables);
cluster_table_path_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(directory_of_cluster_tables);
og_number_of_bins = number_of_bins;

for i=1:length(list_of_experiments_to_check)
    current_experiment = list_of_experiments_to_check(i);

    [map_of_each_rat_to_their_sessions,cluster_list]= get_map_of_rats_to_unique_sessions_list(cluster_table_path_abs,current_experiment);

    home_dir =cd(directory_for_rebinned_cluster_tables_abs);

    directory_for_experiment = create_a_file_if_it_doesnt_exist_and_ret_abs_path(current_experiment);
    cd(directory_for_experiment)

    all_keys = string(keys(map_of_each_rat_to_their_sessions).');



    for j=1:size(all_keys,1)
        current_rat = all_keys(j);
        current_rat_abs_path = create_a_file_if_it_doesnt_exist_and_ret_abs_path(current_rat);
        cd(current_rat_abs_path);

        current_rats_sessions = map_of_each_rat_to_their_sessions(current_rat);

        number_of_bins = og_number_of_bins;
        
        if length(current_rats_sessions)/number_of_bins < 1
            while length(current_rats_sessions)/number_of_bins<1
                number_of_bins=number_of_bins-1;
            end
        end

        for current_bin =1:number_of_bins
            name_of_current_bin = strcat("Bin ",string(current_bin)," of ",string(number_of_bins));
            current_bin_abs = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_current_bin);
            bin_path = cd(current_bin_abs);

            %determine the bin size
            %i've elected to increase the size of the first bin should the data not divide evenly into n bins
            if mod(length(current_rats_sessions),number_of_bins) ~= 0
                if current_bin==1
                    bin_size=ceil(length(current_rats_sessions)/number_of_bins);
                else
                    bin_size=floor(length(current_rats_sessions)/number_of_bins);
                end
            else
                bin_size = length(current_rats_sessions)/number_of_bins;
            end

            beginning_of_data = 1+((current_bin-1)*bin_size);
            end_of_data = current_bin * bin_size;
            if end_of_data > length(current_rats_sessions)
                dates_inside_current_bin = current_rats_sessions(beginning_of_data:end);
            else
                dates_inside_current_bin = current_rats_sessions(beginning_of_data:end_of_data);
            end
            


            for current_cluster=1:length(cluster_list)
                empty_table = cell2table(cell(0,3),'VariableNames',{'clusterLabels','clusterX','clusterY'}); %create empty table
                writetable(empty_table,strcat(current_rat,"_",cluster_list(current_cluster)));
            end

            for current_cluster=1:length(cluster_list)
                current_cluster_table = readtable(strcat(cluster_table_path_abs,"\",cluster_list(current_cluster)));
                current_cluster_table_for_only_current_rat = current_cluster_table(contains(current_cluster_table.clusterLabels,current_rat),:);
                names_and_dates_of_current_cluster_table_for_current_rat = split(string(current_cluster_table_for_only_current_rat.clusterLabels)," ",2);
                clc;
                display(names_and_dates_of_current_cluster_table_for_current_rat)
                if size(names_and_dates_of_current_cluster_table_for_current_rat,1) >0
                    just_dates = names_and_dates_of_current_cluster_table_for_current_rat(:,2);
                    just_dates = strrep(just_dates,".mat","");
                    just_dates = strtrim(just_dates);
                    only_data_of_current_bin = current_cluster_table_for_only_current_rat(ismember(just_dates,dates_inside_current_bin),:);
                    writetable(only_data_of_current_bin,strcat(current_rat,"_",cluster_list(current_cluster)),"WriteMode","append");
                end


            end
            cd(bin_path)
        end
        cd(directory_for_experiment);
    end
    cd(home_dir)
    
end
cd(home_dir)
end