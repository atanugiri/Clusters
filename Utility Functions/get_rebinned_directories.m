function table_of_all_dirs= get_rebinned_directories(dir_of_rebinned_data,experiment_list)
table_of_all_dirs = cell2table(cell(0,4),'VariableNames',{'subject_id','experiment','bin_number','directory'});
home_dir = cd(dir_of_rebinned_data);
dir_of_rebinned_data_abs = cd(home_dir);
cd(dir_of_rebinned_data_abs);

for i=1:length(experiment_list)
    current_experiment = experiment_list(i);
    cd(current_experiment);
    current_experiment_abs = cd(dir_of_rebinned_data_abs);
    cd(current_experiment_abs);

    all_directory_names = strtrim(string(ls(pwd)));

    for j=3:length(all_directory_names)
        current_rat = all_directory_names(j);
        cd(current_rat)
        current_rat_abs = cd(current_experiment_abs);
        cd(current_rat_abs);
        all_bin_directories = strtrim(string(ls(pwd)));
        for k=3:length(all_bin_directories)
            cd(all_bin_directories(k));
            single_row = table(current_rat,current_experiment,k-2,string(pwd),'VariableNames',{'subject_id','experiment','bin_number','directory'});
            table_of_all_dirs = [table_of_all_dirs;single_row];
            cd(current_rat_abs)
        end
        cd(current_experiment_abs)
    end


    cd(dir_of_rebinned_data_abs);
end

cd(home_dir);
end