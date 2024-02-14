function [] = get_session_data(table_of_data,conn)
counter =1;
%table_of_data - - a matlab table sorted by date where the first column is the date, and the second column is the list of rats experimented on that date
while counter <=size(table_of_data,1)
    try
        %disp(T{counter,1})
        animalsOnThatDate = (split(string(table_of_data{counter,2}),","));
        animalsOnThatDate = animalsOnThatDate.';
        %disp(animalsOnThatDate);
        secondaryCounter = 1;
        disp(table_of_data{counter,1})
        disp(animalsOnThatDate)
        while secondaryCounter < width(animalsOnThatDate)

            %                     disp(animalsOnThatDate{secondaryCounter})
            try

                query = strcat("SELECT subjectid, referencetime, feeder, approachavoid,rewardconcentration1,rewardconcentration2," + ...
                    "rewardconcentration3,rewardconcentration4 FROM live_table" + ...
                    " WHERE referencetime LIKE '",string(table_of_data{counter,1}),"%' AND subjectid = '", animalsOnThatDate{secondaryCounter},"';");

                disp(query);


                searchResults = fetch(conn,query);
                %display(searchResults)
                searchResults2 = rmmissing(searchResults, 'DataVariables',["feeder","approachavoid"]);
                %display(searchResults)
                if height(searchResults) == 0
                    display(searchResults)
                    disp("The following query resulted in NaNs")
                    disp(query)
                    counter = counter+1;
                    continue
                end
                %creates the psychomatical function
                [xcoordinates,ycoordinates] = createPsychometricFunction(searchResults2);
                %         display(class(xcoordinates))
                %         display(class(ycoordinates))
                data = table(string(animalsOnThatDate{secondaryCounter}),string(table_of_data{counter,1}),...
                    xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                    ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                    'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                %uploads the psychomatical function to the "psychomaticalFunctions"
                %table in the database
%                 sqlwrite(conn,"alcoholRewardChoicePsychometricFunctions",data)
                secondaryCounter = secondaryCounter +1;


            catch e
                disp("Error occured for the following query")
                disp(query)
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'The message was:\n%s',e.message)
                disp("_________________________________________________")
                counter = counter+1;
                secondaryCounter = secondaryCounter+1;
                somethingWrongCounter = somethingWrongCounter+1;
            end
        end
        %disp(animalsOnThatDate)



        counter = counter+1;
    catch e
        % disp("Error occured for the following query")
        % disp(query)
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'The message was:\n%s',e.message)
        disp("_________________________________________________")
        counter = counter+1;
        somethingWrongCounter = somethingWrongCounter+1;
    end


end
end