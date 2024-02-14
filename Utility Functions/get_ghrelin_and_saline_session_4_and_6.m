function [] = get_ghrelin_and_saline_session_4_and_6(directoryToSaveThingsTo,which_experiments_to_combine)

addpath('Utility Functions\')
clc
if ~exist(directoryToSaveThingsTo,"dir")
    mkdir(directoryToSaveThingsTo)
end
homeDir = cd(directoryToSaveThingsTo);
directoryToSaveThingsTo = cd(homeDir);
%% Get Session Counts For Ghrelin Toy Sessions
table_of_rat_and_date_info = readtable('Ghrelin_info.xlsx','Sheet','Automatic Ghr ToyRAT Session #s');

%disp(table_of_rat_and_date_info)
session_number = string(table_of_rat_and_date_info.Var2);
ghrelin_rat_names = string(table_of_rat_and_date_info.Var3);
ghrelin_rat_session_dates = table_of_rat_and_date_info.Var4;
toy = string(table_of_rat_and_date_info.Var5);


table_of_rat_and_date_info = table(session_number,ghrelin_rat_names,ghrelin_rat_session_dates,toy,'VariableNames',{'Session','Name','Date','Toy'});
% disp(table_of_rat_and_date_info)
table_of_rat_and_date_info = convertvars(table_of_rat_and_date_info,@isdatetime,@(t) datetime(t,'Format','MM/dd/yyyy'));
% disp(table_of_rat_and_date_info)
disp(height(table_of_rat_and_date_info))

% table_of_rat_and_date_info = rmmissing(table_of_rat_and_date_info);
ghrelin_toy_data = table_of_rat_and_date_info;
rat_toy_ghrelin_data = ghrelin_toy_data(strcmpi(table_of_rat_and_date_info.Session,"4"),:);
stick_toy_ghrelin_data=ghrelin_toy_data(strcmpi(table_of_rat_and_date_info.Session,"6"),:);
%% Get Session Counts For Saline Toy Sessions
% disp("///////////////////////////////////")
table_of_rat_and_date_info = readtable('Ghrelin_info.xlsx','Sheet','Automatic Ghr ToyRAT Session #s');

% disp(table_of_rat_and_date_info)
session_number = string(table_of_rat_and_date_info.Var10);
saline_rat_names = string(table_of_rat_and_date_info.Var11);
saline_rat_session_dates = table_of_rat_and_date_info.Var12;
toy = string(table_of_rat_and_date_info.Var13);
table_of_rat_and_date_info = table(session_number,saline_rat_names,saline_rat_session_dates,toy,'VariableNames',{'Session','Name','Date','Toy'});
% % disp(table_of_rat_and_date_info)
table_of_rat_and_date_info = convertvars(table_of_rat_and_date_info,@isdatetime,@(t) datetime(t,'Format','MM/dd/yyyy'));
% % disp(table_of_rat_and_date_info)
%
disp(height(table_of_rat_and_date_info))
% table_of_rat_and_date_info = rmmissing(table_of_rat_and_date_info);

% disp(table_of_rat_and_date_info)

saline_toy_data = table_of_rat_and_date_info;
rat_toy_saline_data = saline_toy_data(strcmpi(table_of_rat_and_date_info.Session,"4"),:);
stick_toy_saline_data= saline_toy_data(strcmpi(table_of_rat_and_date_info.Session,"6"),:);



%% Construct the ghrelin psychometric functions for each of the tables found above
ghrelin_combination_table = table([],[],[],[],'VariableNames',{'Session','Name','Date','Toy'});
ghrelin_combination_labels = '';
saline_combination_table = table([],[],[],[],'VariableNames',{'Session','Name','Date','Toy'});
saline_combination_labels = ''; 
is_in_combination = [false false];
if length(which_experiments_to_combine) > 1
    for i=1:length(which_experiments_to_combine)
        switch which_experiments_to_combine(i)
            case 'rat_toy'
                ghrelin_combination_table = [ghrelin_combination_table;rat_toy_ghrelin_data];
                saline_combination_table = [saline_combination_table;rat_toy_saline_data];
                ghrelin_combination_labels=strcat(ghrelin_combination_labels,"_ghrelin_4_");
                saline_combination_labels=strcat(saline_combination_labels,"_saline_4_");
                is_in_combination(i) = true;
%                 break;
            case 'stick_toy'
                ghrelin_combination_table = [ghrelin_combination_table;stick_toy_ghrelin_data];
                saline_combination_table = [saline_combination_table;stick_toy_saline_data];
                is_in_combination(i) = true;
                ghrelin_combination_labels=strcat(ghrelin_combination_labels,"_ghrelin_6_");
                saline_combination_labels=strcat(saline_combination_labels,"_saline_6_");
%                 break;
        end
    end
    all_ghrelin_toy_tables = {rat_toy_ghrelin_data,stick_toy_ghrelin_data};
    all_saline_toy_tables = {rat_toy_saline_data,stick_toy_saline_data};
    ghrelin_data_labels = ["Ghrelin_4", "Ghrelin_6"];
    saline_data_labels = ["Saline_4", "Saline_6"]; 

    for i=1:length(is_in_combination)
        if boolean(is_in_combination(i))
            all_ghrelin_toy_tables{i} = [];
            all_saline_toy_tables{i} = []; 
            saline_data_labels(i) = '';
            ghrelin_data_labels(i) = '';
        end
    end
    all_ghrelin_toy_tables{end+1} = ghrelin_combination_table;
    all_saline_toy_tables{end+1} = saline_combination_table;
    saline_data_labels = [saline_data_labels, saline_combination_labels];
    ghrelin_data_labels = [ghrelin_data_labels, ghrelin_combination_labels];

    run_through_all_tables(all_ghrelin_toy_tables,directoryToSaveThingsTo,ghrelin_data_labels,"created by get_ghrelin_and_saline_session_4_and_6.m","rc")
    run_through_all_tables(all_saline_toy_tables,directoryToSaveThingsTo,saline_data_labels,"created by get_ghrelin_and_saline_session_4_and_6.m","rc")




else %if the length is zero that means don't combine any experiments
    all_ghrelin_toy_tables = {rat_toy_ghrelin_data,stick_toy_ghrelin_data};
    all_saline_toy_tables = {rat_toy_saline_data,stick_toy_saline_data};


    run_through_all_tables(all_ghrelin_toy_tables,directoryToSaveThingsTo,["Ghrelin_4", "Ghrelin_6"],"created by get_ghrelin_and_saline_session_4_and_6.m","rc")
    run_through_all_tables(all_saline_toy_tables,directoryToSaveThingsTo,["Saline_4", "Saline_6"],"created by get_ghrelin_and_saline_session_4_and_6.m","rc")
end





end
