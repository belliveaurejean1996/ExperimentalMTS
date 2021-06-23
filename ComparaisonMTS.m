% Ce code sert a comparer les valeurs expérimental de traction et flexion
% obtenue pour les matériaux composite DLF. La comparaison est effectuer
% sur des architectures DLF à fibre Tissée et fibre UD. La rigidité, la
% résistance ainsi que le comportement générale de ces type de composite
% serons analysé.

%% Initialisation
clear all %#ok<*CLALL>
close all
clc

% set les options pour les figure
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultAxesFontSize',14)

% Remet dans le bon directory
cd('E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison');

%% Specs des specimens
[~, ~, C] = xlsread('E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison\Specs.xlsx');
A = C(2:end,:);
Specs = cell2table(A,'VariableNames',{'ID' 'Thickness' 'Width' 'Length' 'Test'});

%% Collect de données

Data = {};

for i = 1:length(Specs.ID)
    
    % prend propriété du specimen
    SpecimenID = Specs.ID{i};
    TestType = Specs.Test{i};
    T = Specs.Thickness(i);
    W = Specs.Width(i);
    L = Specs.Length(i);
    ChipType = ChipTypeFun(SpecimenID);
    Concat = strcat(ChipType, TestType);
    
    % verifie quel type de test que nous avont
    tf = strcmp(TestType, 'Flexion');
    
    % define les calcules à faire
    if tf == 1
        [Stress, Displacement, Max_Strain(i), E, R, Load, Moment] = Flexion(SpecimenID ,T, W, L);
    else
        [Stress, Displacement, R, Load, Moment] = ResistanceTraction(SpecimenID, T, W);
        [E, AllModule(:,i)] = ModuleTraction(SpecimenID, T, W);
    end
    
    % retourn au repartoire original
    cd('E:\Universite\Matrise\Article - Comparison\ResultatsExperimental\Comparaison');
    
    % create a cell array avec toute le data necessaire pour l'analyse
    Data{i,1} = SpecimenID; %#ok<*SAGROW>
    Data{i,2} = ChipType;
    Data{i,3} = TestType;
    Data{i,4} = Concat;
    Data{i,5} = E;
    Data{i,6} = R;
    Data{i,7} = Load;
    Data{i,8} = Moment;
    Data{i,9} = Stress;
    Data{i,10} = Displacement;
end

% converte Cell to Table
C = Data(1:end,:);
Data = cell2table(C);
Data.Properties.VariableNames = {'ID', 'ChipType', 'Test', 'Concat', 'Module', 'Resistance', 'Load', 'Moment','Stress', 'displacement'};

% Devide based on fibre type and test type
[ArrID, numID] = findgroups(Data.Concat); 
CountsID = histcounts(ArrID);
Data.('ArrID') = ArrID;

for i = 1:length(Data.ID)
   str = Data.ID{i}(end);
   x = str2double(str);
   Position(i,1) = x;
end
Data.('Position') = Position;

for i = 1:length(numID)
    rows = (Data.ArrID==i);
    my_field = numID{i};
    props.(my_field) = Data(rows,:);
end

clearvars -except props Data AllModule

%% Courbe de traction

figure('Name','Courbe Traction')

% ---------------------- Chip DLF --------------------------
subplot(1,2,1)
hold on

for i = 1:length(props.UDTraction.Stress)
    Plot1 = plot(props.UDTraction.displacement{i},props.UDTraction.Stress{i},'r');
    Plot2 = plot(props.WovenTraction.displacement{i},props.WovenTraction.Stress{i},'b');
end

title('Courbe de traction')
xlabel('Displacement (mm)')
ylabel('Stress (MPa)')
legend1 = legend([Plot1, Plot2],{'UD chips','Woven Chips'}, 'Location','NorthWest');
xlim([0 inf])
ylim([0 inf])

hold off

% ---------------------- QI --------------------------

subplot(1,2,2)
hold on

for i = 1:length(props.UDQITraction.Stress)
    Plot1 = plot(props.UDQITraction.displacement{i},props.UDQITraction.Stress{i},'r');
