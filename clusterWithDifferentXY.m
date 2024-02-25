% Author: Atanu Giri
% Date: 01/30/2024

function clusterWithDifferentXY(filename1, filename2)
% filename1 = 'Baseline ET_1.xlsx';
% filename2 = 'Baseline RP1_1.xlsx';

% Use regular expression to extract the desired part
expression = '([A-Za-z]+)\d*';
match1 = regexp(filename1, expression, 'match');
match2 = regexp(filename2, expression, 'match');

% Check if a match is found
if ~isempty(match1) || ~isempty(match2)
    feature1 = match1{2};
    feature2 = match2{2};
end

folderPath = '/Users/atanugiri/Downloads/Clusters/Baseline_Oxy_FoodDep_BoostAndEtho_Ghrelin_Saline_Cluster_Tables';
numClusters = 3;

%% BL data
BLtable1 = cell(1,numClusters);
BLtable2 = cell(1,numClusters);

for index = 1:numClusters
    % Formulate Baseline file name
    baselineFileName1 = sprintf('Baseline %s_%d.xlsx', feature1, index);
    baselineFileName2 = sprintf('Baseline %s_%d.xlsx', feature2, index);

    % Construct full Baseline file path
    baselineFilePath1 = fullfile(folderPath, baselineFileName1);
    baselineFilePath2 = fullfile(folderPath, baselineFileName2);

    % Load data from Baseline Excel file
    BLtable1{index} = readtable(baselineFilePath1);
    BLtable2{index} = readtable(baselineFilePath2);
%     BLdata{index} = [BLtable.clusterX, BLtable.clusterY];
end


% Initialize BLtable cell array
BLdata = cell(1, 3);

% Loop through each pair of tables in BLtable1 and BLtable2
for i = 1:3
    % Extract clusterLabels and corresponding clusterX from BLtable1{i}
    labels_X = BLtable1{i}.clusterLabels;
    X = BLtable1{i}.clusterX;
    
    % Extract clusterLabels and corresponding clusterY from BLtable2{i}
    labels_Y = BLtable2{i}.clusterLabels;
    Y = BLtable2{i}.clusterY;
    
    % Find common clusterLabels
    common_labels = intersect(labels_X, labels_Y);
    
    % Initialize common table
    common_table = table('Size', [numel(common_labels), 3], ...
                         'VariableTypes', {'string', 'double', 'double'}, ...
                         'VariableNames', {'clusterLabels', 'clusterX', 'clusterY'});
    
    % Populate common table with data
    for j = 1:numel(common_labels)
        label = common_labels{j};
        idx_X = strcmp(labels_X, label);
        idx_Y = strcmp(labels_Y, label);
        
        % Find corresponding clusterX and clusterY values
        x_value = X(idx_X);
        y_value = Y(idx_Y);
        
        % Add data to common table
        common_table.clusterLabels(j) = label;
        common_table.clusterX(j) = x_value;
        common_table.clusterY(j) = y_value;
    end
    
    % Assign common table to BLtable
    BLdata{i} = common_table;
end

%% Health manipulation data
allFiles = dir(fullfile(folderPath, '*.xlsx'));

% Filter files containing 'DT' but not 'Baseline'
featureFiles1 = allFiles(contains({allFiles.name}, feature1) & ~contains({allFiles.name}, 'Baseline'));
featureFiles2 = allFiles(contains({allFiles.name}, feature2) & ~contains({allFiles.name}, 'Baseline'));

% Placeholder for cluster data
healthData1 = cell(1, length(featureFiles1));
healthName1 = cell(1, length(featureFiles1));

healthData2 = cell(1, length(featureFiles2));
healthName2 = cell(1, length(featureFiles2));

for index = 1:length(featureFiles1)
    healthFileName1 = featureFiles1(index).name;
    healthFilePath1 = fullfile(folderPath, healthFileName1);

    % Load data from health group Excel file
    healthData1{index} = readtable(healthFilePath1);

    healthFileNameExp = '([A-Za-z\s\d]+)(?=_[A-Za-z\d]+\.xlsx)';     
    healthName1(index) = regexp(healthFileName1, healthFileNameExp, 'match');

    healthFileName2 = featureFiles2(index).name;
    healthFilePath2 = fullfile(folderPath, healthFileName2);

    % Load data from health group Excel file
    healthData2{index} = readtable(healthFilePath2);
    healthName2(index) = regexp(healthFileName2, healthFileNameExp, 'match');

end

% Initialize ManTable cell array
healthData = cell(1, length(featureFiles1));

