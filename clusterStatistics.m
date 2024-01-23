% Author: Atanu Giri
% Date: 01/22/2024

% function clusterStatistics(filename)

filename = 'Baseline DT_1.xlsx';

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

    % Get a list of all files in the folder
    allFiles = dir(fullfile(folderPath, '*.xlsx'));

    % Filter files containing 'DT' but not 'Baseline'
    featureFiles = allFiles(contains({allFiles.name}, feature) & ~contains({allFiles.name}, 'Baseline'));

    % Placeholder for cluster data
    healthDataMean = cell(1, length(featureFiles));

    % Compare Baseline data with each health group file
    for index = 1:length(featureFiles)

        healthFilePath = fullfile(folderPath, featureFiles(index).name);

        % Load data from health group Excel file
        healthTable = readtable(healthFilePath);
        healthData = [healthTable.clusterX, healthTable.clusterY];
        healthDataMean{index} = mean(healthData);

        [hX, pX] = vartest2(BLdata(:,1), healthData(:,1));
        [hY, pY] = vartest2(BLdata(:,2), healthData(:,2));

        if isequal(mod(index, 3), 0)
% 
%             fprintf(pdfFile, 'Comparison between Baseline %s_1 and Health %s_1:\n', feature, feature);
            % Save result
            h = figure;
            hold on;
            plot(BLDataMean(1), BLDataMean(2), 'bo', 'LineStyle','none');
            for i = index-2:index
                plot(healthDataMean{i}(1),healthDataMean{i}(2),'ro','LineStyle','none');
            end
            hold off;

        end
    end
end

% end
