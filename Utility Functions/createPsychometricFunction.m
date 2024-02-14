function [xcoordinates,ycoordinates] = createPsychometricFunction(searchResults)
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