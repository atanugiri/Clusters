function get_skewness_comparison(path_with_cluster_tables_rel,path_where_skewness_plots_should_be_saved_rel)
    function [skewness_plots_path_abs,path_with_cluster_tables_abs] = create_all_the_neccessary_directories(path_where_mig_plots_should_be_saved_rel,path_with_cluster_tables_rel)
        home_dir = cd(path_with_cluster_tables_rel);
        path_with_cluster_tables_abs = cd(home_dir);
        if ~exist(path_where_mig_plots_should_be_saved_rel,"dir")
            mkdir(path_where_mig_plots_should_be_saved_rel);
            home_dir = cd(path_where_mig_plots_should_be_saved_rel);
            skewness_plots_path_abs = cd(home_dir);
        else
            home_dir = cd(path_where_mig_plots_should_be_saved_rel);
            skewness_plots_path_abs = cd(home_dir);
        end
        cd(home_dir)
    end
    function plot_the_experiment(skewness_plots_path_abs,path_with_cluster_tables_abs)
        starting_dir = cd(path_with_cluster_tables_abs);
        all_the_clusters = strtrim(string(ls(strcat(pwd,"\*.xlsx"))));
        % disp(all_the_clusters)
        all_unique_experiments = split(all_the_clusters," ");
        all_unique_features = strrep(all_unique_experiments(:,2),".xlsx","");
        all_unique_features = strrep(all_unique_features,"_1","");
        all_unique_features = strrep(all_unique_features,"_2","");
        all_unique_features = strrep(all_unique_features,"_3","");
        all_unique_features = strrep(all_unique_features,"_4","");
        all_unique_features = unique(all_unique_features);
        % disp(all_unique_features);

        all_unique_experiments = all_unique_experiments(:,1);
        % disp(all_unique_experiments);
        all_unique_experiments = unique(all_unique_experiments);
        % disp(all_unique_experiments)
        for i=1:length(all_unique_experiments)
            experiment_1 = all_unique_experiments(i);
            for k=i+1:length(all_unique_experiments)
                experiment_2 = all_unique_experiments(k);
                for j=1:length(all_unique_features)
                    figure; hold on;
                    current_feature = all_unique_features(j);
                    all_clusters_for_experiment_1_current_feature = strtrim(string(ls(strcat(pwd,"\",experiment_1,"*",current_feature,"*.xlsx"))));
                    all_clusters_for_experiment_2_current_feature = strtrim(string(ls(strcat(pwd,"\",experiment_2,"*",current_feature,"*.xlsx"))));
                    % disp(all_clusters_for_experiment_1)
                    % disp(all_clusters_for_experiment_2)
                    % disp(size(all_clusters_for_experiment_2,1))
                    all_experiment_1_cluster_skewness_for_x = zeros(1,length(all_clusters_for_experiment_1_current_feature));
                    all_experiment_1_cluster_skewness_for_y = zeros(1,length(all_clusters_for_experiment_1_current_feature));
                    all_experiment_2_cluster_skewness_for_x = zeros(1,length(all_clusters_for_experiment_2_current_feature));
                    all_experiment_2_cluster_skewness_for_y = zeros(1,length(all_clusters_for_experiment_2_current_feature));
                    for d=1:size(all_clusters_for_experiment_2_current_feature,1)
                        experiment_1_current_cluster = readtable(all_clusters_for_experiment_1_current_feature(d));
                        experiment_2_current_cluster = readtable(all_clusters_for_experiment_2_current_feature(d));

                        experiment_1_current_cluster_x = experiment_1_current_cluster.clusterX;
                        all_experiment_1_cluster_skewness_for_x(d) = skewness(experiment_1_current_cluster_x);
                        experiment_1_current_cluster_y = experiment_1_current_cluster.clusterY;
                        all_experiment_1_cluster_skewness_for_y(d) = skewness(experiment_1_current_cluster_y);

                        experiment_2_current_cluster_x_= experiment_2_current_cluster.clusterX;
                        all_experiment_2_cluster_skewness_for_x(d) = skewness(experiment_2_current_cluster_x_);
                        experiment_2_current_cluster_y = experiment_2_current_cluster.clusterY;
                        all_experiment_2_cluster_skewness_for_y(d) = skewness(experiment_2_current_cluster_y);
                    end

                    subplot(1,2,1)
                    the_x = strtrim(strrep(all_clusters_for_experiment_2_current_feature,".xlsx",""));
                    the_x = strrep(the_x,experiment_2,"");
                    the_x = strrep(the_x,"_","\_");
                    bar(the_x,[all_experiment_1_cluster_skewness_for_x.',all_experiment_2_cluster_skewness_for_x.'])
                    title("Cluster X-Values")
                    subtitle('Created by get\_skewness\_comparison.m')
                    legend(strrep(experiment_1,"_","\_"),strrep(experiment_2,"_","\_"))
                    subplot(1,2,2);
                    bar(the_x,[all_experiment_1_cluster_skewness_for_y.',all_experiment_2_cluster_skewness_for_y.'])
                    title("Cluster Y-Values")
                    subtitle('Created by get\_skewness\_comparison.m')
                    legend(experiment_1,experiment_2);
                    sgtitle(current_feature)
                    saveas(gcf,strcat(skewness_plots_path_abs,"\",experiment_1," Vs ",experiment_2, " ",current_feature, ".fig"), "fig")
                    close(gcf)
                    hold off;
                end
            end
        end
        cd(starting_dir)
    end
[skewness_plots_path_abs,path_with_cluster_tables_abs] = create_all_the_neccessary_directories(path_where_skewness_plots_should_be_saved_rel,path_with_cluster_tables_rel);

plot_the_experiment(skewness_plots_path_abs,path_with_cluster_tables_abs)



end
