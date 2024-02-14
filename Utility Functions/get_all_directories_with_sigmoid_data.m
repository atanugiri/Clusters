function [all_directories_with_sigmoid_data] = get_all_directories_with_sigmoid_data(directory_with_experiment_sigmoid_data_relative,feature)
% addpath('Utility Functions\')

%% get absolute file paths for various required folders
homeDir = cd(directory_with_experiment_sigmoid_data_relative);
directory_with_experiment_sigmoid_data_absolute = cd(homeDir);
cd(directory_with_experiment_sigmoid_data_absolute);
list_of_experiment_directories = ls;
list_of_experiment_directories = string(list_of_experiment_directories);

%% get all directories with desired information
all_directories_with_sigmoid_data = containers.Map('KeyType','char','ValueType','any');
for i=1:length(list_of_experiment_directories)
    if ~strcmpi(strrep(list_of_experiment_directories(i,:)," ",""),".") && ~strcmpi(strrep(list_of_experiment_directories(i,:)," ",""),"..")
        disp(list_of_experiment_directories(i,:));
        disp("____________________________________")
        current_experiment = list_of_experiment_directories(i,:);
        current_experiment = strrep(current_experiment," ","");
        cd(current_experiment);
        all_sigmoid_data_for_current_experiment = ls(strcat(pwd,"\*Sigmoid Data"));
        all_sigmoid_data_for_current_experiment = string(all_sigmoid_data_for_current_experiment);
        for j=1:length(all_sigmoid_data_for_current_experiment)
            current_feature = all_sigmoid_data_for_current_experiment(j,:);
            disp(current_feature);
            cd(current_feature);
            current_directory = pwd;
            current_feature = strrep(current_feature," Sigmoid Data","");
            all_directories_with_sigmoid_data(strcat(strtrim(current_experiment)," ", strtrim(current_feature))) = current_directory;
            cd("..")
        end
        cd(directory_with_experiment_sigmoid_data_absolute)


    end

end
cd(homeDir)
all_directories_with_sigmoid_data = table(string(keys(all_directories_with_sigmoid_data).'),string(values(all_directories_with_sigmoid_data).'), ...
    'VariableNames',{'Experiment','Absolute_file_path_of_sigmoid_data'});
end