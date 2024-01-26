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

%% BL data
BLdata = cell(1,numClusters);

for index = 1:numClusters
    % Formulate Baseline file name
    baselineFileName = sprintf('Baseline %s_%d.xlsx', feature, index);

    % Construct full Baseline file path
    baselineFilePath = fullfile(folderPath, baselineFileName);

    % Load data from Baseline Excel file
    BLtable = readtable(baselineFilePath);
    BLdata{index} = [BLtable.clusterX, BLtable.clusterY];
end

% percentage of data in each clusters in BL
totalData = sum(cellfun(@(x) size(x, 1), BLdata));
percentInBLcluster = cellfun(@(x) (size(x, 1)/totalData)*100, BLdata);

%% Health manipulation data
% Get a list of all files in the folder
allFiles = dir(fullfile(folderPath, '*.xlsx'));

% Filter files containing 'DT' but not 'Baseline'
featureFiles = allFiles(contains({allFiles.name}, feature) & ~contains({allFiles.name}, 'Baseline'));

% Placeholder for cluster data
healthData = cell(1, length(featureFiles));
healthName = cell(1, length(featureFiles));

for index = 1:length(featureFiles)
    healthFileName = featureFiles(index).name;
    healthFilePath = fullfile(folderPath, healthFileName);

    % Load data from health group Excel file
    healthTable = readtable(healthFilePath);
    healthData{index} = [healthTable.clusterX, healthTable.clusterY];

    healthFileNameExp = '^(.*?)(?=\d)';
    healthName{index} = regexp(healthFileName, healthFileNameExp, 'match', 'once');

end

totalDataMan = zeros(1,length(healthData)/numClusters);
percentInManCluster = cell(1,length(healthData)/numClusters);

% percentage of data in each clusters in health manipulation
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        totalDataMan(index/3) = sum(cellfun(@(x) size(x, 1), healthData(index-2:index)));
        percentInManCluster{index/3} = cellfun(@(x) (size(x, 1)/totalDataMan(index/3))*100, ...
            healthData(index-2:index));
    end
end

% Define legend labels
legendLabels = {'BL C1', 'BL C2', 'BL C3', 'Man C1', 'Man C2', 'Man C3'};

%% Plotting
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        figure;
        hold on;

        % Plot BL Clusters
        Colors = lines(6);
        for i = 1:3
            meanVal = mean(BLdata{i});
            plot(meanVal(1), meanVal(2), 'Color', Colors(i,:), 'LineStyle','none', ...
                'Marker','.','MarkerSize', 25, 'DisplayName', legendLabels{i});
            error_ellipse_fun(BLdata{i}, 0.95, Colors(i,:));
%             fprintf("BL: %d\n", i); % delete this
        end

        % Plot health manipulation Clusters
        for i = index-2:index
            meanVal = mean(healthData{i});
            plot(meanVal(1), meanVal(2), 'Color', Colors(mod(i-1,3)+4,:), ...
                'LineStyle','none', 'Marker','.','MarkerSize', 25, 'DisplayName', legendLabels{mod(i-1,3)+4});
            error_ellipse_fun(healthData{i}, 0.68, Colors(mod(i-1,3)+4,:));
%             fprintf("Health: %d\n", i); % delete this

        end

        % Set limit
        xlim([-20, 20]);
        ylim([-20, 20]);

        % Add legend
        lgd = legend;
        lgd.Location = 'best';

        title(sprintf("Comparison between BL Cluster and %s Clustes", healthName{index}), 'Interpreter','none');

        % Statistics
        pVal = cell(1,numClusters);
        textPosition = [-10, 18; 0, 18; 10, 18];
        for i = 1:length(pVal)
            [h, pVal{i}, ci, stats] = ttest2(BLdata{i}, healthData{index-3+i});
            text(textPosition(i,1), textPosition(i,2), ["p = ", num2str(pVal{i})]);
%             fprintf("BLdata: %d\n", i);
%             fprintf("healthData: %d\n", index-3+i);
        end

        % Print percentage
        textPositionPercent = [-10, 8; 0, 8; 10, 8];
        for i = 1:length(pVal)
            text(textPositionPercent(i,1), textPositionPercent(i,2), ...
                ["BL: ", percentInBLcluster(i), "Man: ", percentInManCluster{index/3}(i)]);
        end

        hold off;
    end
end
end
