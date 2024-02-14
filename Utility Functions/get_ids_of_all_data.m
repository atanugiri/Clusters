function ids = get_ids_of_all_data(all_experiment_names,all_experiment_dates,all_experiments)
ids = [];
conn = database("live_database","postgres","1234");
for i=1:length(all_experiment_names)
    current_experiment_names = all_experiment_names{i};
    current_experiment_dates = all_experiment_dates{i};
    current_experiment = all_experiments{i};
    for j=1:length(current_experiment_names)
        current_subject_id = current_experiment_names(j);
        current_date = current_experiment_dates(j);
        query = strcat("SELECT id from live_table where subjectid = '",current_subject_id,"' AND referencetime LIKE '",current_date,"%';");
        disp(query)
        result = fetch(conn,query);
        disp(result)
        ids = [ids,result{:,1}.'];
    end
end
end