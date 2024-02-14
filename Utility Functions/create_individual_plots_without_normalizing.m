function [] = create_individual_plots_without_normalizing(all_dirs,directory_where_individual_plots_should_be_saved_relative,dir_for_cluster_tables_relative)
    function [] = plot_data_individually(all_sigmoid_info,feature,experiment,directory_where_plots_should_be_saved_absolute,dir_for_cluster_tables_absolute)
        maxVsShift = [all_sigmoid_info.A,all_sigmoid_info.B];
        maxVsSteepness = [log(abs(all_sigmoid_info.A)),log(abs(all_sigmoid_info.C))];
        shiftVsSteepness = [log(abs(all_sigmoid_info.B)),log(abs(all_sigmoid_info.C))];
        labels = [all_sigmoid_info.D,all_sigmoid_info.D];
        all_data_together = {maxVsShift,maxVsSteepness,shiftVsSteepness};
        all_x_labels = ["Max", "Max", "Shift"];
        all_y_labels = ["Shift", "Steepness", "Steepness"];
        for j=1: length(all_data_together)
            if strcmpi(all_x_labels(j),"Max") && strcmpi(all_y_labels(j),"Shift")
                f = figure;
                scatter(maxVsShift(:,1),maxVsShift(:,2));
                title(strcat(strrep(experiment,"_","\_")," ", strrep(feature,"_","\_"), " ", all_x_labels(j), " vs. ", all_y_labels(j)))
                %             saveas(f,strcat(directory_where_plots_should_be_saved_absolute,"\",experiment," ", feature, " ", all_x_labels(j), " vs. ",all_y_labels(j), " MPC ",string(best_mpc),".fig"), "fig")
                %             close(f);
                % xlim([-20,20])
                % ylim([-20,20])
            end
        end

    end
%% get absolute path of directory where individual plots should be saved
if ~exist(directory_where_individual_plots_should_be_saved_relative,"dir")
    mkdir(directory_where_individual_plots_should_be_saved_relative)
end
homeDir = cd(directory_where_individual_plots_should_be_saved_relative);
directory_where_plots_should_be_saved_absolute = cd(homeDir);

%% get absolute path of directory where cluster tables should be saved
if ~exist(dir_for_cluster_tables_relative,"dir")
    mkdir(dir_for_cluster_tables_relative)
end
cd(dir_for_cluster_tables_relative)
dir_for_cluster_tables_absolute = cd(homeDir);

%% run the code which creates individual plots and gets cluster tables
for i=1:height(all_dirs)
    experiment_and_feature = all_dirs{i,1};
    experiment_and_feature = split(experiment_and_feature, " ");
    experiment = experiment_and_feature(1,1);
    experiment = strrep(experiment," ","");
    feature = experiment_and_feature(2,1);
    data_location = all_dirs{i,2};
    disp(experiment)
    disp(data_location)
    all_sigmoid_info = getTable(data_location);
    disp(all_sigmoid_info)
    plot_data_individually(all_sigmoid_info,feature,experiment,directory_where_plots_should_be_saved_absolute,dir_for_cluster_tables_absolute)
end

end