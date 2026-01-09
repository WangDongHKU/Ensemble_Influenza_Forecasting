function plotarrow(start_x_data,end_x_data,start_y_data,end_y_data)

ax = gca;
% [start_x_data,end_x_data,start_y_data,end_y_data]=deal(525.4,526.4, 95,95)
start_x_norm = (start_x_data - ax.XLim(1)) / (ax.XLim(2) - ax.XLim(1)) * ax.Position(3) + ax.Position(1);
start_y_norm = (start_y_data - ax.YLim(1)) / (ax.YLim(2) - ax.YLim(1)) * ax.Position(4) + ax.Position(2);
end_x_norm = (end_x_data - ax.XLim(1)) / (ax.XLim(2) - ax.XLim(1)) * ax.Position(3) + ax.Position(1);
end_y_norm = (end_y_data - ax.YLim(1)) / (ax.YLim(2) - ax.YLim(1)) * ax.Position(4) + ax.Position(2);
annotation ('textarrow',[start_x_norm, end_x_norm],[start_y_norm, end_y_norm],'LineStyle',':','LineWidth',1)
