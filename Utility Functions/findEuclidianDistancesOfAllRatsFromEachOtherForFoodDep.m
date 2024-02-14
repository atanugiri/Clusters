%locationOfFoodDepData = 'C:\Users\ldd77\OneDrive\Desktop\UTEP-Brain-Computation-Lab-Remote-Databases-and-Serendipity-App\Create Probability Tables\Food Deprivation';
% locationOfFoodDepData = 'C:\Users\ldd77\OneDrive\Desktop\UTEP-Brain-Computation-Lab-Remote-Databases-and-Serendipity-App\Create Probability Tables\Baseline Clusters';

function [allEuclidianDistances] = findEuclidianDistancesOfAllRatsFromEachOtherForFoodDep(location_of_cluster_tables,experiment,excludeOrDont,onlyDoSingleVariable,singleVariable) 

if onlyDoSingleVariable
    allClustersInFoodDepData = ls(strcat(location_of_cluster_tables,'\',experiment,"*",singleVariable,'*.xlsx'));
%     disp(allClustersInFoodDepData)
else
    allClustersInFoodDepData = ls(strcat(location_of_cluster_tables,'\*',experiment,"*.xlsx"));
end


listOfallFiles = cell(1,height(allClustersInFoodDepData));
mapOfDataSetSizes = containers.Map('KeyType','char','ValueType','any');
mapOfAllUniqueRatsInEachDataSet = containers.Map('KeyType','char','ValueType','any');
mapOfEachRatsTotalAppearencesInDataSet = containers.Map('KeyType','char','ValueType','any');
mapOfEachRatsAppearenceInCluster = containers.Map('KeyType','char','ValueType','any');

allRatsList = [];
allClustersList = strrep(string(allClustersInFoodDepData),experiment,"");
allClustersList = strtrim(strrep(allClustersList,".xlsx",""));
defaultProbabilities = zeros(1,length(allClustersList));

for i=1:height(allClustersInFoodDepData)
    listOfallFiles{i} = readtable(strcat(location_of_cluster_tables,"\",string(allClustersInFoodDepData(i,:))));
    % currentDataSet = char(strrep(string(allClustersInFoodDepData(i,:)),experiment,""));


    if strcmpi(experiment,"Boost_and_Etho")
        currentDataSet = split(allClustersInFoodDepData(i,:),"_");
        currentCluster = currentDataSet{end};
        currentDataSet = strcat(currentDataSet{1},"_",currentDataSet{2},"_",currentDataSet{3});
    elseif strcmpi(experiment,"Food_Deprivation")
        currentDataSet = split(allClustersInFoodDepData(i,:),"_");
        currentCluster = currentDataSet{end};
        currentDataSet = strcat(currentDataSet{1},"_",currentDataSet{2});

    else
        currentDataSet = split(allClustersInFoodDepData(i,:),"_");
        currentCluster = currentDataSet{end};
        currentDataSet = currentDataSet{1};

    end
    currentDataSet = strrep(currentDataSet,experiment,"");
    currentCluster = strrep(currentCluster,".xlsx","");
    currentCluster = strrep(currentCluster,"1",strcat(strtrim(string(currentDataSet)),"_1"));
    currentCluster = strrep(currentCluster,"2",strcat(strtrim(string(currentDataSet)),"_2"));
    currentCluster = strrep(currentCluster,"3",strcat(strtrim(string(currentDataSet)),"_3"));
    currentCluster = strrep(currentCluster,"4",strcat(strtrim(string(currentDataSet)),"_4"));
    currentCluster = strrep(currentCluster,"5",strcat(strtrim(string(currentDataSet)),"_5"));




    % disp(currentDataSet)
    % disp(currentCluster)
    listOfAllRatsInCurrentCluster = split(string(listOfallFiles{i}.clusterLabels)," ");
    %     disp(listOfAllRatsInCurrentCluster)
    listOfAllRatsInCurrentCluster = listOfAllRatsInCurrentCluster(:,1);
    allRatsList = [allRatsList;listOfAllRatsInCurrentCluster];
    for j=1:height(listOfAllRatsInCurrentCluster)
        currentRat = listOfAllRatsInCurrentCluster(j);
        if ~isKey(mapOfEachRatsTotalAppearencesInDataSet,strtrim(strcat(currentDataSet," ",currentRat)))
            mapOfEachRatsTotalAppearencesInDataSet(strtrim(strcat(currentDataSet," ",currentRat))) = 1;
        else
            mapOfEachRatsTotalAppearencesInDataSet(strtrim(strcat(currentDataSet," ",currentRat))) = mapOfEachRatsTotalAppearencesInDataSet(strtrim(strcat(currentDataSet," ",currentRat))) +1;
        end

        if ~isKey(mapOfEachRatsAppearenceInCluster,strcat(currentCluster," ",currentRat))
            mapOfEachRatsAppearenceInCluster(strcat(currentCluster," ",currentRat)) = 1;
        else
            mapOfEachRatsAppearenceInCluster(strcat(currentCluster," ",currentRat)) = mapOfEachRatsAppearenceInCluster(strcat(currentCluster," ",currentRat)) +1;
        end
    end
    listOfAllRatsInCurrentCluster = unique(listOfAllRatsInCurrentCluster);
   % disp(listOfAllRatsInCurrentCluster);
    listOfAllRatsInCurrentCluster = unique(listOfAllRatsInCurrentCluster);
%     disp(listOfAllRatsInCurrentCluster);

    if ~isKey(mapOfDataSetSizes,currentDataSet)
        mapOfDataSetSizes(currentDataSet) = height(listOfallFiles{i});
        mapOfAllUniqueRatsInEachDataSet(currentDataSet) = listOfAllRatsInCurrentCluster;
    else
        mapOfDataSetSizes(currentDataSet) = mapOfDataSetSizes(currentDataSet) + height(listOfallFiles{i});
        mapOfAllUniqueRatsInEachDataSet(currentDataSet) = [mapOfAllUniqueRatsInEachDataSet(currentDataSet);listOfAllRatsInCurrentCluster];
        mapOfAllUniqueRatsInEachDataSet(currentDataSet) = unique(mapOfAllUniqueRatsInEachDataSet(currentDataSet));
    end


end

%% Calculate Probabilities For Each Rat
allRatsList = unique(allRatsList);

tableOfEachRatsAppearencePerCluster = table(string(keys(mapOfEachRatsAppearenceInCluster).'),cell2mat(values((mapOfEachRatsAppearenceInCluster)).'),'VariableNames',{'cluster_and_name','number_of_appearences'});
if strcmpi(singleVariable,"RP4_")
    tableOfEachRatsAppearencePerCluster{:,1} = strrep(tableOfEachRatsAppearencePerCluster.cluster_and_name,"RP4_","");
end
%disp(tableOfRatEachRatsAppearencePerCluster)

tableOfClustersToDefaultProbabilities = table(allClustersList,defaultProbabilities.','VariableNames',{'cluster','default_probabilities'});
% disp(tableOfClustersToDefaultProbabilities)

ratsToTheirProbabilityVectors = containers.Map('KeyType','char','ValueType','any');
for i=1:height(allRatsList)
    currentRat = allRatsList(i);
    tableOfASingleRat = tableOfEachRatsAppearencePerCluster(contains(tableOfEachRatsAppearencePerCluster.cluster_and_name,currentRat),:);
    %disp(tableOfASingleRat)
    cluster= split(tableOfASingleRat.cluster_and_name," ");
    cluster = cluster(:,1);
    if height(tableOfASingleRat)==1
        cluster = cluster(1);
        % disp(cluster)
        tableOfASingleRat.cluster = cluster;
    else
        tableOfASingleRat.cluster = cluster;
    end

    if strcmpi(experiment,"Boost_And_Etho")
        % disp("hello")
        for table_counter =1:height(tableOfASingleRat)
            current_cluster_and_name_and_experiment = tableOfASingleRat{table_counter,1};
            current_cluster_and_name_and_experiment = split(current_cluster_and_name_and_experiment," ");
            current_cluster = strcat(string(current_cluster_and_name_and_experiment{1})," ",current_cluster_and_name_and_experiment{2});
            tableOfASingleRat{table_counter,3} = current_cluster;
        end
    end
    
%     disp(tableOfASingleRat)
    
    for outer_table_counter = 1:height(tableOfClustersToDefaultProbabilities)
        outer_table_cluster = tableOfClustersToDefaultProbabilities{outer_table_counter,1};
        found_inside = false;
        for inner_Table_counter =1:height(tableOfASingleRat)
            inner_table_cluster= tableOfASingleRat{inner_Table_counter,1};
            if contains(inner_table_cluster,outer_table_cluster)
                found_inside = true;
                break;
            else
                which_one_is_missing = outer_table_cluster;
            end
        end
        if ~found_inside
            single_row = table("",0,which_one_is_missing,'VariableNames',{'cluster_and_name','number_of_appearences','cluster'});
            tableOfASingleRat = [tableOfASingleRat;single_row];
        end
    end

    organizedTable = outerjoin(tableOfClustersToDefaultProbabilities,tableOfASingleRat,"Keys","cluster");

    %disp(organizedTable)
    currentRatAppearences = organizedTable.number_of_appearences;
    currentRatAppearences(isnan(currentRatAppearences)) =0;
    tableOfCurrentRatAppearencesInEachCluster = table(organizedTable.cluster_tableOfClustersToDefaultProbabilities,currentRatAppearences,'VariableNames',{'Cluster','Number_Of_Appearences'});
    %disp(tableOfCurrentRatAppearencesInEachCluster)
    vectorOfProbabilities = zeros(1,height(tableOfCurrentRatAppearencesInEachCluster));
    for j=1:height(tableOfCurrentRatAppearencesInEachCluster)
        currentDataSet = tableOfCurrentRatAppearencesInEachCluster{j,1};
        currentDataSet = split(currentDataSet,"_");
        % display(currentDataSet)
       
        currentDataSet = currentDataSet{1};
        %disp(currentDataSet)
        currentNumberOfAppearences = tableOfCurrentRatAppearencesInEachCluster{j,2};
        if currentNumberOfAppearences ~=0
            if strcmpi(experiment,"Boost_and_etho")
                disp("hello")
                currentDataSet = strcat('Boost_and_Etho'," ",strrep(singleVariable,"_",""));
            end
            vectorOfProbabilities(j) = currentNumberOfAppearences / mapOfEachRatsTotalAppearencesInDataSet(strcat(currentDataSet," ",currentRat));
        end
    end
    if excludeOrDont
        oldRatList = ['aladdin', 'alexis', 'andrea', 'carl', 'fiona', 'harley', 'jafar', 'jimi', 'johnny', 'jr', 'juana', 'kobe', 'kryssia', 'mike','neftali', 'raissa', 'raven', 'renata', 'sarah', 'scar', 'shakira', 'simba', 'sully'];
        if ~contains(oldRatList,currentRat)
            continue
        else
%            disp("current Rat is an old rat")
           ratsToTheirProbabilityVectors(currentRat) = vectorOfProbabilities;
        end
    else
        ratsToTheirProbabilityVectors(currentRat) = vectorOfProbabilities;
    end
    

end

%% get distribution of euclidian distances of all rats to each other 

tableOfRatsToProbVec = table(string(keys(ratsToTheirProbabilityVectors).'),values(ratsToTheirProbabilityVectors).','VariableNames',{'rat','probabilities'});
% disp(tableOfRatsToProbVec)
justProbabilities = cell2mat(tableOfRatsToProbVec.probabilities);
% disp(justProbabilities)
allEuclidianDistances = [];
for i=1:height(justProbabilities)
    for j=1:height(justProbabilities)
        if i~=j
            vec1 = justProbabilities(i,:);
            vec2 = justProbabilities(j,:);
            eucDistance = vec1 - vec2;
            result = sqrt(eucDistance * eucDistance');
            allEuclidianDistances = [allEuclidianDistances,result];
        end
    end
end


histogram(allEuclidianDistances,'normalization','probability','BinEdges',0:0.05:3);
hold on
end