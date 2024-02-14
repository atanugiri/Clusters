function [best_mpc,all_scatter_objects,all_marker_objects] = create_a_plot_updated_2(fig_handle,xVsY,labels,xAxis,yAxis,feature,experiment,folder_where_cluster_tables_should_be_saved,called_by,folder_where_figures_should_be_saved)
%% format underscores
% experiment = strrep(experiment,"_","\_");
called_by = strrep(called_by,"_","\_");


%% run fcm multiple times to find which one gives best mpc thus giving us ideal number of clusters
all_mpc_calculations = [];
all_centers = {};
allUs = {};
disp(feature)
switch feature
    case "rotation_points_method_4"
        cluster_centers_matrix = [[-8.39534,-0.435565];[0.763352,0.157744];[8.87779,8.4991]];
        number_of_clusters=3;
        opts = fcmOptions(NumClusters=number_of_clusters,ClusterCenters= cluster_centers_matrix);
    case "rotation_points_method_1"
        cluster_centers_matrix = [[-7.92611,0.0200206];[1.34988,0.748386];[10.0991,9.22103]];
        number_of_clusters=3;
        opts = fcmOptions(NumClusters=number_of_clusters,ClusterCenters= cluster_centers_matrix);
    case "reward_choice"
        cluster_centers_matrix = [[-8.95759,-0.338087];[7.26274,9.11074];[0.05617,9.37614];[-0.0850574,2.51279]];
        number_of_clusters=4;
        opts = fcmOptions(NumClusters=number_of_clusters,ClusterCenters= cluster_centers_matrix);
    case "entry_time"
        cluster_centers_matrix = [[-6.91469,-0.120784];[1.89751,0.549677];[11.7293,9.59867];];
        number_of_clusters=3;
        opts = fcmOptions(NumClusters=number_of_clusters,ClusterCenters= cluster_centers_matrix);
    case "distance_traveled"
        cluster_centers_matrix = [[-8.48679,-0.206976];[1.18181,-0.215828];[9.33049,8.58631]];
        number_of_clusters=3;
        opts = fcmOptions(NumClusters=number_of_clusters,ClusterCenters= cluster_centers_matrix);
    case "stopping_points"
        cluster_centers_matrix = [[-4.19739,-0.116132];[4.85196,1.15674];[15.1133,10.7758]];
        number_of_clusters=3;
        opts = fcmOptions(NumClusters = number_of_clusters,ClusterCenters = cluster_centers_matrix);
end

%% Run FCM 
[centers,U] = fcm(xVsY,opts);
best_mpc = calculate_mpc(U);
%% plot the results
maxU = max(U);
hold on; 
all_scatter_objects = {};
all_marker_objects = {};
letter = "";

switch feature
    case "rotation_points_method_4"
        letter = "RP4";
    case "rotation_points_method_1"
        letter = "RP1";
    case "reward_choice"
        letter = "M";
    case "entry_time"
        letter = "ET";
    case "distance_traveled"
        letter = "DT";
    case "stopping_points"
        letter = "SP";
end
number_of_data_points = size(xVsY,1);

for i =1:number_of_clusters
    indexes = find(U(i,:)==maxU);
    scatter(xVsY(indexes,1),xVsY(indexes,2))
    hold on;
    plot(centers(i,1),centers(i,2),"xk",MarkerSize=15,LineWidth=3);

    
    %% add the labels to each data point which tells us the name and date of the rats
    all_scatter_objects{end+1} = scatter(xVsY(indexes,1),xVsY(indexes,2));
    s = all_scatter_objects{i};
    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Session_Label:",labels(indexes,1)); 
    all_marker_objects{end+1} = plot(centers(i,1),centers(i,2),'xk','MarkerSize',15,'LineWidth',3);

    %% add The Cluster Size, Number, and Size of Data Set to the Cluster Centers
    a = all_marker_objects{i};
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster:", i);
    clusterTable = getClusterTable(xVsY,labels,indexes);
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster Size:", height(clusterTable));
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Data Set Size",number_of_data_points);
    
    %% write each data point's (x,y) and label to a table 
    if strcmpi(xAxis,"max") && strcmpi(yAxis,"shift") && ~strcmpi(folder_where_cluster_tables_should_be_saved,"")
        writetable(clusterTable,strcat(folder_where_cluster_tables_should_be_saved,"\",experiment," ",string(letter),"_",string(i),".xlsx"))
    end

end



%% label the current figure
hold on;
xlabel(xAxis);
ylabel(yAxis);
subtitle(strcat("Created By create\_a\_plot.m, called by ", called_by))
xlim([-20,20]);
ylim([-20,20])

%% save the figure
home_dir = cd(folder_where_figures_should_be_saved);
% saveas(fig_handle,strcat(folder_where_figures_should_be_saved,"\",experiment," ", feature, " ", xAxis, " vs. ", yAxis, " MPC ",string(best_mpc),".fig"), "fig")
cd(home_dir);
% close(fig_handle)
end