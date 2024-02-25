% Author: Atanu Giri
% Date: 02/07/2024

function BaselineVsTreatmentCluster(baseline, treatment)
% baseline = 'Baseline';
% treatment = 'Boost_and_Etho';

folderPath = ['/Users/atanugiri/Downloads/Clusters/' ...
    'Baseline_Oxy_FoodDep_BoostAndEtho_Ghrelin_Saline_Cluster_Tables'];

% List all files in the folder
files = dir(fullfile(folderPath, '*.xlsx'));

blClusters = treatmentClustersFun(baseline, files);
treatmentClusters = treatmentClustersFun(treatment, files);

%% Plotting
for feature = 1:length(blClusters)
    numClusters = length(blClusters{feature});
    figure(feature);
    set(gcf, 'Windowstyle', 'docked');
%     hold on;
%     Colors = lines(2*numClusters);
    Colors = ["#77AC30", "magenta"];

    % Population
    blClusterPopul = zeros(1, numClusters);
    trtClusterPopul = zeros(1, numClusters);

%     blLegend = {};
%     trtLegend = {};

    for clusterId = 1:numClusters
        blFilePath = fullfile(folderPath, blClusters{feature}(clusterId));
        % Define the regular expression pattern for legend
%         pattern = '(\w+) DT_\d+\.xlsx';
%         blMatch = regexp(blClusters{feature}(clusterId), pattern, 'tokens', 'once');
%         blLegend{clusterId} = sprintf('%s C%d', blMatch{1}{1}, clusterId);

        blTable = readtable(blFilePath{1});
        blData = [blTable.clusterX, blTable.clusterY];
%         randomEllipseFun(blData, Colors(clusterId,:));
        error_ellipse_fun(blData, 0.68, Colors(1));
        blClusterPopul(clusterId) = size(blData, 1);


        trtFilePath = fullfile(folderPath, treatmentClusters{feature}(clusterId));
        % Define the regular expression pattern for legend
%         pattern = '(\w+) DT_\d+\.xlsx';
%         trtMatch = regexp(treatmentClusters{feature}(clusterId), pattern, 'tokens', 'once');
%         trtLegend{clusterId} = sprintf('%s C%d', trtMatch{1}{1}, clusterId);

        trtTable = readtable(trtFilePath{1});
        trtData = [trtTable.clusterX, trtTable.clusterY];
%         randomEllipseFun(trtData, Colors(numClusters+clusterId,:));
        error_ellipse_fun(trtData, 0.68, Colors(2));
        trtClusterPopul(clusterId) = size(trtData, 1);

        %% t-test2
        [~, pVal, ~, ~] = ttest2(blData, trtData);
        text(1.1*mean(blData(:,1)), 1.1*mean(blData(:,2)), ["p = ", num2str(pVal)]);

        % Use regular expression to extract the desired part for title
        expression = ' (\w+)_';
        match = regexp(blFilePath, expression, 'tokens', 'once');
        title(sprintf("%s", match{1}{1}), 'FontSize', 30, 'Interpreter','none');
    end


    % Relative population
    pctBlData = arrayfun(@(x) (100*x/sum(blClusterPopul)), blClusterPopul);
    pctTrtData = arrayfun(@(x) (100*x/sum(trtClusterPopul)), trtClusterPopul);
    
    %% chi-square test
    popDiffStat = zeros(1,numClusters);

    for clusterId = 1:numClusters
        currentBlPop = blClusterPopul(clusterId);
        currentTrtPop = trtClusterPopul(clusterId);
        [popDiffStat(clusterId), Q]= chi2test([currentBlPop, sum(blClusterPopul) - currentBlPop; ...
            currentTrtPop, sum(trtClusterPopul) - currentTrtPop]);
    end

    % Plot the percentages on the figure
    xlimVals = xlim;
    ylimVals = ylim;
    xDist = (xlimVals(2) - xlimVals(1)) / numClusters; % Equal division along x-axis

    for clusterId = 1:numClusters
        xPos = xlimVals(1) + (clusterId - 0.5) * xDist; % Centered position for each cluster
        yPosBl = 0.8*ylimVals(2);
        yPosTrt = 0.7*ylimVals(2);

        % Percentage population
        text(xPos, yPosBl, sprintf('%.0f%%', pctBlData(clusterId)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        text(xPos, yPosTrt, sprintf('%.0f%%', pctTrtData(clusterId)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'red');

        % Statistics on population
        text(xPos, 0.5*ylimVals(2), sprintf('popul. p = %.4f', popDiffStat(clusterId)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end

    hold off;
end

%% Description of treatmentClustersFun
    function treatmentClusters = treatmentClustersFun(treatmentName, files)
        % Initialize a cell array to store filenames containing treatment
        % name
        treatment_files = {};

        % Loop through each file
        for i = 1:numel(files)
            % Check if the filename contains treatmentName
            if contains(files(i).name, treatmentName)
                % Add the filename to the cell array
                treatment_files{end+1} = files(i).name;
            end
        end

        % Initialize cell arrays for each cluster
        treatmentClusters = cell(1, 6);

        % Define clusters based on faeture cluster index
        treatmentClusters{1} = treatment_files(1:3);
        treatmentClusters{2} = treatment_files(4:6);
        treatmentClusters{3} = treatment_files(7:10);
        treatmentClusters{4} = treatment_files(11:13);
        treatmentClusters{5} = treatment_files(14:16);
        treatmentClusters{6} = treatment_files(17:19);
    end
end
