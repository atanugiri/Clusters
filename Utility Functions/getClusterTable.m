function cluster= getClusterTable(xVsY, labels,indexes)
%xvsY is 1row x 2 col array 
%labels are all labels of the data
%indexes are the indexes of the labels that belong to cluster the cluster
%cluster is the table that represents the cluster
    clusterX = xVsY(indexes,1);
    clusterY = xVsY(indexes,2);
    clusterLabels = labels(indexes).';
    cluster = table(clusterLabels,clusterX,clusterY);
end