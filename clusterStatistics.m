% Author: Atanu Giri
% Date: 01/22/2024

function clusterStatistics(filename)

% filename = 'Baseline DT_1.xlsx';

% Use regular expression to extract the desired part
expression = ' (\w+)_';
match = regexp(filename, expression, 'tokens', 'once');

% Check if a match is found
if ~isempty(match)
    feature = match{1};
end

folderPath = '/Users/atanugiri/Downloads/Clusters/Baseline_Oxy_FoodDep_BoostAndEtho_Ghrelin_Saline_Cluster_Tables';
numClusters = 3;

for baselineCluster = 1:numClusters
    % Formulate Baseline file name
    baselineFileName = sprintf('Baseline %s_%d.xlsx', feature, baselineCluster);

    % Construct full Baseline file path
    baselineFilePath = fullfile(folderPath, baselineFileName);

    % Load data from Baseline Excel file
    BLtable = readtable(baselineFilePath);
    BLdata = [BLtable.clusterX, BLtable.clusterY];
    BLDataMean = mean(BLdata);
%     stdDevBLx = std(BLdata(:,1))/sqrt(length(BLdata(:,1)));
%     stdDevBLy = std(BLdata(:,2))/sqrt(length(BLdata(:,2)));

    % Get a list of all files in the folder
    allFiles = dir(fullfile(folderPath, '*.xlsx'));

    % Filter files containing 'DT' but not 'Baseline'
    featureFiles = allFiles(contains({allFiles.name}, feature) & ~contains({allFiles.name}, 'Baseline'));

    % Placeholder for cluster data
    healthData = cell(1, length(featureFiles));
    healthDataMean = cell(1, length(featureFiles));
    healthDataSDx = zeros(1, length(featureFiles));
    healthDataSDy = zeros(1, length(featureFiles));

    % Compare Baseline data with each health group file
    for index = 1:length(featureFiles)

        healthFilePath = fullfile(folderPath, featureFiles(index).name);

        % Load data from health group Excel file
        healthTable = readtable(healthFilePath);
        healthData{index} = [healthTable.clusterX, healthTable.clusterY];
        healthDataMean{index} = mean(healthData{index});
        healthDataSDx(index) = std(healthData{index}(:,1));
        healthDataSDy(index) = std(healthData{index}(:,2));


%         [hX, pX] = vartest2(BLdata(:,1), healthData(:,1));
%         [hY, pY] = vartest2(BLdata(:,2), healthData(:,2));

        if isequal(mod(index, 3), 0)
            healthFileName = featureFiles(index).name;
            healthFileNameExp = '^(.*?)(?=\d)';
            healthName = regexp(healthFileName, healthFileNameExp, 'match', 'once');
 
            % Plot centroids
            figure;
            hold on;
            title(sprintf("Comparison between BL %s_Cluster%d and %s", ...
                feature, baselineCluster, healthName), 'Interpreter','none');
            Colors = lines(4);
            plot(BLDataMean(1), BLDataMean(2), 'Color', ...
                    Colors(4,:), 'LineStyle','none', 'Marker','.','MarkerSize',40);

            error_ellipse_fun(BLdata, 0.95);
%             h.EdgeColor = Colors(4,:);

            for i = index-2:index
                plot(healthDataMean{i}(1),healthDataMean{i}(2),'Color', ...
                    Colors(mod(i, 3)+1,:), 'LineStyle','none', 'Marker','.','MarkerSize',40);
                error_ellipse_fun(healthData{i}, 0.95);
%                 h.EdgeColor = Colors(mod(i, 3)+1,:);

            end

            xlim([-20, 20]); ylim([-20, 20])
            legend;
%             legend('','Cluster1','Cluster2','Cluster3');
            hold off;

        end
    end
end

end % end of function
