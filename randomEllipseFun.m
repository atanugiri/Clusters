function randomEllipseFun(data, plotColor)

% loadFile = load('data.mat');
% data = loadFile.data;
% plotColor = 'r';

% mean
x0 = mean(data(:,1));
y0 = mean(data(:,2));

% Std
a = std(data(:,1));
b = std(data(:,2));

t = -pi:0.01:pi;
x = x0 + a*cos(t);
y = y0 + b*sin(t);

plot(x,y,'-','Color',plotColor,'LineWidth',2);
hold on;
plot(x0, y0, '.', 'Color', plotColor, 'MarkerSize', 20);
end