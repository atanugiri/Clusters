function [T] = createMap(conn,query)
%experiment - a string which represents the experiment you wish to select
%conn - a database connection object 
%     - can be made with the following line of code
%       conn = database('live_database','postgres','1234');
%T - a matlab table sorted by date where the first column is the date, and the second column is the list of rats experimented on that date
disp(query)
local = fetch(conn,query);

%take the number of rows in the table
h = height(local);
i = 1;
T = table();
%creates a table of only the names and dates of the rats trials
namesAndDates = [local.referencetime,local.subjectid,local.mazenumber];
%display(namesAndDates)

%creates matlab containers that have the date as the key and
%the names as the values
M = containers.Map('Keytype', 'char', 'ValueType', 'any');

while i <= h
    %get the original date out of the row
    ogdate = string(namesAndDates(i,1));
    %extract only the first part of the date
    newdate = split(ogdate, " ");
    newdate = string(newdate(1));

    %try to add a new value to the container at key value
    %new date
    try
        %if current name is NOT already in the value then the
        %new name is added to the value
        if contains(namesAndDates(i,2), "none")
            i = i +1;
            continue
        end
        if contains(M(newdate),namesAndDates(i,2)) == 0
            M(newdate) = strcat(M(newdate), string(namesAndDates(i,2)),",");
        end
    catch
        %if we can't add new value to the key that must mean
        %the key doesn't appear yet, so we add the key and the
        %new value to the container
        M(newdate) = strcat(string(namesAndDates(i,2)),",");
    end
    i = i+1;
end





%                        disp(keys(M))
%disp((values(M)).')
%turn the values set into a vertical array for table formatting
T.Names = (values(M)).';
%turn the key set into a vertical array for table formatting
T.Dates = (keys(M)).';

sortingRow = [];


%sort the table so dates appear in ascending order
i = 1;
while i <= height(T)
    %split the dates into their independent month/day/year
    dateSplit = split(T{i,2},'/');
    %convert the month/day/year into minutes and add
    dateValue = str2double(dateSplit(1))*43800 +str2double(dateSplit(2))*1440 +str2double(dateSplit(3))*525600;
    %store value into an array
    sortingRow(i) = dateValue;
    i = i +1;
end
%             disp(sortingRow)


sortingTable = table();
sortingTable.Names = (values(M)).';
sortingTable.Dates = T.Dates;
sortingTable.sortingColumn = (sortingRow).';
%             display(sortingTable)
%sort the sorting table
[tblB,index] = sortrows(sortingTable,'sortingColumn');
%             disp(tblB)

%store the newly sorted values into the display table
T.Dates = tblB.Dates;
T.Names = tblB.Names;

%rearrage table to put dates first
T = movevars(T,'Names','After','Dates');


% %display table to user
% fig = uifigure;
% uit = uitable(fig,'ColumnWidth', 'fit', 'Data',T, 'Position', [1,1,510,400]);

% display(T)
    end