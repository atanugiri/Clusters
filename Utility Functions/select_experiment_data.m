function [] = select_experiment_data(conn,query)
%query - a PostgreSQL query in string format which represents the experiment data you wish to select
%conn - a database connection object 
%     - can be made with the following line of code
%       conn = database('live_database','postgres','1234');
table_of_data = createMap(conn,query);
disp(table_of_data)

number_of_sessions = 0;
for currentDate =1:height(table_of_data)
    all_rats_on_current_date = split(string(table_of_data{currentDate,2}),',');
%     display(all_rats_on_current_date);
    for currentRat=1:length(all_rats_on_current_date)
        if ~isempty(all_rats_on_current_date(currentRat))
            number_of_sessions = number_of_sessions+1;
        end
    end
end
disp(strcat("Number of sessions:",string(number_of_sessions)))

end