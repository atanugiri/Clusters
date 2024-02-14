function [] = automize_psychometric_functions_new_features(subject_ids,dates,experiment)

    function [theFormattedDate] = formatTheDate(theDate)
        theYear = string(theDate(3));
        theDay = string(theDate(2));
        theMonth = string(theDate(1));

        switch theMonth
            case '01'
                theMonth = "Jan";
            case '02'
                theMonth = "Feb";
            case '03'
                theMonth = "Mar";
            case '04'
                theMonth = "Apr";
            case '05'
                theMonth = "May";
            case '06'
                theMonth = "Jun";
            case '07'
                theMonth = "Jul";
            case '08'
                theMonth = "Aug";
            case '09'
                theMonth = "Sep";
            case '10'
                theMonth = "Oct";
            case '11'
                theMonth = "Nov";
            case '12'
                theMonth = "Dec";
        end
        theFormattedDate = strcat(theDay,"-",theMonth,"-",theYear);
    end
    function [xcoordinates,ycoordinates] = createRewardChoicePsychometricFunction(searchResults)
        local = searchResults;
        local2 = [str2double(local.approachavoid),str2double(local.feeder)];
        if sum(isnan(local2)) > 0
            display(local)
            display(isnan(table2array(local)))
            disp("NAN DETECTED")
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Approaches = 0.00;
        feeder2Approaches = 0.00;
        feeder3Approaches = 0.00;
        feeder4Approaches = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            feederValue = string(local{i,3});
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented
            if str2double(string(local{i,4})) == 1
                switch feederValue
                    case '1'
                        feeder1Approaches = feeder1Approaches+1;
                    case '2'
                        feeder2Approaches = feeder2Approaches+1;
                    case '3'
                        feeder3Approaches = feeder3Approaches+1;
                    case '4'
                        feeder4Approaches = feeder4Approaches+1;
                end

            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %display(approaches)
        appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1ApproachPercentage = feeder1Approaches / feeder1Appearences;
        feeder2ApproachPercentage = feeder2Approaches / feeder2Appearences;
        feeder3ApproachPercentage =feeder3Approaches / feeder3Appearences;
        feeder4ApproachPercentage =feeder4Approaches / feeder4Appearences;

        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        feeder1Percentage = str2double(regexprep(string(local{1,5}),'%','')) / 100;
        feeder2Percentage = str2double(regexprep(string(local{1,6}),'%',''))/100;
        feeder3Percentage = str2double(regexprep(string(local{1,7}),'%',''))/100;
        feeder4Percentage = str2double(regexprep(string(local{1,8}),'%',''))/100;

        ycoordinates = [feeder1ApproachPercentage, feeder2ApproachPercentage, feeder3ApproachPercentage, feeder4ApproachPercentage ];
        xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];


        %         display(xcoordinates)
        %         display(ycoordinates)
    end

    function [ycoordinates] = createReactionTimePsychometricFunction(searchResults)
        local = searchResults;
        local2 = [str2double(local.reactiontime1st)];
        if sum(isnan(local2)) > 0
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Totals = 0.00;
        feeder2Totals = 0.00;
        feeder3Totals = 0.00;
        feeder4Totals = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            result3 = fetch(conn,strcat("SELECT feeder,rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4 FROM live_table WHERE id = ",string(local{i,1}),";"));
            %disp(i)
            feederValue = string(result3{1,1});
            %display(result3)
            %display(local)
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented

            switch feederValue
                %FIX THIS RIGHT HERE ADD THE TRAVEL PIXEL OR OTEHER
                %FEATURE VALUES
                case '1'
                    feeder1Totals = feeder1Totals + str2double(string(local{i,4}));
                case '2'
                    feeder2Totals = feeder2Totals +str2double(string(local{i,4}));
                case '3'
                    feeder3Totals = feeder3Totals+str2double(string(local{i,4}));
                case '4'
                    feeder4Totals = feeder4Totals+str2double(string(local{i,4}));
            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        %         approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %         %display(approaches)
        %         appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %         %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %         disp("Feeder 1-4 Totals")
        %         disp(feeder1Totals)
        %         disp(feeder2Totals)
        %         disp(feeder3Totals)
        %         disp(feeder4Totals)
        %
        %         disp("Feeder 1:4 Appearences")
        %         disp(feeder1Appearences)
        %         disp(feeder2Appearences)
        %         disp(feeder3Appearences)
        %         disp(feeder4Appearences)

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1Average = feeder1Totals / feeder1Appearences;
        feeder2Average = feeder2Totals / feeder2Appearences;
        feeder3Average =feeder3Totals / feeder3Appearences;
        feeder4Average =feeder4Totals / feeder4Appearences;



        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        %         feeder1Percentage = str2double(regexprep(string(result3{1,2}),'%','')) / 100;
        %         feeder2Percentage = str2double(regexprep(string(result3{1,3}),'%',''))/100;
        %         feeder3Percentage = str2double(regexprep(string(result3{1,4}),'%',''))/100;
        %         feeder4Percentage = str2double(regexprep(string(result3{1,5}),'%',''))/100;



        ycoordinates = [feeder1Average, feeder2Average, feeder3Average, feeder4Average ];
        %         xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];
        %         display(xcoordinates)
        %         display(ycoordinates)
    end
    function [ycoordinates] = createRotationPointsPsychometricFunction(searchResults,method)
        local = searchResults;
        if method==1
            local2 = [str2double(local.rotationptsmethod1)];
        elseif method==4
            local2 = [str2double(local.rotationptsmethod4)];
        end

        if sum(isnan(local2)) > 0
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Totals = 0.00;
        feeder2Totals = 0.00;
        feeder3Totals = 0.00;
        feeder4Totals = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            result3 = fetch(conn,strcat("SELECT feeder,rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4 FROM live_table WHERE id = ",string(local{i,1}),";"));
            %disp(i)
            feederValue = string(result3{1,1});
            %display(result3)
            %display(local)
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented

            switch feederValue
                %FIX THIS RIGHT HERE ADD THE TRAVEL PIXEL OR OTEHER
                %FEATURE VALUES
                case '1'
                    feeder1Totals = feeder1Totals + str2double(string(local{i,4}));
                case '2'
                    feeder2Totals = feeder2Totals +str2double(string(local{i,4}));
                case '3'
                    feeder3Totals = feeder3Totals+str2double(string(local{i,4}));
                case '4'
                    feeder4Totals = feeder4Totals+str2double(string(local{i,4}));
            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        %         approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %         %display(approaches)
        %         appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %         %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %         disp("Feeder 1-4 Totals")
        %         disp(feeder1Totals)
        %         disp(feeder2Totals)
        %         disp(feeder3Totals)
        %         disp(feeder4Totals)
        %
        %         disp("Feeder 1:4 Appearences")
        %         disp(feeder1Appearences)
        %         disp(feeder2Appearences)
        %         disp(feeder3Appearences)
        %         disp(feeder4Appearences)

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1Average = feeder1Totals / feeder1Appearences;
        feeder2Average = feeder2Totals / feeder2Appearences;
        feeder3Average =feeder3Totals / feeder3Appearences;
        feeder4Average =feeder4Totals / feeder4Appearences;






        ycoordinates = [feeder1Average, feeder2Average, feeder3Average, feeder4Average ];
        %         xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];


        %          display(xcoordinates)
        %         display(ycoordinates)
    end
    function[xcoordinates,ycoordinates] = createStoppingPointsPsychometricFunction(searchResults)
        local = searchResults;
        local2 = [str2double(local.stoppingpts_per_unittravel_method6)];
        if sum(isnan(local2)) > 0
            %display(local)
            %             display(isnan(table2array(local)))
            %             disp("NAN DETECTED")
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Totals = 0.00;
        feeder2Totals = 0.00;
        feeder3Totals = 0.00;
        feeder4Totals = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            result3 = fetch(conn,strcat("SELECT feeder,rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4 FROM live_table WHERE id = ",string(local{i,1}),";"));
            %disp(i)
            feederValue = string(result3{1,1});
            %display(result3)
            %display(local)
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented

            switch feederValue
                %FIX THIS RIGHT HERE ADD THE TRAVEL PIXEL OR OTEHER
                %FEATURE VALUES
                case '1'
                    feeder1Totals = feeder1Totals + (str2double(string(local{i,4})));
                case '2'
                    feeder2Totals = feeder2Totals +(str2double(string(local{i,4})));
                case '3'
                    feeder3Totals = feeder3Totals+(str2double(string(local{i,4})));
                case '4'
                    feeder4Totals = feeder4Totals+(str2double(string(local{i,4})));
            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        %         approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %         %display(approaches)
        %         appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %         %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %         disp("Feeder 1-4 Totals")
        %         disp(feeder1Totals)
        %         disp(feeder2Totals)
        %         disp(feeder3Totals)
        %         disp(feeder4Totals)
        %
        %         disp("Feeder 1:4 Appearences")
        %         disp(feeder1Appearences)
        %         disp(feeder2Appearences)
        %         disp(feeder3Appearences)
        %         disp(feeder4Appearences)

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1Average = feeder1Totals / feeder1Appearences;
        feeder2Average = feeder2Totals / feeder2Appearences;
        feeder3Average =feeder3Totals / feeder3Appearences;
        feeder4Average =feeder4Totals / feeder4Appearences;



        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        feeder1Percentage = str2double(regexprep(string(result3{1,2}),'%','')) / 100;
        feeder2Percentage = str2double(regexprep(string(result3{1,3}),'%',''))/100;
        feeder3Percentage = str2double(regexprep(string(result3{1,4}),'%',''))/100;
        feeder4Percentage = str2double(regexprep(string(result3{1,5}),'%',''))/100;

        ycoordinates = [feeder1Average, feeder2Average, feeder3Average, feeder4Average ];
        xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];


        %         display(xcoordinates)
        %         display(ycoordinates)
    end
    function[xcoordinates,ycoordinates] = createTravelPixelPsychometricFunction(searchResults)
        local = searchResults;
        local2 = [str2double(local.distanceaftertoneuntillimitingtimestamp)];
        if sum(isnan(local2)) > 0
            %display(local)
            %             display(isnan(table2array(local)))
            %             disp("NAN DETECTED")
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Totals = 0.00;
        feeder2Totals = 0.00;
        feeder3Totals = 0.00;
        feeder4Totals = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            result3 = fetch(conn,strcat("SELECT feeder,rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4 FROM live_table WHERE id = ",string(local{i,1}),";"));
            %disp(i)
            feederValue = string(result3{1,1});
            %display(result3)
            %display(local)
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented

            switch feederValue
                %FIX THIS RIGHT HERE ADD THE TRAVEL PIXEL OR OTEHER
                %FEATURE VALUES
                case '1'
                    feeder1Totals = feeder1Totals + str2double(string(local{i,4}));
                case '2'
                    feeder2Totals = feeder2Totals +str2double(string(local{i,4}));
                case '3'
                    feeder3Totals = feeder3Totals+str2double(string(local{i,4}));
                case '4'
                    feeder4Totals = feeder4Totals+str2double(string(local{i,4}));
            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        %         approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %         %display(approaches)
        %         appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %         %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %         disp("Feeder 1-4 Totals")
        %         disp(feeder1Totals)
        %         disp(feeder2Totals)
        %         disp(feeder3Totals)
        %         disp(feeder4Totals)
        %
        %         disp("Feeder 1:4 Appearences")
        %         disp(feeder1Appearences)
        %         disp(feeder2Appearences)
        %         disp(feeder3Appearences)
        %         disp(feeder4Appearences)

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1Average = feeder1Totals / feeder1Appearences;
        feeder2Average = feeder2Totals / feeder2Appearences;
        feeder3Average =feeder3Totals / feeder3Appearences;
        feeder4Average =feeder4Totals / feeder4Appearences;



        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        feeder1Percentage = str2double(regexprep(string(result3{1,2}),'%','')) / 100;
        feeder2Percentage = str2double(regexprep(string(result3{1,3}),'%',''))/100;
        feeder3Percentage = str2double(regexprep(string(result3{1,4}),'%',''))/100;
        feeder4Percentage = str2double(regexprep(string(result3{1,5}),'%',''))/100;

        ycoordinates = [feeder1Average, feeder2Average, feeder3Average, feeder4Average ];
        xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];


        %         display(xcoordinates)
        %         display(ycoordinates)
    end

    function [xcoordinates,ycoordinates] = createEntryTimePsychometricFunction(searchResults)
         local = searchResults;
        local2 = [str2double(local.entrytime)];
        if sum(isnan(local2)) > 0
            %display(local)
            %             display(isnan(table2array(local)))
            %             disp("NAN DETECTED")
            return
        end
        numberOfTotalRows = height(local);
        i = 1;
        %keeps track of how many times the rat approaches the
        %designated feeders
        feeder1Totals = 0.00;
        feeder2Totals = 0.00;
        feeder3Totals = 0.00;
        feeder4Totals = 0.00;

        %keeps track of how many times each feeder appears in tests
        feeder1Appearences = 0;
        feeder2Appearences = 0;
        feeder3Appearences = 0;
        feeder4Appearences = 0;

        while i <= numberOfTotalRows
            result3 = fetch(conn,strcat("SELECT feeder,rewardconcentration1,rewardconcentration2,rewardconcentration3,rewardconcentration4 FROM live_table WHERE id = ",string(local{i,1}),";"));
            %disp(i)
            feederValue = string(result3{1,1});
            %display(result3)
            %display(local)
            %if the feeder value appears and it approaches then the
            %feeder1/2/3/4 approaches variable is incremented

            switch feederValue
                %FIX THIS RIGHT HERE ADD THE TRAVEL PIXEL OR OTEHER
                %FEATURE VALUES
                case '1'
                    feeder1Totals = feeder1Totals + str2double(string(local{i,4}));
                case '2'
                    feeder2Totals = feeder2Totals +str2double(string(local{i,4}));
                case '3'
                    feeder3Totals = feeder3Totals+str2double(string(local{i,4}));
                case '4'
                    feeder4Totals = feeder4Totals+str2double(string(local{i,4}));
            end

            %if the feederValue appears the feeder1/2/3/4 Appearences
            %variables are incremented
            switch feederValue
                case '1'
                    feeder1Appearences = feeder1Appearences + 1;
                case '2'
                    feeder2Appearences = feeder2Appearences + 1;
                case '3'
                    feeder3Appearences = feeder3Appearences + 1;
                case '4'
                    feeder4Appearences = feeder4Appearences + 1;
            end
            i = i+1;
        end

        %         approaches = [feeder1Approaches,feeder2Approaches,feeder3Approaches,feeder4Approaches];
        %         %display(approaches)
        %         appearences = [feeder1Appearences, feeder2Appearences,feeder3Appearences,feeder4Appearences];
        %         %display(appearences)

        if feeder1Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 1 had no appearences");
            throw(ME)
        end
        if feeder2Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 2 had no appearences");
            throw(ME)
        end
        if feeder3Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 3 had no appearences");
            throw(ME)
        end
        if feeder4Appearences == 0
            ME = MException("MATLAB:notEnoughInputs","Feeder 4 had no appearences");
            throw(ME)
        end

        %         disp("Feeder 1-4 Totals")
        %         disp(feeder1Totals)
        %         disp(feeder2Totals)
        %         disp(feeder3Totals)
        %         disp(feeder4Totals)
        %
        %         disp("Feeder 1:4 Appearences")
        %         disp(feeder1Appearences)
        %         disp(feeder2Appearences)
        %         disp(feeder3Appearences)
        %         disp(feeder4Appearences)

        %feeder[1,2,3,4]ApproachPercentage = number of times rat approached / number of times the feeder appeared
        feeder1Average = feeder1Totals / feeder1Appearences;
        feeder2Average = feeder2Totals / feeder2Appearences;
        feeder3Average =feeder3Totals / feeder3Appearences;
        feeder4Average =feeder4Totals / feeder4Appearences;



        %feeder[1,2,3,4]Percentage is the percent concentration stored in the table included in any
        feeder1Percentage = str2double(regexprep(string(result3{1,2}),'%','')) / 100;
        feeder2Percentage = str2double(regexprep(string(result3{1,3}),'%',''))/100;
        feeder3Percentage = str2double(regexprep(string(result3{1,4}),'%',''))/100;
        feeder4Percentage = str2double(regexprep(string(result3{1,5}),'%',''))/100;

        ycoordinates = [feeder1Average, feeder2Average, feeder3Average, feeder4Average ];
        xcoordinates = [feeder1Percentage, feeder2Percentage, feeder3Percentage, feeder4Percentage];

    end
    function rewardChoiceLoop(subject_ids,dates,conn,experiment)
        counter =1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <=size(subject_ids,1)
            disp(strcat("Reward Choice: ",string(counter),"/",string(size(subject_ids,1))))
            try
                try

                    query = strcat("SELECT subjectid, referencetime, feeder, approachavoid,rewardconcentration1,rewardconcentration2," + ...
                        "rewardconcentration3,rewardconcentration4 FROM live_table" + ...
                        " WHERE referencetime LIKE '",dates(counter),"%' AND subjectid = '", subject_ids(counter),"';");

                    %         disp(query);


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
                    [xcoordinates,ycoordinates] = createRewardChoicePsychometricFunction(searchResults2);
                    %         display(class(xcoordinates))
                    %         display(class(ycoordinates))
                    data = table(subject_ids(counter),dates(counter),...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                        'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                    psychometric_function_table = [psychometric_function_table;data];
                    %uploads the psychomatical function to the "psychomaticalFunctions"
                    %table in the database
                    %                         sqlwrite(conn,"newBaseLineRewardChoicePsychometricFunctions",data)
                    %                     secondaryCounter = secondaryCounter +1;


                catch e
                    disp("Error occured for the following query")
                    disp(query)
                    fprintf(1,'The identifier was:\n%s',e.identifier);
                    fprintf(1,'The message was:\n%s',e.message)
                    disp("_________________________________________________")
                    counter = counter+1;
                    %                     secondaryCounter = secondaryCounter+1;
                    %                     somethingWrongCounter = somethingWrongCounter+1;
                end
                %                 end
                %disp(animalsOnThatDate)



                counter = counter+1;
            catch e
                % disp("Error occured for the following query")
                % disp(query)
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'The message was:\n%s',e.message)
                disp("_________________________________________________")
                counter = counter+1;
                %                 somethingWrongCounter = somethingWrongCounter+1;
            end


        end
        writetable(psychometric_function_table,strcat(experiment," reward_choice psychometric functions table.xlsx"));
    end
    function reactionTimeLoop(subject_ids,dates,conn,experiment)
        counter = 1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <= size(subject_ids,1)
            disp(strcat("Reaction Time: ",string(counter),"/",string(size(subject_ids,1))))
            %     try
            %             animalsOnThatDate = (split(string(T{counter,2}),","));
            %             animalsOnThatDate = animalsOnThatDate.';
            %             secondaryCounter = 1;
            %             disp(animalsOnThatDate)
            %             while secondaryCounter <= width(animalsOnThatDate)
            try
                %                 if strcmp(string(animalsOnThatDate{secondaryCounter}), "")
                %                     secondaryCounter = secondaryCounter+1;
                %                     continue
                %                 end
                theDate = strrep(dates(counter),'/',"-");
                theDate = char(theDate);
                theDate = strsplit(theDate,"-");
                %                 %display(theDate)
                theFormattedDate = formatTheDate(theDate);

                %                 theFormattedDate = dates(counter);


                %                     display(theformattedDate)
                query = strcat("SELECT id,referencetime,subjectid,reactiontime1st FROM featuretable2 WHERE " + ...
                    "referencetime LIKE '",theFormattedDate,"%'","" + ...
                    " AND subjectid = '",subject_ids(counter),"';");

                query = strcat("SELECT id,referencetime,subjectid,reactiontime1st " + ...
                    "FROM featuretable2 a" + ...
                    "WHERE EXISTS(SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");

                %                 disp(animalsOnThatDate{secondaryCounter});

                searchResults = fetch(conn,query);
                %display(searchResults)
                searchResults2 = rmmissing(searchResults, 'DataVariables',"reactiontime1st");
                %display(searchResults)
                if height(searchResults) == 0
                    %                     display(searchResults)
                    %                     disp("The following query resulted in NaNs")
                    %                     disp(query)
                    counter = counter+1;
                    %                     secondaryCounter=secondaryCounter+1;
                    continue
                end
                %creates the psychomatical function
                [ycoordinates] = createReactionTimePsychometricFunction(searchResults2);
                %         display(class(xcoordinates))
                %         display(class(ycoordinates))
                data = table(subject_ids(counter),dates(counter),...
                    0.09,0.05,0.02,0.005,...
                    ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                    'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                psychometric_function_table = [psychometric_function_table;data];

                %uploads the psychomatical function to the "psychomaticalFunctions"
                %table in the database
                %                     sqlwrite(conn,"newBaseLineReactionTimePsychometricFunctions",data)
                %                 disp("the following query was written to the travelpixeltable")
                %                 disp(query)
                %                 secondaryCounter = secondaryCounter +1;
            catch ME
                disp("Error occured for the following query")
                %disp(query)
                disp(ME.identifier)
                disp(ME.message)
                disp("--------------------------------")
                counter = counter+1;
                %                 secondaryCounter = secondaryCounter+1;
            end
            %             end
            % disp(animalsOnThatDate)



            counter = counter+1;
            %     catch ME
            %         disp("Error occured for the following query")
            %         disp(query)
            %         disp(ME.identifier)
            %         disp(ME.message)
            %         disp("--------------------------------")
            %         counter = counter+1;
            %     end



        end
        writetable(psychometric_function_table,strcat(experiment," reaction_time psychometric functions table.xlsx"));
    end
    function rotationPointsLoop(subject_ids,dates,conn,experiment,method)
        counter = 1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <= size(subject_ids,1)
            disp(strcat("Rotation Points Method ",string(method),": ",string(counter),"/",string(size(subject_ids,1))))
            try
                if method==4
                    query = strcat("SELECT id,referencetime,subjectid,rotationptsmethod4 " + ...
                        "FROM featuretable2 a " + ...
                        "WHERE EXISTS (SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");
                elseif method==1
                    query = strcat("SELECT id,referencetime,subjectid,rotationptsmethod1 " + ...
                        "FROM featuretable2 a " + ...
                        "WHERE EXISTS (SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");
                end

                searchResults = fetch(conn,query);
                % disp(query);
                % disp(searchResults);
                %                     display(searchResults)
                if method==4
                    searchResults2 = rmmissing(searchResults, 'DataVariables',"rotationptsmethod4");
                elseif method==1
                    searchResults2 = rmmissing(searchResults, 'DataVariables',"rotationptsmethod1");
                end

                %display(searchResults)
                if height(searchResults) == 0
                    disp("searchResults were empty")
                    disp(query)
                    counter = counter+1;
                    continue
                end
                %creates the psychomatical function
                [ycoordinates] = createRotationPointsPsychometricFunction(searchResults2,method);
                %         display(class(xcoordinates))
                %         display(class(ycoordinates))
                data = table(subject_ids(counter),dates(counter),...
                    0.09,0.05,0.02,0.005,...
                    ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                    'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                disp(data);
                psychometric_function_table = [psychometric_function_table;data];
            catch ME
                disp("Error occured for the following query")
                disp(query)
                disp(ME.identifier)
                disp(ME.message)
                disp("--------------------------------")
                counter = counter+1;
            end
            counter = counter+1;
        end
        writetable(psychometric_function_table,strcat(experiment," rotation_points_method_",string(method)," psychometric functions table.xlsx"));
    end
    function stoppingPointsLoop(subject_ids,dates,conn,experiment)
        counter = 1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <= size(subject_ids,1)
            disp(strcat("Stopping Points: ",string(counter),"/",string(size(subject_ids,1))))
            try
                try
                    % query = strcat("SELECT id,referencetime,subjectid,stoppingpts_per_unittravel_method6 FROM featuretable2 WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"';");
                    query = strcat("SELECT id,referencetime,subjectid,stoppingpts_per_unittravel_method6 " + ...
                        "FROM featuretable2 a " + ...
                        "WHERE EXISTS(SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");
                    %                     disp(query);

                    searchResults = fetch(conn,query);
                    %                 display(searchResults)
                    searchResults2 = rmmissing(searchResults, 'DataVariables',"stoppingpts_per_unittravel_method6");
                    %display(searchResults)
                    if height(searchResults) == 0
                        counter = counter+1;
                        continue
                    end
                    %creates the psychomatical function
                    [xcoordinates,ycoordinates] = createStoppingPointsPsychometricFunction(searchResults2);
                    %         display(class(xcoordinates))
                    %         display(class(ycoordinates))
                    data = table(subject_ids(counter),dates(counter),...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                        'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);

                    psychometric_function_table = [psychometric_function_table;data];

                catch
                    disp("Error occured for the following query")
                    disp(query)
                    counter = counter+1;
                end
                counter = counter+1;
            catch
                disp("Error occured for the following query")
                disp(query)
                counter = counter+1;
            end
        end
        writetable(psychometric_function_table,strcat(experiment," stopping_points psychometric functions table.xlsx"));
    end
    function travelPixelLoop(subject_ids,dates,conn,experiment)
        counter = 1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <= size(subject_ids,1)
            disp(strcat("Travel Pixel: ",string(counter),"/",string(size(subject_ids,1))))
            try
                %                 while secondaryCounter <= width(animalsOnThatDate)
                try

                    %display(theformattedDate)
                    % query = strcat("SELECT id,referencetime,subjectid,distanceaftertoneuntillimitingtimestamp FROM featuretable2 " + ...
                    %     "WHERE referencetime " + ...
                    %     "LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"';");
                    query = strcat("SELECT id,referencetime,subjectid,distanceaftertoneuntillimitingtimestamp " + ...
                        "FROM featuretable2 a " + ...
                        "WHERE EXISTS(SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");
                    %disp(query);

                    searchResults = fetch(conn,query);
                    %                 display(searchResults)
                    searchResults2 = rmmissing(searchResults, 'DataVariables',"distanceaftertoneuntillimitingtimestamp");
                    %display(searchResults)
                    if height(searchResults) == 0
                        counter = counter+1;
                        continue;
                    end
                    %creates the psychomatical function
                    [xcoordinates,ycoordinates] = createTravelPixelPsychometricFunction(searchResults2);
                    %         display(class(xcoordinates))
                    %         display(class(ycoordinates))
                    data = table(subject_ids(counter),dates(counter),...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                        'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                    psychometric_function_table = [psychometric_function_table;data];
                    %uploads the psychomatical function to the "psychomaticalFunctions"
                    %table in the database
                catch
                    disp("Error occured for the following query")
                    disp(query)
                    counter = counter+1;
                end
                counter = counter+1;
            catch
                disp("Error occured for the following query")
                disp(query)
                counter = counter+1;
            end



        end
        writetable(psychometric_function_table,strcat(experiment," distance_traveled psychometric functions table.xlsx"));
    end

    function entrytimeLoop(subject_ids,dates,conn,experiment)
        counter = 1;
        psychometric_function_table = table([],[],[],[],[],[],[],[],[],[],'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
        while counter <= size(subject_ids,1)
            disp(strcat("Entry Time: ",string(counter),"/",string(size(subject_ids,1))))
            try
                %                 while secondaryCounter <= width(animalsOnThatDate)
                try

                    %display(theformattedDate)
                    % query = strcat("SELECT id,referencetime,subjectid,distanceaftertoneuntillimitingtimestamp FROM featuretable2 " + ...
                    %     "WHERE referencetime " + ...
                    %     "LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"';");
                    query = strcat("SELECT id,referencetime,subjectid,entrytime " + ...
                        "FROM featuretable2 a " + ...
                        "WHERE EXISTS(SELECT id FROM live_table b WHERE referencetime LIKE '",dates(counter),"%'"," AND subjectid = '", subject_ids(counter),"' AND a.id=b.id) ORDER BY a.id;");
                    %disp(query);

                    searchResults = fetch(conn,query);
                    %                 display(searchResults)
                    searchResults2 = rmmissing(searchResults, 'DataVariables',"entrytime");
                    %display(searchResults)
                    if height(searchResults) == 0
                        counter = counter+1;
                        continue;
                    end
                    %creates the psychomatical function
                    [xcoordinates,ycoordinates] = createEntryTimePsychometricFunction(searchResults2);
                    %         display(class(xcoordinates))
                    %         display(class(ycoordinates))
                    data = table(subject_ids(counter),dates(counter),...
                        xcoordinates(1),xcoordinates(2),xcoordinates(3),xcoordinates(4),...
                        ycoordinates(1),ycoordinates(2),ycoordinates(3),ycoordinates(4),...
                        'VariableNames', ["subjectid","date","x1","x2","x3","x4","y1","y2","y3","y4"]);
                    psychometric_function_table = [psychometric_function_table;data];
                    %uploads the psychomatical function to the "psychomaticalFunctions"
                    %table in the database
                catch
                    disp("Error occured for the following query")
                    disp(query)
                    counter = counter+1;
                end
                counter = counter+1;
            catch
                disp("Error occured for the following query")
                disp(query)
                counter = counter+1;
            end



        end
        writetable(psychometric_function_table,strcat(experiment," entry_time psychometric functions table.xlsx"));
    end

    
datasource = 'live_database'; %ENTER YOUR DATASOURCE NAME HERE, default should be "live_database"
username = 'postgres'; %ENTER YOUR USERNAME HERE, default should be "postgres"
password = '1234'; %ENTER YOUR PASSWORD HERE, default should be "1234"


conn = database(datasource,username,password); %creates the database connection
rewardChoiceLoop(subject_ids,dates,conn,experiment)
close(conn)

conn = database(datasource,username,password); %creates the database connection
reactionTimeLoop(subject_ids,dates,conn,experiment)
close(conn)

disp("Rotation Points Method 1")
conn = database(datasource,username,password); %creates the database connection
rotationPointsLoop(subject_ids,dates,conn,experiment,1)
close(conn)

disp("Rotation Points Method 4")
conn = database(datasource,username,password); %creates the database connection
rotationPointsLoop(subject_ids,dates,conn,experiment,4)
close(conn)



disp("Stopping Points")
conn = database(datasource,username,password); %creates the database connection
stoppingPointsLoop(subject_ids,dates,conn,experiment)
close(conn)

disp("Entry time")
conn = database(datasource,username,password);
entrytimeLoop(subject_ids,dates,conn,experiment)
close(conn)

disp("Travel Pixel")
conn = database(datasource,username,password); %creates the database connection
travelPixelLoop(subject_ids,dates,conn,experiment)
close(conn)


end