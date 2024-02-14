function [] = run_sigmoid_analysis_updated(file_path_with_psychometric_function_tables_relative,folder_where_all_experiment_data_will_be_saved_relative)
% addpath('Utility Functions\')
homeDir = cd(file_path_with_psychometric_function_tables_relative);
file_path_with_psychometric_function_tables_absolute = cd(homeDir);
if ~exist(folder_where_all_experiment_data_will_be_saved_relative,"dir")
    mkdir(folder_where_all_experiment_data_will_be_saved_relative)
end
cd(folder_where_all_experiment_data_will_be_saved_relative);
folder_where_all_experiment_data_will_be_saved_absolute = cd(homeDir);
all_psychometric_function_files = ls(strcat(file_path_with_psychometric_function_tables_absolute,"/*.xlsx"));
all_psychometric_function_files = string(all_psychometric_function_files);

cd(folder_where_all_experiment_data_will_be_saved_absolute);

for i=1:height(all_psychometric_function_files)
    %disp(all_psychometric_function_files(i,:))
    all_info = split(all_psychometric_function_files(i,:));
    experiment = all_info(1);
    feature = all_info(2);
    current_psychometric_functions = readtable(strcat(file_path_with_psychometric_function_tables_absolute,"\",all_psychometric_function_files(i,:)));
%     disp(current_psychometric_functions);
    %% format the table so the first 2 columns are a single column
    single_column = strcat(current_psychometric_functions{:,1}," ",current_psychometric_functions{:,2});
%     disp(single_column)
    current_psychometric_functions = table(single_column, ...
        current_psychometric_functions.x1, current_psychometric_functions.x2,current_psychometric_functions.x3, current_psychometric_functions.x4, ...
        current_psychometric_functions.y1,current_psychometric_functions.y2,current_psychometric_functions.y3,current_psychometric_functions.y4,...
        'VariableNames',["Label","x1","x2","x3","x4","y1","y2","y3","y4"]);
%     disp(current_psychometric_functions);
    if ~exist(experiment,"dir")
        mkdir(experiment)
    end
    all_experiments_dir = cd(experiment);
    sigmoid_analysis_updated(current_psychometric_functions,feature);
    cd(all_experiments_dir)

end
cd(homeDir)
end