% Loop through each pair of tables in BLtable1 and BLtable2
for i = 1:length(featureFiles1)
    % Extract clusterLabels and corresponding clusterX from BLtable1{i}
    labels_X = healthData1{i}.clusterLabels;
    X = healthData1{i}.clusterX;
    
    % Extract clusterLabels and corresponding clusterY from BLtable2{i}
    labels_Y = healthData2{i}.clusterLabels;
    Y = healthData2{i}.clusterY;
    
    % Find common clusterLabels
    common_labels = intersect(labels_X, labels_Y);
    
    % Initialize common table
    common_table = table('Size', [numel(common_labels), 3], ...
                         'VariableTypes', {'string', 'double', 'double'}, ...
                         'VariableNames', {'clusterLabels', 'clusterX', 'clusterY'});
    
    % Populate common table with data
    for j = 1:numel(common_labels)
        label = common_labels{j};
        idx_X = find(strcmp(labels_X, label),1);
        idx_Y = find(strcmp(labels_Y, label),1);
        
        % Find corresponding clusterX and clusterY values
        x_value = X(idx_X);
        y_value = Y(idx_Y);
        
        % Add data to common table
        common_table.clusterLabels(j) = label;
        common_table.clusterX(j) = x_value;
        common_table.clusterY(j) = y_value;
    end
    
    % Assign common table to BLtable
    healthData{i} = common_table;
end

% Drop the name column
for i = 1:numel(BLdata)
    BLdata{i} = [BLdata{i}.clusterX, BLdata{i}.clusterY];
end

% percentage of data in each clusters in BL
totalData = sum(cellfun(@(x) size(x, 1), BLdata));
blClusterPopul = cellfun(@(x) size(x,1), BLdata);
percentInBLcluster = cellfun(@(x) (size(x, 1)/totalData)*100, BLdata);

for i = 1:numel(healthData)
    healthData{i} = [healthData{i}.clusterX, healthData{i}.clusterY];
end

% percentage of data in each clusters in health manipulation
totalDataMan = zeros(1,length(healthData)/numClusters);
trtClusterPopul = cellfun(@(x) size(x,1), healthData);
percentInManCluster = cell(1,length(healthData)/numClusters);

% percentage of data in each clusters in health manipulation
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        totalDataMan(index/3) = sum(cellfun(@(x) size(x, 1), healthData(index-2:index)));
        percentInManCluster{index/3} = cellfun(@(x) (size(x, 1)/totalDataMan(index/3))*100, ...
            healthData(index-2:index));
    end
end

%% Plotting
for index = 1:length(healthData)
    if isequal(mod(index, 3), 0)
        figure;
        hold on;
        set(gcf, 'Windowstyle', 'docked');
        % Plot BL Clusters
        Colors = ["#77AC30", "magenta"];
        for i = 1:3
%             randomEllipseFun(BLdata{i}, Colors(1));
            error_ellipse_fun(BLdata{i}, 0.68, Colors(1));
        end

        % Plot health manipulation Clusters
        for i = index-2:index
%             randomEllipseFun(healthData{i}, Colors(2));
            error_ellipse_fun(healthData{i}, 0.68, Colors(2));
        end

        % Set Axis name
        xStr = split(healthName1{index}, ' ');
        xlabel(sprintf("%s", xStr{2}));
        yStr = split(healthName2{index}, ' ');
        ylabel(sprintf("%s", yStr{2}));

        title(sprintf("Comparison between BL Cluster and %s Clustes", xStr{1}), 'Interpreter','none');


        %% Mean shift Statistics
        pVal = cell(1,numClusters);
        for i = 1:length(pVal)
            [h, pVal{i}, ci, stats] = ttest2(BLdata{i}, healthData{index-3+i});
            text(min(xlim), (1 - 0.1*i)*max(ylim), sprintf("Cluster %d: " + ...
                "p(x) = %0.4f, p(y) = %0.4f", i, pVal{i}(1),  pVal{i}(2)));
        end

        %% Print percentage
        for i = 1:length(pVal)
            text(mean(xlim), (1 - 0.1*i)*max(ylim), ...
                sprintf("Cluster %d: BL %.0f, Man %0.f", i, percentInBLcluster(i), ...
                percentInManCluster{index/3}(i)));
        end

        %% chi-square test
        popDiffStat = zeros(1,numClusters);
        currentTrtClusterPop = trtClusterPopul(index-2:index);

        for i = 1:numClusters
            currentBlPop = blClusterPopul(i);
            currentTrtPop = trtClusterPopul(i);
            [popDiffStat(i), Q]= chi2test([currentBlPop, sum(blClusterPopul) - currentBlPop; ...
                currentTrtPop, sum(currentTrtClusterPop) - currentTrtPop]);
            text(max(xlim), (1 - 0.1*i)*max(ylim), ...
                sprintf("Cluster %d Pop: %.4f", i, popDiffStat(i)));
        end

%         N = [blClusterPopul; currentTrtClusterPop];
%         [significance, colsNotMrgd, finalCols, colsMrgdA, colsMrgdB] = dg_chi2test3(N, 1);
%         text((1-0.3)*max(xlim), (1 - 0.1*i)*max(ylim), ...
%                 sprintf("Pop. Sig. : %.4f", significance));
    
    end % figure 1
end
end