end

title('Courbe de traction')
xlabel('Displacement (mm)')
ylabel('Stress (MPa)')
legend1 = legend([Plot1],{'QI Unidirectionnel'}, 'Location','NorthWest');
xlim([0 inf])
ylim([0 inf])

hold off

%% Courbe de flexion

figure('Name','Courbe Flexion')

% ------------------------ DLF fibres --------------------------------
subplot(1,2,1)
hold on

% Plot Woven Chips
for i = 1:length(props.WovenFlexion.Load)
    Plot1 = plot(props.WovenFlexion.displacement{i},props.WovenFlexion.Load{i},'b');
    Plot2 = plot(props.UDFlexion.displacement{i},props.UDFlexion.Load{i},'r');
end

title('Courbe de flexion : DLF')
xlabel('Displacement (mm)')
ylabel('Moment at mid-span (Nm)')
legend1 = legend([Plot1, Plot2],{'Woven Chips','UD chips'}, 'Location','NorthWest');
xlim([0 inf])
ylim([0 inf])

hold off

% ------------------------ Continuous fibres --------------------------------
subplot(1,2,2)
hold on

% Plot Woven Chips
for i = 1:length(props.CrossWFlexion.Load)
    Plot1 = plot(props.CrossWFlexion.displacement{i},props.CrossWFlexion.Load{i},'b');
    Plot2 = plot(props.CrossUD90Flexion.displacement{i},props.CrossUD90Flexion.Load{i},'r');
    Plot3 = plot(props.CrossUD0Flexion.displacement{i},props.CrossUD0Flexion.Load{i},'k');
end

title('Courbe de flexion : Continue')
xlabel('Displacement (mm)')
ylabel('Moment at mid-span (Nm)')
legend1 = legend([Plot1, Plot2, Plot3],{'Woven fibre','Cross ply [90,0]_1_1_s','Cross ply [0,90]_1_1_s'}, 'Location','NorthWest');
xlim([0 inf])
ylim([0 inf])

hold off

%% Bar chart Comparaison

% ------------------------- Résistance -----------------------------
figure('Name','Comparaison')
subplot(1,2,1)

% data to be plotted
Resistance_series = [mean(props.UDTraction.Resistance) mean(props.UDFlexion.Resistance);
                     mean(props.WovenTraction.Resistance) mean(props.WovenFlexion.Resistance)]; 
                 
Resistance_error = [std(props.UDTraction.Resistance) std(props.UDFlexion.Resistance);
                    std(props.WovenTraction.Resistance) std(props.WovenFlexion.Resistance)];
                
                
MaxStrength = [max(props.UDTraction.Resistance) max(props.UDFlexion.Resistance);
               max(props.WovenTraction.Resistance) max(props.WovenFlexion.Resistance)]; 


MinStrength = [min(props.UDTraction.Resistance) min(props.UDFlexion.Resistance);
               min(props.WovenTraction.Resistance) min(props.WovenFlexion.Resistance)];

% Bar chart
barWidth = 1;
b = bar(Resistance_series, 'grouped', 'BarWidth', barWidth);

% Xlabels
xticks([1 2])
xticklabels({'UD','Woven'})

hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(Resistance_series);

% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

