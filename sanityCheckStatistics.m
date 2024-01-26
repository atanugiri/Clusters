% Author: Atanu Giri
% Date: 01/25/2024

function sanityCheckStatistics(filename)

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

% 1-D distribution of X-values
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        plotHistogram(BLdata, healthData, index, 1);
        sgtitle(sprintf("Comparison between X-values BL Cluster and %s " + ...
            "Clustes", healthName{index}), 'Interpreter','none');
    end
end

% 1-D distribution of Y-values
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        plotHistogram(BLdata, healthData, index, 2);
        sgtitle(sprintf("Comparison between Y-values BL Cluster and %s " + ...
            "Clustes", healthName{index}), 'Interpreter','none');
    end
end

%% Description of plotHistogram
function plotHistogram(BLdata, healthData, index, column)
figure;
% set(gcf, 'Windowstyle', 'docked');
hold on;
for i = 1:length(BLdata)
    subplot(1,3,i);
    histogram(BLdata{i}(:,column),10,'Normalization','pdf');
    hold on;
    histogram(healthData{index-3+i}(:,column),10,'Normalization','pdf');
    [~, p] = ttest2(BLdata{i}(:,column), healthData{index-3+i}(:,column));
    text(mean(BLdata{i}(:,column)), 0.1, ["p = ", num2str(p)]);
end
hold off;
end

end