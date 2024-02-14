function [] = create_overlay_plots(all_dirs,feature,directory_where_overlay_plots_should_be_saved_relative,pdfs_dir)
    function [current_axis_object] = plot_data_overlap(all_sigmoid_info1,all_sigmoid_info2,feature,experiment1,experiment2,directory_where_plots_should_be_saved_absolute,pdfs_dir)
        maxVsShift1 = [log(abs(all_sigmoid_info1.A)),log(abs(all_sigmoid_info1.B))];
        maxVsSteepness1 = [log(abs(all_sigmoid_info1.A)),log(abs(all_sigmoid_info1.C))];
        shiftVsSteepness1 = [log(abs(all_sigmoid_info1.B)),log(abs(all_sigmoid_info1.C))];
        labels1 = [all_sigmoid_info1.D,all_sigmoid_info1.D];
        all_experiment_1_data_together = {maxVsShift1,maxVsSteepness1,shiftVsSteepness1};


        maxVsShift2 = [log(abs(all_sigmoid_info2.A)),log(abs(all_sigmoid_info2.B))];
        maxVsSteepness2 = [log(abs(all_sigmoid_info2.A)),log(abs(all_sigmoid_info2.C))];
        shiftVsSteepness2 = [log(abs(all_sigmoid_info2.B)),log(abs(all_sigmoid_info2.C))];
        labels2 = [all_sigmoid_info2.D,all_sigmoid_info2.D];
        all_experiment_2_data_together = {maxVsShift2,maxVsSteepness2,shiftVsSteepness2};


        all_x_labels = ["Max", "Max", "Shift"];
        all_y_labels = ["Shift", "Steepness", "Steepness"];
        for j=1: length(all_experiment_1_data_together)
            f = figure;
            [best_mpc1,all_scatter_objects,all_marker_objects] = create_a_plot(f,all_experiment_1_data_together{j},labels1,all_x_labels(j),all_y_labels(j),feature,experiment1,"","create_overlay_plots.m",directory_where_plots_should_be_saved_absolute);
            %% turn the old scatter objects gray
            for scatter_object =1:length(all_scatter_objects)
                current_scatter_object = all_scatter_objects{scatter_object};
                current_scatter_object.MarkerEdgeColor = [.7 .7 .7];
                current_scatter_object.MarkerFaceColor = [.7 .7 .7];
                current_marker_object = all_marker_objects{scatter_object};
                current_marker_object.Color = [.7 .7 .7];
                
            end
            hold on;
            [best_mpc2,~,~]= create_a_plot(f,all_experiment_2_data_together{j},labels2,all_x_labels(j),all_y_labels(j),feature,experiment2,"","create_overlay_plots.m",directory_where_plots_should_be_saved_absolute);
            title(strcat(strrep(experiment1,"_","\_"),"(Gray) ", " MPC:",string(best_mpc1)," ", strrep(experiment2,"_","\_"),"(In Color) ", " MPC:",string(best_mpc2)," ",feature, " ", all_x_labels(j), " vs. ", all_y_labels(j)))
            saveas(f,strcat(directory_where_plots_should_be_saved_absolute,"\",experiment1," Gray ", " MPC ",string(best_mpc1)," ", experiment2," In Color ", " MPC ",string(best_mpc2)," ",feature, " ", all_x_labels(j), " vs. ", all_y_labels(j),".fig"),"fig")
            current_axis_object = gca;
            home_dir = cd(pdfs_dir);
            exportgraphics(current_axis_object,strcat(experiment1, " Vs All Other Experiments.pdf"),'Append',true)
            cd(home_dir)
%             close(f);
        end

    end
%% get absolute path of directory where individual plots should be saved
if ~exist(directory_where_overlay_plots_should_be_saved_relative,"dir")
    mkdir(directory_where_overlay_plots_should_be_saved_relative)
end
homeDir = cd(directory_where_overlay_plots_should_be_saved_relative);
directory_where_plots_should_be_saved_absolute = cd(homeDir);
if ~exist(pdfs_dir,"dir")
    mkdir(pdfs_dir)
end
cd(pdfs_dir);
pdfs_dir_absolute = cd(homeDir);


for i=1:height(all_dirs)
    experiment1 = all_dirs{i,1};
    experiment1 = strrep(experiment1," ","");
    data_location1 = all_dirs{i,2};
    disp(experiment1)
    disp(data_location1)
    
    all_sigmoid_info1 = getTable(data_location1);
    disp(all_sigmoid_info1)
    all_axis_objects = {};
    %% create the plots
    for second=i:height(all_dirs)
        experiment2 = all_dirs{second,1};
        experiment2 = strrep(experiment2," ","");
        data_location_2 = all_dirs{second,2};
        disp(experiment2);
        disp(data_location_2);
        all_sigmoid_info2 = getTable(data_location_2);
        disp(all_sigmoid_info2);
        current_axis_object= plot_data_overlap(all_sigmoid_info1,all_sigmoid_info2,feature,experiment1,experiment2,directory_where_plots_should_be_saved_absolute,pdfs_dir_absolute);
        all_axis_objects{end+1} =current_axis_object ;
    end
    
    %% export all axis objects to pdf

    close all;
end

end