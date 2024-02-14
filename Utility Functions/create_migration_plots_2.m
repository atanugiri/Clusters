function create_migration_plots_2(path_with_cluster_tables_rel,path_where_mig_plots_should_be_saved_rel,path_where_pdfs_should_be_saved_rel)
    function [mig_plots_path_abs,pdf_plots_abs,path_with_cluster_tables_abs] = create_all_the_neccessary_directories(path_where_mig_plots_should_be_saved_rel,path_where_pdfs_should_be_saved_rel,path_with_cluster_tables_rel)
        home_dir = cd(path_with_cluster_tables_rel);
        path_with_cluster_tables_abs = cd(home_dir);
        if ~exist(path_where_mig_plots_should_be_saved_rel,"dir")
            mkdir(path_where_mig_plots_should_be_saved_rel);
            home_dir = cd(path_where_mig_plots_should_be_saved_rel);
            mig_plots_path_abs = cd(home_dir);
        else
            home_dir = cd(path_where_mig_plots_should_be_saved_rel);
            mig_plots_path_abs = cd(home_dir);
        end
        if ~exist(path_where_pdfs_should_be_saved_rel,"dir")
            mkdir(path_where_pdfs_should_be_saved_rel);
            home_dir = cd(path_where_pdfs_should_be_saved_rel);
            pdf_plots_abs = cd(home_dir);
        else
            home_dir = cd(path_where_pdfs_should_be_saved_rel);
            pdf_plots_abs = cd(home_dir);
        end
        cd(home_dir)
    end
    function plot_the_experiment(mig_plots_path_abs,pdf_plots_abs,path_with_cluster_tables_abs)
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
                    for d=1:size(all_clusters_for_experiment_2_current_feature,1)
                        experiment_1_current_cluster = readtable(all_clusters_for_experiment_1_current_feature(d));
                        experiment_2_current_cluster = readtable(all_clusters_for_experiment_2_current_feature(d));

                        experiment_1_current_cluster_x_and_y = [experiment_1_current_cluster.clusterX,experiment_1_current_cluster.clusterY];
                        experiment_1_current_cluster_labels = experiment_1_current_cluster.clusterLabels;
                        experiment_2_current_cluster_x_and_y = [experiment_2_current_cluster.clusterX,experiment_2_current_cluster.clusterY];
                        experiment_2_current_cluster_labels = experiment_2_current_cluster.clusterLabels;

                        %% add data tips to experiment 1 data
                        a = scatter(experiment_1_current_cluster_x_and_y(:,1),experiment_1_current_cluster_x_and_y(:,2),'MarkerEdgeColor',[0.7,0.7,0.7],'MarkerFaceColor',[0.7,0.7,0.7]);
                        row = dataTipTextRow("Session\_label:",experiment_1_current_cluster_labels);
                        a.DataTipTemplate.DataTipRows(end+1) = row;
                        cluster_name_repeated_n_times =cell(length(experiment_1_current_cluster_x_and_y),1);
                        for n=1:length(cluster_name_repeated_n_times)
                            cluster_name_repeated_n_times{n} = all_clusters_for_experiment_1_current_feature(d);
                        end
                        row = dataTipTextRow("Cluster\_It\_Belongs\_To",cluster_name_repeated_n_times);
                        a.DataTipTemplate.DataTipRows(end+1) = row;


                        %% add data tips to experiment 2 data
                        b = scatter(experiment_2_current_cluster_x_and_y(:,1),experiment_2_current_cluster_x_and_y(:,2));
                        row = dataTipTextRow("Session\_label:",experiment_2_current_cluster_labels);
                        b.DataTipTemplate.DataTipRows(end+1) = row;
                        cluster_name_repeated_n_times =cell(length(experiment_2_current_cluster_x_and_y),1);
                        for n=1:length(cluster_name_repeated_n_times)
                            cluster_name_repeated_n_times{n} = all_clusters_for_experiment_2_current_feature(d);
                        end
                        row = dataTipTextRow("Cluster\_It\_Belongs\_To",cluster_name_repeated_n_times);
                        b.DataTipTemplate.DataTipRows(end+1) = row;


                        xlabel("log(abs(Sigmoid Max))");
                        ylabel("log(abs(Sigmoid Shift))");
                        title(strcat(experiment_1," (Gray) Vs ",experiment_2," In Color Feature: ",current_feature));
                        subtitle("Created by create_migration_plots_2");
                        xlim([-20,20]);
                        ylim([-20,20]);
                        

                    end
                    saveas(gcf,strcat(mig_plots_path_abs,"\",experiment_1," Vs ",experiment_2, " ",current_feature, ".fig"), "fig")
                    close(gcf)
                    hold off;
                end
            end
        end
        cd(starting_dir)
    end
[mig_plots_path_abs,pdf_plots_abs,path_with_cluster_tables_abs] = create_all_the_neccessary_directories(path_where_mig_plots_should_be_saved_rel,path_where_pdfs_should_be_saved_rel,path_with_cluster_tables_rel);

plot_the_experiment(mig_plots_path_abs,pdf_plots_abs,path_with_cluster_tables_abs)



end
