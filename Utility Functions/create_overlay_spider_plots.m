function create_overlay_spider_plots(table_of_all_probabilities,folder_where_overlay_spider_plots_will_be_saved_rel)
if ~exist(folder_where_overlay_spider_plots_will_be_saved_rel,"dir")
    mkdir(folder_where_overlay_spider_plots_will_be_saved_rel)
end
home_dir = cd(folder_where_overlay_spider_plots_will_be_saved_rel);
folder_where_overlay_spider_plots_will_be_saved_abs = cd(home_dir);
cd(folder_where_overlay_spider_plots_will_be_saved_abs);

for i=1:height(table_of_all_probabilities)
    
    first_experiment = string(table_of_all_probabilities.Properties.RowNames(i));
    cluster_names = string(table_of_all_probabilities.Properties.VariableNames);
    first_experiment_probabilities = table_of_all_probabilities{i,:};
    for j=i+1:height(table_of_all_probabilities)
        figure; hold on;
        second_experiment = string(table_of_all_probabilities.Properties.RowNames(j));
        second_experiment_probabilities = table_of_all_probabilities{j,:};

        create_overlaid_spider_plots( ...
            folder_where_overlay_spider_plots_will_be_saved_abs, ...
            cluster_names, ...
            [first_experiment_probabilities;second_experiment_probabilities], ...
            [first_experiment;second_experiment], ...
            "create_overlay_spider_plots.m");
        hold off;
    end
    % hold off;
end
cd(home_dir)
end
