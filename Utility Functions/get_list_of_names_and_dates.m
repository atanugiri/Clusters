function [all_names,all_dates] = get_list_of_names_and_dates(directory_to_check)
%this function takes in a file path in string format and gets a list of all .figs and .mat files
%this is done to extract all the names and dates from already preformed experiments

all_figures_as_list = ls(strcat(directory_to_check,'\*/*.fig'));
all_figures_as_list = strtrim(all_figures_as_list);
all_figures_as_list = string(all_figures_as_list);
all_figures_as_list = unique(all_figures_as_list);
all_figures_as_list = strtrim(all_figures_as_list);
all_figures_as_list = all_figures_as_list(~contains(all_figures_as_list,"All Clusters"));
all_figures_as_list = all_figures_as_list(~contains(all_figures_as_list,"Max"));
all_figures_as_list = all_figures_as_list(~contains(all_figures_as_list,"Days"));
all_figures_as_list = all_figures_as_list(~contains(all_figures_as_list,"Reward"));
% disp(all_figures_as_list)
disp(size(all_figures_as_list))

all_fit_objects_as_list = ls(strcat(directory_to_check,'\*/*.mat'));
all_fit_objects_as_list = strtrim(all_fit_objects_as_list);
all_fit_objects_as_list = string(all_fit_objects_as_list);
all_fit_objects_as_list = unique(all_fit_objects_as_list);
all_fit_objects_as_list = strtrim(all_fit_objects_as_list);
all_fit_objects_as_list = all_fit_objects_as_list(~contains(all_fit_objects_as_list,"All Clusters"));
all_fit_objects_as_list = all_fit_objects_as_list(~contains(all_fit_objects_as_list,"Max"));
all_fit_objects_as_list = all_fit_objects_as_list(~contains(all_fit_objects_as_list,"Days"));
all_fit_objects_as_list = all_fit_objects_as_list(~contains(all_fit_objects_as_list,"Reward"));
% disp(all_fit_objects_as_list);
disp(size(all_fit_objects_as_list));

% disp(strmpi(all_figures_as_list,all_fit_objects_as_list));
everything_matching = true;

if length(all_fit_objects_as_list) >= length(all_figures_as_list)
    final_list = all_fit_objects_as_list;
else
    final_list = all_figures_as_list;
end

everything_split = split(final_list, " ");
all_names = everything_split(:,1);
all_dates = everything_split(:,2);

all_dates = strrep(all_dates,".fig","");
all_dates = strrep(all_dates,"-","/");

all_dates = strrep(all_dates,".mat","");
% disp(all_dates);
end