% Plot the errorbars
errorbar(x',Resistance_series,Resistance_error,'k','linestyle','none','LineWidth',1);

% Plot Min and Max values
plot(x', MaxStrength,'sk','MarkerFaceColor','black');
plot(x', MinStrength,'sk','MarkerFaceColor','black');

% Labels
ylabel('Containtes (MPa)')
title('Résistance')

% plot legend
lg = legend('Traction','Flexion','AutoUpdate','off','FontSize',14);
lg.Location = 'BestOutside';
lg.Orientation = 'Horizontal';

hold off

% ------------------------ Module -----------------------------------
subplot(1,2,2)

% data to be plotted
Module_series = [mean(props.UDTraction.Module) mean(props.UDFlexion.Module);
                     mean(props.WovenTraction.Module) mean(props.WovenFlexion.Module)]; 
                 
Module_error = [std(props.UDTraction.Module) std(props.UDFlexion.Module);
                    std(props.WovenTraction.Module) std(props.WovenFlexion.Module)];
                
MaxModulus = [max(props.UDTraction.Module) max(props.UDFlexion.Module);
              max(props.WovenTraction.Module) max(props.WovenFlexion.Module)]; 


MinModulus = [min(props.UDTraction.Module) min(props.UDFlexion.Module);
              min(props.WovenTraction.Module) min(props.WovenFlexion.Module)];

% Bar chart
b = bar(Module_series, 'grouped', 'BarWidth', barWidth);

% Xlabels
xticks([1 2])
xticklabels({'UD','Woven'})

hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(Module_series);

% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end

% Plot the errorbars
errorbar(x',Module_series,Module_error,'k','linestyle','none','LineWidth',1);

% Plot Min and Max values
plot(x', MaxModulus,'sk','MarkerFaceColor','black');
plot(x', MinModulus,'sk','MarkerFaceColor','black');

% Plot QI reference
yline(mean(props.UDQITraction.Module),'-','QI référence (Traction)'...
    ,'LabelHorizontalAlignment','left'...
    ,'LineWidth',1.25...
    ,'FontSize',14)

% Labels
ylabel('Module (GPa)')
title('Rigidité')

% plot legend
lg = legend('Traction','Flexion','AutoUpdate','off','FontSize',14);
lg.Location = 'BestOutside';
lg.Orientation = 'Horizontal';

hold off

%% Bar chart Traction

% moment est baser sur la formule M = FL/8
figure('Name','Bar Traction')
subplot(1,2,1)
hold on

% Data to be plotted
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(props.UDTraction.Resistance), mean(props.WovenTraction.Resistance)];

errhigh = [std(props.UDTraction.Resistance), std(props.WovenTraction.Resistance)];
errlow  = [std(props.UDTraction.Resistance), std(props.WovenTraction.Resistance)];

MaxStrength = [max(props.UDTraction.Resistance), max(props.WovenTraction.Resistance)];
MinStrength = [min(props.UDTraction.Resistance), min(props.WovenTraction.Resistance)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxStrength,'sk','MarkerFaceColor','black');
p2 = plot(X, MinStrength,'sk','MarkerFaceColor','black');

% Labels
ylabel('Tensile Strenght (MPa)')


subplot(1,2,2)
hold on

% Data to be plotted
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(props.UDTraction.Module), mean(props.WovenTraction.Module)];

errhigh = [std(props.UDTraction.Module), std(props.WovenTraction.Module)];
errlow  = [std(props.UDTraction.Module), std(props.WovenTraction.Module)];

MaxStrength = [max(props.UDTraction.Module), max(props.WovenTraction.Module)];
MinStrength = [min(props.UDTraction.Module), min(props.WovenTraction.Module)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxStrength,'sk','MarkerFaceColor','black');
p2 = plot(X, MinStrength,'sk','MarkerFaceColor','black');

% Plot QI reference
yline(mean(props.UDQITraction.Module),'--','QI Ref.'...
    ,'LabelHorizontalAlignment','left'...
    ,'LineWidth',1.25...
    ,'FontSize',14)

% Labels
ylabel('Tensile Stiffness (GPa)')
hold off

%% Bar chart Flexion Continuous

% ------------------------- Moment maximal All ---------------------
% moment est baser sur la formule M = FL/8
figure('Name','Bar Flexion')
subplot(1,2,1)
hold on

% Data to be plotted
X = categorical({'UD [0,90]_1_1_s', 'UD [90,0]_1_1_s', 'Woven [0,90]_6_s'});
X = reordercats(X,{'UD [0,90]_1_1_s', 'UD [90,0]_1_1_s', 'Woven [0,90]_6_s'});
Y = [mean(props.CrossUD0Flexion.Moment), mean(props.CrossUD90Flexion.Moment), mean(props.CrossWFlexion.Moment)];

errhigh = [std(props.CrossUD0Flexion.Moment), std(props.CrossUD90Flexion.Moment), std(props.CrossWFlexion.Moment)];
errlow  = [std(props.CrossUD0Flexion.Moment), std(props.CrossUD90Flexion.Moment), std(props.CrossWFlexion.Moment)];

MaxStrength = [max(props.CrossUD0Flexion.Moment), max(props.CrossUD90Flexion.Moment), max(props.CrossWFlexion.Moment)];
MinStrength = [min(props.CrossUD0Flexion.Moment), min(props.CrossUD90Flexion.Moment), min(props.CrossWFlexion.Moment)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxStrength,'sk','MarkerFaceColor','black');
p2 = plot(X, MinStrength,'sk','MarkerFaceColor','black');

% Labels
ylabel('Moment at mid-span (Nm)')

hold off


% ------------------------- Module All ---------------------
subplot(1,2,2)
hold on

% Data to be plotted
X = categorical({'UD [0,90]_1_1_s', 'UD [90,0]_1_1_s', 'Woven [0,90]_6_s'});
X = reordercats(X,{'UD [0,90]_1_1_s', 'UD [90,0]_1_1_s', 'Woven [0,90]_6_s'});
Y = [mean(props.CrossUD0Flexion.Module), mean(props.CrossUD90Flexion.Module), mean(props.CrossWFlexion.Module)];

errhigh = [std(props.CrossUD0Flexion.Module), std(props.CrossUD90Flexion.Module), std(props.CrossWFlexion.Module)];
errlow  = [std(props.CrossUD0Flexion.Module), std(props.CrossUD90Flexion.Module), std(props.CrossWFlexion.Module)];

MaxModulus = [max(props.CrossUD0Flexion.Module), max(props.CrossUD90Flexion.Module), max(props.CrossWFlexion.Module)];
MinModulus = [min(props.CrossUD0Flexion.Module), min(props.CrossUD90Flexion.Module), min(props.CrossWFlexion.Module)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxModulus,'sk','MarkerFaceColor','black');
p2 = plot(X, MinModulus,'sk','MarkerFaceColor','black');

% Labels
ylabel('Flexural Modulus (GPa)')


hold off

%% Bar chart Flexion DLF
% ------------------------- Module DLF ---------------------
figure('Name','Bar Flexion DLF')
subplot(1,2,2)
hold on

% Data to be plotted
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(props.UDFlexion.Module), mean(props.WovenFlexion.Module)];

errhigh = [std(props.UDFlexion.Module), std(props.WovenFlexion.Module)];
errlow  = [std(props.UDFlexion.Module), std(props.WovenFlexion.Module)];

MaxModulus = [max(props.UDFlexion.Module), max(props.WovenFlexion.Module)];
MinModulus = [min(props.UDFlexion.Module), min(props.WovenFlexion.Module)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxModulus,'sk','MarkerFaceColor','black');
p2 = plot(X, MinModulus,'sk','MarkerFaceColor','black');

% Labels
ylabel('Module (GPa)')
yticks(0:10:60)

hold off

% ------------------------- Moment maximal DLF ---------------------
% module est baser sur la formule M = FL/8
subplot(1,2,1)
hold on

% Data to be plotted
X = categorical({'UD','Woven'});
X = reordercats(X,{'UD','Woven'});
Y = [mean(props.UDFlexion.Moment), mean(props.WovenFlexion.Moment)];

errhigh = [std(props.UDFlexion.Moment), std(props.WovenFlexion.Moment)];
errlow  = [std(props.UDFlexion.Moment), std(props.WovenFlexion.Moment)];

MaxStrength = [max(props.UDFlexion.Moment), max(props.WovenFlexion.Moment)];
MinStrength = [min(props.UDFlexion.Moment), min(props.WovenFlexion.Moment)];

% plot data
bar(X,Y)
er = errorbar(X,Y,errlow,errhigh);
er.Color = [0 0 0];                            
er.LineStyle = 'none';

% plot min and max values
p = plot(X, MaxStrength,'sk','MarkerFaceColor','black');
p2 = plot(X, MinStrength,'sk','MarkerFaceColor','black');

% Labels
ylabel('Moment at mid-span (Nm)')

yticks(0:2:20)

hold off

%% Sample position analysis

figure('Name','Sample Position')

% resitance UD
subplot(1,2,1)
hold on
xticks([1,2,3,4,5])
for i = 1:length(props.UDTraction.Position)
    Plot1 = plot(props.UDTraction.Position(i),props.UDTraction.Resistance(i),'sb', 'MarkerFaceColor', 'b');
    Plot2 = plot(props.WovenTraction.Position(i),props.WovenTraction.Resistance(i),'or', 'MarkerFaceColor', 'r');
end
ylabel('Strength (MPa)')
xlabel('Sampling Position')
title('Résistance')

legend1 = legend([Plot1, Plot2],{'UD chips','Woven Chips'}, 'Location','NorthEast');
hold off

% Module UD
subplot(1,2,2)
hold on
xticks([1,2,3,4,5])
for i = 1:length(props.UDTraction.Position)
    Plot1 = plot(props.UDTraction.Position(i),props.UDTraction.Module(i),'sb', 'MarkerFaceColor', 'b');
    Plot2 = plot(props.WovenTraction.Position(i),props.WovenTraction.Module(i),'or', 'MarkerFaceColor', 'r');
end
ylabel('Modulus (GPa)')
xlabel('Sampling Position')
title('Rigidité')

legend1 = legend([Plot1, Plot2],{'UD chips','Woven Chips'}, 'Location','NorthEast');
hold off

%% Analyse Statistique des données DLF
% create table with coefficient of variance
Traction = [props.UDTraction.Module, props.WovenTraction.Module, props.UDTraction.Resistance, props.WovenTraction.Resistance];
Flexion = [props.UDFlexion.Module, props.WovenFlexion.Module, props.UDFlexion.Resistance, props.WovenFlexion.Resistance];

CoV_T = CoeffVar(Traction);
CoV_F = CoeffVar(Flexion);
CoV = [CoV_T; CoV_F];

str = ["Traction", "Flexion"]';
CoV = array2table(CoV,'RowNames',str);
CoV.Properties.VariableNames = {'Module UD' 'Module Woven' 'Resistance UD' 'Resistance Woven'} %#ok<NOPTS>

% analysis of variance
y = [props.UDTraction.Resistance; props.WovenTraction.Resistance];
name = [props.UDTraction.ChipType; props.WovenTraction.ChipType];
Trct_Res = anova1(y,name,'off');

y = [props.UDTraction.Module; props.WovenTraction.Module];
name = [props.UDTraction.ChipType; props.WovenTraction.ChipType];
Trct_Mod = anova1(y,name,'off');

y = [props.UDFlexion.Resistance; props.WovenFlexion.Resistance];
name = [props.UDFlexion.ChipType; props.WovenFlexion.ChipType];
Flex_Res = anova1(y,name,'off');

y = [props.UDFlexion.Module; props.WovenFlexion.Module];
name = [props.UDFlexion.ChipType; props.WovenFlexion.ChipType];
Flex_Mod = anova1(y,name,'off');

PValues = [Trct_Res, Trct_Mod, Flex_Res, Flex_Mod];
Accept = PValues > 0.05;
Anova = [PValues; Accept];

str = ["P value" "Difference"]';
Anova = array2table(Anova,'RowNames', str);
Anova.Properties.VariableNames = {'Resistance Traction' 'Module Traction' 'Resistance Flexion' 'Module Flexion'} %#ok<NOPTS>

%% Analyse Statistique des données Continue
CoV_MFlex = CoeffVar([props.CrossUD0Flexion.Module, props.CrossUD90Flexion.Module, props.CrossWFlexion.Module]);
CoV_RFlex = CoeffVar([props.CrossUD0Flexion.Moment, props.CrossUD90Flexion.Moment, props.CrossWFlexion.Moment]);
