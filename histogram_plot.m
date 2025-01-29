folderPath = ['/Users/atanugiri/Downloads/Clusters/' ...
    'Baseline_Oxy_FoodDep_BoostAndEtho_Ghrelin_Saline_Cluster_Tables'];
% List all files in the folder
files = dir(fullfile(folderPath, 'Baseline M_*.xlsx'));

xVal = [];
yVal = [];

for i = 1:length(files)
    blTable = readtable(files(i).name);
    xVal = [xVal; blTable.clusterX];
    yVal = [yVal; blTable.clusterY];
    
end

% If ln(x) taken
max1 = exp(xVal); shift1 = exp(yVal);

[f_max1, max1_v] = ksdensity(max1);
[f_shift1, shift1_v] = ksdensity(shift1);

figure;
subplot(1,2,1);
plot(max1_v, f_max1, 'LineWidth', 2);
xlabel('Max'); ylabel('Probability density');
hold on;
subplot(1,2,2);
plot(shift1_v, f_shift1, 'LineWidth', 2);
xlabel('Shift'); ylabel('Probability density');