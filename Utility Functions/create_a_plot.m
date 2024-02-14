function [best_mpc,all_scatter_objects,all_marker_objects] = create_a_plot(fig_handle,xVsY,labels,xAxis,yAxis,feature,experiment,folder_where_cluster_tables_should_be_saved,called_by,folder_where_figures_should_be_saved)
%% format underscores
% experiment = strrep(experiment,"_","\_");
called_by = strrep(called_by,"_","\_");


%% run fcm multiple times to find which one gives best mpc thus giving us ideal number of clusters
all_mpc_calculations = []; 
all_centers = {};
allUs = {}; 
for i=1:5
    [centers,U] = fcm(xVsY,i);
    all_centers{end+1} = centers;
    allUs{end+1} = {U}; 
    current_mpc = calculate_mpc(U);
    all_mpc_calculations = [all_mpc_calculations,current_mpc];
end
[best_mpc, ideal_number_of_clusters] = max(all_mpc_calculations);

%% plot the best results
% [centers,U] = fcm(xVsY,ideal_number_of_clusters);
centers = all_centers{ideal_number_of_clusters};
U = allUs{ideal_number_of_clusters};
U = cell2mat(U);
% disp(U)
maxU = max(U);
hold on; 
all_scatter_objects = {};
all_marker_objects = {};
letter = "";
switch feature
    case "Reward Choice"
        letter = "M";
    case "Travel Pixel"
        letter = "A";
    case "Stopping Points"
        letter = "D";
    case "Reaction Time"
        letter = "J";
    case "Rotation Points"
        letter = "G";
end
for i =1:ideal_number_of_clusters
    indexes = find(U(i,:)==maxU);
    all_scatter_objects{end+1} = scatter(xVsY(indexes,1),xVsY(indexes,2));
    s = all_scatter_objects{i};
    s.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Session_Label:",labels(indexes,1)); 
    all_marker_objects{end+1} = plot(centers(i,1),centers(i,2),'xk','MarkerSize',15,'LineWidth',3);
    a = all_marker_objects{i};
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster:", i);
    clusterTable = getClusterTable(xVsY,labels,indexes);
    a.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow("Cluster Size:", height(clusterTable));
    if strcmpi(xAxis,"max") && strcmpi(yAxis,"shift") && ~strcmpi(folder_where_cluster_tables_should_be_saved,"")
        writetable(clusterTable,strcat(folder_where_cluster_tables_should_be_saved,"\",experiment," ",string(letter),string(i),".xlsx"))
    end

end

%% display ideal mpc
disp(best_mpc);

%% label the current figure
hold on;
xlabel(xAxis);
ylabel(yAxis);
subtitle(strcat("Created By create\_a\_plot.m, called by ", called_by))

%% save the figure
% home_dir = cd(folder_where_figures_should_be_saved);
% saveas(fig_handle,strcat(folder_where_figures_should_be_saved,"\",experiment," ", feature, " ", xAxis, " vs. ", yAxis, " MPC ",string(best_mpc),".fig"), "fig")
% cd(home_dir);
% close(fig_handle)
end