%% This code produces Figures 1 and 2 and Tables 2 and 3

clc
clear
close all

figures_path = '.\Figures\';
tables_path = '.\Tables\';

% Load data
model_inputs = readtable('DataInputs.csv');


%% Create Figures 1 and 2
% Plot PE and GE elasticities (GHH and MaC preferences) for Switzerland and Iceland
% Using tax holiday years (1995-2005 for Switzerland and 2000-2010 for Iceland)

% Use the averages reported in Table 1
dataset = table2array(model_inputs(:,2:5));

% Values of gamma (for MaC)
gamma = [0.5 1 2.5]'; %do log consumption (gamma = 1) and 0.5 and 2.5 for CI-bands

% Set grid for Frisch elasticity phi
phi_grid = 0:0.01:4;

% Figure 1 (GHH preferences)
for i=[find(contains(model_inputs.country,'Iceland')) find(contains(model_inputs.country,'Switzerland'))]
    
    % Compute elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).*phi;
    elast_loglin_ge = @(phi) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+dataset(i,2)));
    
    % Plot PE tax holiday elasticities
    figure;
    plot(phi_grid,elast_loglin_pe(phi_grid),'-','Color','k','LineWidth',3);
    grid on
    xlabel('Frisch Elasticity ($\phi$)','Interpreter','Latex','Fontsize',16);
    ylabel('Measured Elasticity ($\xi$)','Interpreter','Latex','Fontsize',16);
    xlim([min(phi_grid) max(phi_grid)])
    ylim([0 0.5])
    
    % Save plots
    if string(model_inputs{i,1}) == 'Iceland'
        saveas(gcf,[figures_path 'Figure_1b_GHH_PE_' char(model_inputs{i,1}) '.eps'],'epsc');
    elseif string(model_inputs{i,1}) == 'Switzerland'
        saveas(gcf,[figures_path 'Figure_1d_GHH_PE_' char(model_inputs{i,1}) '.eps'],'epsc');
    end
    
    % Plot GE tax holiday elasticities
    figure;
    plot(phi_grid,elast_loglin_ge(phi_grid),'-','Color','k','LineWidth',3);
    grid on
    xlabel('Frisch Elasticity ($\phi$)','Interpreter','Latex','Fontsize',16);
    ylabel('Measured Elasticity ($\xi$)','Interpreter','Latex','Fontsize',16);
    xlim([min(phi_grid) max(phi_grid)])
    ylim([0 0.5])
    
    % Save plots
    if string(model_inputs{i,1}) == 'Iceland'
        saveas(gcf,[figures_path 'Figure_1a_GHH_GE_' char(model_inputs{i,1}) '.eps'],'epsc');
    elseif string(model_inputs{i,1}) == 'Switzerland'
        saveas(gcf,[figures_path 'Figure_1c_GHH_GE_' char(model_inputs{i,1}) '.eps'],'epsc');
    end
    
end

% Figure 2 (MaC preferences)
for i=[find(contains(model_inputs.country,'Iceland')) find(contains(model_inputs.country,'Switzerland'))]
    
    % Compute elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi,gamma) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))));
    elast_loglin_ge = @(phi,gamma) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))+dataset(i,2)));
    
    % Plot PE tax holiday elasticities
    figure;
    fill([phi_grid fliplr(phi_grid)], [elast_loglin_pe(phi_grid,0.5) fliplr(elast_loglin_pe(phi_grid,2.5))],[.9 .9 .9], 'linestyle', 'none');
    hold on
    plot(phi_grid,elast_loglin_pe(phi_grid,1),'-','Color','k','LineWidth',3);
    grid on
    xlabel('Frisch Elasticity ($\phi$)','Interpreter','Latex','Fontsize',16);
    ylabel('Measured Elasticity ($\xi$)','Interpreter','Latex','Fontsize',16);
    xlim([min(phi_grid) max(phi_grid)])
    ylim([0 0.5])
    
    % Save plots
    if string(model_inputs{i,1}) == 'Iceland'
        saveas(gcf,[figures_path 'Figure_2b_MaC_PE_' char(model_inputs{i,1}) '.eps'],'epsc');
    elseif string(model_inputs{i,1}) == 'Switzerland'
        saveas(gcf,[figures_path 'Figure_2d_MaC_PE_' char(model_inputs{i,1}) '.eps'],'epsc');
    end
    
    % Plot GE tax holiday elasticities
    figure;
    fill([phi_grid fliplr(phi_grid)], [elast_loglin_ge(phi_grid,0.5) fliplr(elast_loglin_ge(phi_grid,2.5))],[.9 .9 .9], 'linestyle', 'none');
    hold on
    plot(phi_grid,elast_loglin_ge(phi_grid,1),'-','Color','k','LineWidth',3);
    grid on
    xlabel('Frisch Elasticity ($\phi$)','Interpreter','Latex','Fontsize',16);
    ylabel('Measured Elasticity ($\xi$)','Interpreter','Latex','Fontsize',16);
    xlim([min(phi_grid) max(phi_grid)])
    ylim([0 0.5])
    
    % Save plots
    if string(model_inputs{i,1}) == 'Iceland'
        saveas(gcf,[figures_path 'Figure_2a_MaC_GE_' char(model_inputs{i,1}) '.eps'],'epsc');
    elseif string(model_inputs{i,1}) == 'Switzerland'
        saveas(gcf,[figures_path 'Figure_2c_MaC_GE_' char(model_inputs{i,1}) '.eps'],'epsc');
    end
    
