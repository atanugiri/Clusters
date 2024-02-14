function x = createThePlot(xVsY, labels, numberOfClusters,xAxis,yAxis,name,letter)
    x = 1;
    [centers,U] = fcm(xVsY,numberOfClusters);
    maxU = max(U);
    plotColors = ['or','og','ob','oc','om','oy',"#EDB120", "#7E2F8E","#D95319","#A2142F" ];
    plotCounter = 1;
    mkdir("All Clusters In Dataset")
    ogFolder = cd("All Clusters In Dataset");

    workingFolder = cd(ogFolder);
    figure
    hold on

    for i = 1:numberOfClusters
        indexes = find(U(i,:)==maxU);
        scatter([xVsY(indexes,1)],xVsY(indexes,2),plotColors(plotCounter))
        plot(centers(i,1),centers(i,2),'xk','MarkerSize',15,'LineWidth',3)
        cd(ogFolder)
        clusterTable = getClusterTable(xVsY,labels,indexes);
        cd(workingFolder)
        if exist(strcat(letter,string(i), ".xlsx"),'file')==2
            delete(strcat(letter,string(i), ".xlsx"));
        end
        writetable(clusterTable,strcat(letter,string(i), ".xlsx"))
        if plotCounter == 10
            plotCounter = 1;
        else
            plotCounter = plotCounter+1;
        end
    end
    cd(ogFolder)
    plotCounter = 1;
    title(strcat(name," ",xAxis, " vs ", yAxis, " Clusters"))
    xlabel(xAxis)
    ylabel(yAxis)
    disp(calculate_mpc(U))
end