function get_individual_rats_euc_distance_plots(path_of_cluster_tables,experiment_list,feature_list,fig_file_path)

if ~exist(fig_file_path,"dir")
    mkdir(fig_file_path)
end
home_dir = cd(fig_file_path);
fig_file_path_abs = cd(home_dir);

for feature=1:length(feature_list)
    current_feature = feature_list(feature);
    for experiment1=1:length(experiment_list)
        current_experiment_1 = experiment_list(experiment1);
        
        if strcmpi(current_experiment_1,"Baseline")
            experiment_1_euc_distances_table = findEuclidianDistancesOfSingleRatToAllOthers(path_of_cluster_tables,current_experiment_1,true,true,current_feature);
        else
            experiment_1_euc_distances_table =findEuclidianDistancesOfSingleRatToAllOthers(path_of_cluster_tables,current_experiment_1,false,true,current_feature);
        end

        for outer_table_counter = 1:height(experiment_1_euc_distances_table)
            rat_1 = string(experiment_1_euc_distances_table{outer_table_counter,1});
            rat_1_euc_dist = cell2mat(experiment_1_euc_distances_table{outer_table_counter,2});
            for inner_table_counter=outer_table_counter+1:height(experiment_1_euc_distances_table)
                figure;
                rat_2 = string(experiment_1_euc_distances_table{inner_table_counter,1});
                rat_2_euc_dist = cell2mat(experiment_1_euc_distances_table{inner_table_counter,2});
                histogram(rat_1_euc_dist,'normalization','probability','BinEdges',0:0.05:3);
                hold on;
                histogram(rat_2_euc_dist,'normalization','probability','BinEdges',0:0.05:3);
                [h,p] = kstest2(rat_1_euc_dist,rat_2_euc_dist);
                title(strrep(strcat(current_feature," ",rat_1, " Vs ",rat_2),"_","\_"))
                subtitle(strcat("From KS2 Test We Have h:",string(h), "And p:",string(p)));
                legend(strrep(rat_1,"_","\_"),strrep(rat_2,"_","\_"));
                hold off;
                saveas(gcf,strcat(fig_file_path_abs,"\",current_feature," ",rat_1, " Vs ",rat_2));
                close(gcf)
            end
        end
        
        

    end
end

end