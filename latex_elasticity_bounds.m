function latex_elasticity_bounds(data,my_path,table_num)

if table_num == 2
    name = 'Table_2_tax_elasticity_bounds.tex';
elseif table_num == 3
    name = 'Table_3_tfp_elasticity_bounds.tex';
end

name = [my_path name];

countries = cell2table(data(:,1));
countries(find(contains(countries.Var1,'United_Kingdom')),1) = {'United Kingdom'};
countries(find(contains(countries.Var1,'United_States')),1) = {'United States'};

data_bounds = round(cell2mat(data(:,2:9)),2);

% Print LaTeX table
fid = fopen(name, 'w');
fprintf(fid, '\\begin{tabular}{lcccc} \n');
fprintf(fid, '& \\multicolumn{2}{c}{GHH preferences}   & \\multicolumn{2}{c}{MaC preferences}   \\tabularnewline \n');
fprintf(fid, '& PE                & GE                & PE                & GE                \\tabularnewline \n');
fprintf(fid, '\\hline \n');
fprintf(fid, '\\hline \n');

for i=1:size(countries,1)
    fprintf(fid, '%s & {[}%s, %s{]} & {[}%s, %s{]} & {[}%s, %s{]} & {[}%s, %s{]} \\tabularnewline \n', ...
        char(countries{i,1}),num2str(data_bounds(i,1),'%1.2f'), num2str(data_bounds(i,2),'%1.2f'), num2str(data_bounds(i,3),'%1.2f'), ... 
        num2str(data_bounds(i,4),'%1.2f'), num2str(data_bounds(i,5),'%1.2f'), num2str(data_bounds(i,6),'%1.2f'), ...
        num2str(data_bounds(i,7),'%1.2f'), num2str(data_bounds(i,8),'%1.2f'));
end

fprintf(fid, '\\hline \n');
fprintf(fid, '\\end{tabular} \n');
fclose(fid);

end