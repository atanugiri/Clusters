% Author: Atanu Giri
% Date: 02/07/2024

% This function takes the cluster parameters as input file plots control vs
% treatment clusters. It also calculates the percentage population in
% clusters and runs ststistics

function BaselineVsTreatmentCluster(baseline, treatment)

% Example usage
% BaselineVsTreatmentCluster('Baseline', 'Food_Deprivation')

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
    Colors = ["#77AC30", "magenta"];

    % Population
    blClusterPopul = zeros(1, numClusters);
    trtClusterPopul = zeros(1, numClusters);

    for clusterId = 1:numClusters
        blFilePath = fullfile(folderPath, blClusters{feature}(clusterId));
        blTable = readtable(blFilePath{1});
        blData = [blTable.clusterX, blTable.clusterY];

        if isequal(clusterId, 1)
            jitter_amount = 1; % User adjustable
            blData(:,2) = blData(:,2) + jitter_amount * randn(size(blData(:,2)));
        end

        error_ellipse_fun(blData, 0.68, Colors(1));
        blClusterPopul(clusterId) = size(blData, 1);

        trtFilePath = fullfile(folderPath, treatmentClusters{feature}(clusterId));
        trtTable = readtable(trtFilePath{1});
        trtData = [trtTable.clusterX, trtTable.clusterY];

        % Because cluster 1 is 1-D data, not visible
        if isequal(clusterId, 1)
            jitter_amount = 1; % User adjustable
            trtData(:,2) = trtData(:,2) + jitter_amount * randn(size(trtData(:,2)));
        end

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

    % Print the Chi-squared result on figure
    xlimVals = xlim;
    ylimVals = ylim;
    xDist = (xlimVals(2) - xlimVals(1)) / numClusters; % Equal division along x-axis

    for clusterId = 1:numClusters
        xPos = xlimVals(1) + (clusterId - 0.5) * xDist; % Centered position for each cluster
        yPosBl = 0.8*ylimVals(2);

        text(xPos, yPosBl, sprintf('popul. p = %.4f', popDiffStat(clusterId)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', 'red');
    end

    hold off;

    % Plot bar plot
    figure(length(blClusters) + feature);
    set(gcf, 'Windowstyle', 'docked');
    barData = [pctBlData(end:-1:1); pctTrtData(end:-1:1)];
    bar(barData, 'stacked');
    xt = get(gca, 'XTick');
    set(gca, 'XTick', xt, 'XTickLabel', {'Control' 'Treatment'});
    barbase = cumsum([zeros(size(barData,1),1) barData(:,1:end-1)],2);
    joblblpos = barData/2 + barbase;
    for k1 = 1:size(barData,1)
        text(xt(k1)*ones(1,size(barData,2)), joblblpos(k1,:), ...
            arrayfun(@(x) sprintf('%.2f', x), barData(k1,:), 'UniformOutput', false), ...
            'HorizontalAlignment','center');
    end
    title(sprintf("%s", match{1}{1}), 'FontSize', 30, 'Interpreter','none');
    ylabel('% population', 'Interpreter','latex');
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
