function [] = run_through_all_tables(cell_array_of_tables,directoryToSaveThingsTo,names_of_tables,createdby,what_feature)

    function [] = create_all_psychometric_functions_for_a_table(cell_array_of_tables,directoryToSaveThingsTo,names_of_tables,createdby,what_feature)
        table_of_psychometric_functions = table([],[],[],[],[],[],[],[],[],'VariableNames',{'label','x1','x2','x3','x4','y1','y2','y3','y4'});
        conn = database('live_database','postgres','1234');

        clc

        for i=1:length(cell_array_of_tables)
            if ~strcmpi(string(class(cell_array_of_tables{i})),'table')
                continue;
            end
            current_table = cell_array_of_tables{i};
            unique_ghrelin_rats_rat_toy = unique(current_table.Name);

            %remove the bad data
            unique_ghrelin_rats_rat_toy = strrep(unique_ghrelin_rats_rat_toy,"Freya","");
            unique_ghrelin_rats_rat_toy = strrep(unique_ghrelin_rats_rat_toy,"Bastet","");
            unique_ghrelin_rats_rat_toy = strrep(unique_ghrelin_rats_rat_toy,"Emma","");
            unique_ghrelin_rats_rat_toy = strrep(unique_ghrelin_rats_rat_toy,"Stitch","");
            unique_ghrelin_rats_rat_toy(strcmpi(unique_ghrelin_rats_rat_toy,"")) = [];
            % disp(unique_ghrelin_rats_rat_toy)
            unique_ghrelin_rats_rat_toy = strrep(unique_ghrelin_rats_rat_toy,"Pheobe", "phoebe"); %correct mispelling in data

            for current_rat = 1:length(unique_ghrelin_rats_rat_toy)
                the_current_rat = unique_ghrelin_rats_rat_toy(current_rat);
                %     disp(unique_ghrelin_rats_rat_toy(current_rat))
                list_of_dates_current_rat_ran = current_table.Date(strcmp(current_table.Name,unique_ghrelin_rats_rat_toy(current_rat)));
                %     disp(list_of_dates_current_rat_ran)
                for current_date = 1:length(list_of_dates_current_rat_ran)
                    %         disp(list_of_dates_current_rat_ran(current_date))
                    the_current_date = list_of_dates_current_rat_ran(current_date);
                    query =strcat("SELECT subjectid,referencetime,feeder,approachavoid," + ...
                        "rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4,trialcontrolsettings" + ...
                        " FROM live_table " + ...
                        "WHERE referencetime LIKE '",string(the_current_date),"%' AND LOWER(subjectid) = LOWER('",the_current_rat,"');");
                    %                     disp(query)
                    current_rat_and_date_results = fetch(conn,query);
                    %         disp(current_rat_and_date_results)
                    %         current_rat_and_date_results = string(current_rat_and_date_results{:,:});
                    %         disp(current_rat_and_date_results)
                    if height(current_rat_and_date_results) < 1 %this if statement catches the case where the query returns no data
                        disp(strcat(the_current_rat, " has no data on ",string(the_current_date)))
                        continue
                    end
                    current_rat_and_date_results = rmmissing(current_rat_and_date_results);
                    [xcoordinates,ycoordinates] = create_psychometric_function(current_rat_and_date_results,what_feature);
                    if length(ycoordinates)<1 %this if statement catches if there was an error in create_psychometric_function
                        continue
                    end

                    current_psychometric_function = table(strcat(the_current_rat, " ", string(the_current_date)), ...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4), ...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4), ...
                        'VariableNames',{'label','x1','x2','x3','x4','y1','y2','y3','y4'});

                    table_of_psychometric_functions = [table_of_psychometric_functions;current_psychometric_function];

                end
            end
            writetable(table_of_psychometric_functions,strcat(directoryToSaveThingsTo,"\",names_of_tables{i}, " rc ",createdby,'.xlsx'))

        end
        close(conn)
    end





create_all_psychometric_functions_for_a_table(cell_array_of_tables,directoryToSaveThingsTo,names_of_tables,createdby,what_feature)
end