end


%% Create Table 2
% Compute ranges of plausible measured tax elasticities given Frisch = 1 and 3, using 2000-2015 data for all 9 countries

% Use the averages reported in Table 4
dataset = table2array(model_inputs(:,6:9));

% GHH preferences
for i=1:size(dataset,1)
    
    % Compute tax elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).*phi;
    elast_loglin_ge = @(phi) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+dataset(i,2)));
    
    % Fill cell array with lower and upper bounds (Frisch between 1 and 3)
    elasticities{i,1} = model_inputs{i,1};
    elasticities{i,2} = elast_loglin_pe(1);
    elasticities{i,3} = elast_loglin_pe(3);
    elasticities{i,4} = elast_loglin_ge(1);
    elasticities{i,5} = elast_loglin_ge(3);
    
end

% MaC preferences
for i=1:size(dataset,1)
    
    % Compute tax elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi,gamma) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))));
    elast_loglin_ge = @(phi,gamma) (dataset(i,4)/(1-dataset(i,4)-dataset(i,3))).* ...
        (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))+dataset(i,2)));
    
    % Fill cell array with lower and upper bounds (Frisch between 1 and 3 and gamma between 0.5 and 2.5)
    elasticities{i,6} = elast_loglin_pe(1,2.5);
    elasticities{i,7} = elast_loglin_pe(3,0.5);
    elasticities{i,8} = elast_loglin_ge(1,2.5);
    elasticities{i,9} = elast_loglin_ge(3,0.5);
    
end

% Export Latex table
latex_elasticity_bounds(elasticities,tables_path,2);


%% Create Table 3
% Compute ranges of plausible measured TFP elasticities given Frisch = 1 and 3, using 2000-2015 data for all 9 countries

% GHH preferences
for i=1:size(dataset,1)
    
    % Compute TFP elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi) phi;
    elast_loglin_ge = @(phi) (1./((1./phi)+dataset(i,2)));
    
    % Fill cell array with lower and upper bounds (Frisch between 1 and 3)
    elasticities{i,1} = model_inputs{i,1};
    elasticities{i,2} = elast_loglin_pe(1);
    elasticities{i,3} = elast_loglin_pe(3);
    elasticities{i,4} = elast_loglin_ge(1);
    elasticities{i,5} = elast_loglin_ge(3);
    
end

% MaC preferences
for i=1:size(dataset,1)
    
    % Compute TFP elasticities for each Frisch on grid, using data
    elast_loglin_pe = @(phi,gamma) (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))))* ...
        (1-gamma*(1/dataset(i,1)));
    elast_loglin_ge = @(phi,gamma) (1./((1./phi)+gamma*(1-dataset(i,2))*(1/dataset(i,1))+dataset(i,2)))* ...
        (1-gamma*(1/dataset(i,1)));
    
    % Fill cell array with lower and upper bounds (Frisch between 1 and 3 and gamma between 0.5 and 2.5)
    elasticities{i,6} = elast_loglin_pe(1,2.5);
    elasticities{i,7} = elast_loglin_pe(3,0.5);
    elasticities{i,8} = elast_loglin_ge(1,2.5);
    elasticities{i,9} = elast_loglin_ge(3,0.5);
    
end

% Export Latex table
latex_elasticity_bounds(elasticities,tables_path,3);

