function [ids_that_arent_in_feature_table2] = find_what_isnt_in_feature_table(ids)
conn = database("live_database","postgres","1234");
ids_that_arent_in_feature_table2 = [];
all_ids_in_featuretable2 = fetch(conn,"SELECT id from featuretable2");
all_ids_in_featuretable2 = all_ids_in_featuretable2{:,1}.';

for i=1:length(ids)
    disp(strcat(string(i),"/",string(length(ids))))
    current_id = ids(i);
    if ~ismember(current_id,all_ids_in_featuretable2)
        ids_that_arent_in_feature_table2 = [ids_that_arent_in_feature_table2,current_id];
    end

end
close(conn)
end