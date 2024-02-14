function run_psychometric_functions(where_psych_func_table_will_be_rel,all_experiment_names,all_experiment_dates,all_experiments)
if ~exist(where_psych_func_table_will_be_rel,"dir")
    mkdir(where_psych_func_table_will_be_rel)
end
home_dir = cd(where_psych_func_table_will_be_rel);
where_psyc_func_table_will_be_abs = cd(home_dir);
for i=1:length(all_experiment_names)
    current_experiment_names = all_experiment_names{i};
    current_experiment_dates = all_experiment_dates{i};
    current_experiment = all_experiments{i};
    cd(where_psyc_func_table_will_be_abs);
    automize_psychometric_functions_new_features(current_experiment_names,current_experiment_dates,current_experiment);
    cd(home_dir);
end
cd(home_dir)

end