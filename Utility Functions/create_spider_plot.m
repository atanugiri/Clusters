function create_spider_plot(spider_plot_dir,clusters_list,probabilities,experiment,calledBy)
figure; hold on;
% disp(size(clusters_list))
% disp(size(probabilities))
axes_limits = [zeros(length(clusters_list),1).';(zeros(length(clusters_list),1)+ 0.9).' ];
% disp(axes_limits);
% disp({clusters_list})
% disp(size({clusters_list}))
% disp(probabilities)
formatted_cluster_list = {};
for i=1:length(clusters_list)
    formatted_cluster_list{end+1} = char(clusters_list(i));
end
spider_plot(probabilities.','AxesLimits',axes_limits,'AxesLabels',formatted_cluster_list);
title(strrep(experiment,"_","\_"));
subtitle(strcat("Created by create_spider_plot. Called by ", strrep(calledBy,"_","\_")));
saveas(gcf,strcat(spider_plot_dir,"\",experiment," Spider Plot.fig"),"fig");
close(gcf);
end