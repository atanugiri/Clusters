function [population_probabilities] = get_sizes_of_data_sets(cluster_table_dirs,experiment,cluster_names,list_of_features)
size_of_feature_data = zeros(length(list_of_features),1);
for i=1:length(size_of_feature_data)
    % disp("i")
    % disp(i)
    current_feature = list_of_features(i);
    current_size_of_feature = 0; 
    for j=1:length(cluster_names)
        % disp("Current cluster name")
        % disp(cluster_names(j))
        % disp("current Feature")
        % disp(current_feature)
        if contains(cluster_names(j),current_feature,"IgnoreCase",true)
            current_table = readtable(strcat(cluster_table_dirs,"\",experiment," ",cluster_names(j),".xlsx"));
            current_size_of_feature = current_size_of_feature + height(current_table);
        end
    end
    size_of_feature_data(i) = current_size_of_feature;
end
population_probabilities = zeros(length(cluster_names),1);


for i=1:length(list_of_features)
    current_feature = list_of_features(i);
    for j=1:length(cluster_names)
        % disp("Current cluster name")
        % disp(cluster_names(j))
        % disp(current_fea)
        if contains(cluster_names(j),current_feature,"IgnoreCase",true)
            % disp(strcat(cluster_table_dirs,"\",experiment," ",cluster_names(j),".xlsx"));
            current_table = readtable(strcat(cluster_table_dirs,"\",experiment," ",cluster_names(j),".xlsx"));
            population_probabilities(j) = height(current_table) / size_of_feature_data(i); 
        end
    end
end

end