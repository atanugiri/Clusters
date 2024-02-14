function sigmoid_analysis(table_of_psychometric_functions,feature)
    function[] = createSigmoidFigures(results,feature)
        for i = 1:height(results)
            
            %             x = results{i,[3,4,5,6]};
            %             disp(x)
            x = [0.09,0.05,0.02,0.005];
            %             disp(x)
            y = results{i,[6,7,8,9]};
            %             a /(1 + exp(-b.*(x-c)))
            % min+(max-min)./(1+10.^((x50-x)*slope))
            %try nlin fit
            %try regular fit


            %Keep slope and shift no matter what because those are what's getting
            %clsutered
            %1560 psychomatical functions in the table
            %66 of them have all 0s

            figure
            [fitobject1, gof1]= fit(x.',y.','a*x+b');
            figure1 = plot(fitobject1,x.',y.');
            ylabel("Choice")
            xlabel("Reward")
            title(strcat("Line: ",strrep(string(results{i,1}),"/","-")," ", strrep(string(results{i,2}),"/","-")))
            fighandle1 = gcf;


            figure
            [fitobject2, gof2] = fit(x.', y.', '1 / (1 + (b*exp(-c * x)))');
            figure2 = plot(fitobject2, x.', y.');
            ylabel("Choice")
            xlabel("Reward")
            title(strcat("2 Param Sigmoid: ",strrep(string(results{i,1}),"/","-"), " ", strrep(string(results{i,2}),"/", "-")))
            fighandle2 = gcf;

            figure
            [fitobject3, gof3] = fit(x.',y.','(a/(1+b*exp(-c*(x))))');
            %           display(fitobject)
            figure3 = plot(fitobject3,x.',y.');
            ylabel("Choice")
            xlabel("Reward")
            title(strcat("3 Param. Sigmoid: ", strrep(string(results{i,1}),"/","-")," ", strrep(string(results{i,2}),"/","-")))
            fighandle3 = gcf;

            figure
            [fitobject4, gof4] = fit(x.', y.', '(a/(1+(b*(exp(-c*(x-d))))))');
            figure4 = plot(fitobject4, x.', y.');
            ylabel("Choice")
            xlabel("Reward")
            title(strcat("4 Param Sigmoid: ",strrep(string(results{i,1}),"/","-"), " ", strrep(string(results{i,2}),"/", "-")))
            fighandle4 = gcf;


            figure
            [fitobject5, gof5] = fit(x.',y.','a*(x-b)^(2)+c');
            figure5 =plot(fitobject5,x.',y.');
            ylabel("Choice")
            xlabel("Reward")
            title(strcat("Parabola: ", strrep(string(results{i,1}),"/","-")," ", strrep(string(results{i,2}),"/","-")))
            fighandle5 = gcf;





            %             display(gof1.rsquare)
            %             display(gof2.rsquare)
            %             display(gof3.rsquare)
            currentFolder = pwd;

            dynamicName = strcat(currentFolder,"\");

            if strcmp(feature,'tp')
                if gof3.rsquare >= .4
                    saveas(fighandle3,strcat(dynamicName,"Travel Pixel 3 Parameter Sigmoid\",strrep(strrep(string(results{i,1}),"/","-"),"/","-"),".fig"))
                    save(strcat(dynamicName,'Travel Pixel Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
                elseif gof4.rsquare >= .4
                    saveas(fighandle4,strcat(dynamicName,"Travel Pixel 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Travel Pixel Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
                elseif gof2.rsquare >= .4
                    saveas(fighandle2,strcat(dynamicName,"Travel Pixel 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Travel Pixel Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare

                    saveas(fighandle1,strcat(dynamicName,"Travel Pixel Lines\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Travel Pixel Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dynamicName,"Travel Pixel Parabolas\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Travel Pixel Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
                end


                close all
            end
            if strcmp(feature,'sp')
                if gof3.rsquare >= .4
                    saveas(fighandle3,strcat(dynamicName,"Stopping Points 3 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Stopping Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
                elseif gof4.rsquare >= .4
                    saveas(fighandle4,strcat(dynamicName,"Stopping Points 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Stopping Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
                elseif gof2.rsquare >= .4
                    saveas(fighandle2,strcat(dynamicName,"Stopping Points 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Stopping Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare
                    saveas(fighandle1,strcat(dynamicName,"Stopping Points Lines\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Stopping Points Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dynamicName,"Stopping Points Parabolas\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Stopping Points Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
                end

                close all
            end
            if strcmp(feature,'rp')
                if gof3.rsquare >= .4
                    saveas(fighandle3,strcat(dynamicName,"Rotation Points 3 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Rotation Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
                elseif gof4.rsquare >= .4
                    saveas(fighandle4,strcat(dynamicName,"Rotation Points 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Rotation Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
                elseif gof2.rsquare >= .4
                    saveas(fighandle2,strcat(dynamicName,"Rotation Points 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Rotation Points Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare
                    saveas(fighandle1,strcat(dynamicName,"Rotation Points Line\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Rotation Points Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dynamicName,"Rotation Points Parabola\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Rotation Points Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
                end
                close all
            end
            if strcmp(feature,'rt')
                if gof3.rsquare >= .4
                    saveas(fighandle3,strcat(dynamicName,"Reaction Time 3 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reaction Time Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
                elseif gof4.rsquare >= .4
                    saveas(fighandle4,strcat(dynamicName,"Reaction Time 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reaction Time Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
                elseif gof2.rsquare >= .4
                    saveas(fighandle2,strcat(dynamicName,"Reaction Time 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reaction Time Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare
                    saveas(fighandle1,strcat(dynamicName,"Reaction Time Lines\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reaction Time Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dynamicName,"Reaction Time Parabolas\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reaction Time Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
                end
                if gof3.rsquare < 0
                    display(strcat("Iteration: ", string(i), " Could not be sorted"))
                    %                 display(gof1.rsquare)
                end

                close all

            end
            if strcmp(feature,'rc')
                if gof3.rsquare >= .6
                    saveas(fighandle3,strcat(dynamicName,"Reward Choice 3 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reward Choice Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject3')
                elseif gof4.rsquare >= .6
                    saveas(fighandle4,strcat(dynamicName,"Reward Choice 4 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reward Choice Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject4')
                elseif gof2.rsquare >= .6
                    saveas(fighandle2,strcat(dynamicName,"Reward Choice 2 Parameter Sigmoid\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reward Choice Sigmoid Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject2')
                elseif gof1.rsquare > gof5.rsquare
                    saveas(fighandle1,strcat(dynamicName,"Reward Choice Lines\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reward Choice Line Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject1')
                elseif gof5.rsquare > gof1.rsquare
                    saveas(fighandle5,strcat(dynamicName,"Reward Choice Parabolas\",strrep(string(results{i,1}),"/","-"),".fig"))
                    save(strcat(dynamicName,'Reward Choice Parabola Data\',strrep(string(results{i,1}),"/","-"),'.mat'),'fitobject5')
                end
                if gof3.rsquare < 0
                    display(strcat("Iteration: ", string(i), " Could not be sorted"))
                    %                 display(gof1.rsquare)
                end

                close all
            end
        end
    end

    function [] = create_directories()
        mkdir("Travel Pixel 2 Parameter Sigmoid")
        mkdir("Travel Pixel 3 Parameter Sigmoid")
        mkdir("Travel Pixel 4 Parameter Sigmoid")
        mkdir("Travel Pixel Sigmoid Data")
        mkdir("Travel Pixel Lines")
        mkdir("Travel Pixel Line Data")
        mkdir("Travel Pixel Parabolas")
        mkdir("Travel Pixel Parabola Data")

        mkdir("Stopping Points 2 Parameter Sigmoid")
        mkdir("Stopping Points 3 Parameter Sigmoid")
        mkdir("Stopping Points 4 Parameter Sigmoid")
        mkdir("Stopping Points Sigmoid Data")
        mkdir("Stopping Points Lines")
        mkdir("Stopping Points Line Data")
        mkdir("Stopping Points Parabolas")
        mkdir("Stopping Points Parabola Data")



        mkdir("Reaction Time 2 Parameter Sigmoid")
        mkdir("Reaction Time 3 Parameter Sigmoid")
        mkdir("Reaction Time 4 Parameter Sigmoid")
        mkdir("Reaction Time Sigmoid Data")
        mkdir("Reaction Time Lines")
        mkdir("Reaction Time Line Data")
        mkdir("Reaction Time Parabolas")
        mkdir("Reaction Time Parabola Data")


        mkdir("Reward Choice 2 Parameter Sigmoid")
        mkdir("Reward Choice 3 Parameter Sigmoid")
        mkdir("Reward Choice 4 Parameter Sigmoid")
        mkdir("Reward Choice Sigmoid Data")
        mkdir("Reward Choice Lines")
        mkdir("Reward Choice Line Data")
        mkdir("Reward Choice Parabolas")
        mkdir("Reward Choice Parabola Data")


        mkdir("Rotation Points 2 Parameter Sigmoid")
        mkdir("Rotation Points 3 Parameter Sigmoid")
        mkdir("Rotation Points 4 Parameter Sigmoid")

        mkdir("Rotation Points Sigmoid Data")

        mkdir("Rotation Points Line")
        mkdir("Rotation Points Line Data")

        mkdir("Rotation Points Parabola")
        mkdir("Rotation Points Parabola Data")
    end

create_directories()

createSigmoidFigures(table_of_psychometric_functions,feature)

end