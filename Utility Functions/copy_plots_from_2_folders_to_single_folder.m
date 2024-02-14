function copy_plots_from_2_folders_to_single_folder(first_path_of_files,second_path_of_files,path_to_copy_files_to)
    function [first,second,third] = get_abs_file_paths(first_path_of_files,second_path_of_files,path_to_copy_files_to)
        home_dir = cd(first_path_of_files);
        first = cd(home_dir);
        cd(second_path_of_files)
        second = cd(home_dir);
        cd(path_to_copy_files_to)
        third = cd(home_dir);
    end
    function [list_of_files] = get_list_of_files_to_match_to(given_file_path)
        files_to_match_to = ls(strcat(given_file_path,"\*.fig"));
        files_to_match_to = string(files_to_match_to);
        files_to_match_to = strtrim(files_to_match_to);
        info_from_files = split(files_to_match_to, "Similar");
        where_to_get_experiment_from = info_from_files(:,1);
        % where_to_get_experiment_from = strtrim(where_to_get_experiment_from);

        for i=1:length(where_to_get_experiment_from)
            current_string = where_to_get_experiment_from(i);
            % disp(current_string)
            if count(current_string, " ")>1
                where_to_get_experiment_from(i) = strtrim(where_to_get_experiment_from(i));
            end
        end
        where_to_get_experiment_from = split(where_to_get_experiment_from, " ");

        experiment = where_to_get_experiment_from(:,1);

        where_to_get_first_name_from = info_from_files(:,2);
        first_names = split(where_to_get_first_name_from,"vs");
        first_names = first_names(:,1);
        first_names = strtrim(first_names);

        where_to_get_second_name_from = info_from_files(:,3);
        second_names = split(where_to_get_second_name_from,"Spider");
        second_names = second_names(:,1);
        second_names = strtrim(second_names);

        list_of_files = {experiment,first_names,second_names};


    end
    function copy_the_files(first_path_of_files_abs,second_path_of_files_abs,path_to_copy_files_to_abs,list_of_files)
        list_of_files_from_first_path = strtrim(string(ls(strcat(first_path_of_files_abs,"\*.fig"))));
        list_of_files_from_second_path = strtrim(string(ls(strcat(second_path_of_files_abs,"\*.fig"))));

        experiments = list_of_files{1};
        first_names = list_of_files{2};
        second_names = list_of_files{3};

        for i=1:length(list_of_files_from_first_path)
            experiment = experiments(i);
            first_name = first_names(i);
            second_name = second_names(i);
            first_file = list_of_files_from_first_path(i);
            for j=1:length(list_of_files_from_second_path)
                second_file = list_of_files_from_second_path(j);
                if contains(second_file,experiment) && contains(second_file,first_name) && contains(second_file,second_name)
                    copyfile(strcat(first_path_of_files_abs,"\",first_file),strcat(path_to_copy_files_to_abs,"\",experiment," ", first_name," ", second_name," Spider Plot.fig"))
                    copyfile(strcat(second_path_of_files_abs,"\",second_file),strcat(path_to_copy_files_to_abs,"\",experiment," ", first_name," ", second_name," Histogram.fig"))
                end

            end
        end

    end

[first_path_of_files_abs,second_path_of_files_abs,path_to_copy_files_to_abs] = get_abs_file_paths(first_path_of_files,second_path_of_files,path_to_copy_files_to);

list_of_files = get_list_of_files_to_match_to(first_path_of_files_abs);

copy_the_files(first_path_of_files_abs,second_path_of_files_abs,path_to_copy_files_to_abs,list_of_files)

end