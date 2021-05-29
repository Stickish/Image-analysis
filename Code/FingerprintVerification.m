%% Fingerprint Verification
clc, clear
clf, close all

img_1 = "Data/DB1_B/101_2";
img_2 = "Data/DB1_B/101_2";

w = 20;
print = true;
[validation_bif, validation_end] = Verify(img_1, img_2, w, print);

%% Run all databases
clc, clear
clf, close all
filenames_1 = strings(1,80);
filenames_2 = strings(1,80);
filenames_3 = strings(1,80);
filenames_4 = strings(1,80);
for fingerprint = 1:10
    for version = 1:8
        f = num2str(fingerprint);
        v = num2str(version);
        if fingerprint == 10
            name_1 = strcat('Data/DB1_B/1', f, '_', v);
            name_2 = strcat('Data/DB2_B/1', f, '_', v);
            name_3 = strcat('Data/DB3_B/1', f, '_', v);
            name_4 = strcat('Data/DB4_B/1', f, '_', v);
        else
            name_1 = strcat('Data/DB1_B/10', f, '_', v);
            name_2 = strcat('Data/DB2_B/10', f, '_', v);
            name_3 = strcat('Data/DB3_B/10', f, '_', v);
            name_4 = strcat('Data/DB4_B/10', f, '_', v);
        end
        position = version + 8*(fingerprint-1);
        filenames_1(1,position) = name_1;
        filenames_2(1,position) = name_2;
        filenames_3(1,position) = name_3;
        filenames_4(1,position) = name_4;
    end
end

% Database 1
validations_bif_1 = zeros(80,80);
validations_end_1 = zeros(80,80);

w = 20;
print = false;
i = 0;
run = 0;
for img_1 = filenames_1
    i = i+1;
    j = i;
    for img_2 = filenames_1(j:end)
        run = run+1;
        runs = strcat('Database 1: ', num2str(run), '/3200');
        disp(runs)
        
        [validation_bif, validation_end] = Verify(img_1, img_2, w, print);
        validations_bif_1(i,j) = validation_bif;
        validations_end_1(i,j) = validation_end;
        
        validations_bif_1(j,i) = validation_bif;
        validations_end_1(j,i) = validation_end;
        j = j+1;
        clc;
    end
end

fig = figure;
fig.Position = [100 100 1000 1000];
heatmap(validations_bif_1, 'Colormap', flipud(parula));
saveas(fig, 'Data/DB1_B/Images/heat_bif.png');

fig2 = figure;
fig2.Position = [100 100 1000 1000];
heatmap(validations_end_1, 'Colormap', flipud(autumn));
saveas(fig2, 'Data/DB1_B/Images/heat_end.png');

% Database 2
validations_bif_2 = zeros(80,80);
validations_end_2 = zeros(80,80);

w = 20;
print = false;
i = 0;
run = 0;
for img_1 = filenames_2
    i = i+1;
    j = i;
    for img_2 = filenames_2(j:end)
        run = run+1;
        runs = strcat('Database 2: ', num2str(run), '/3200');
        disp(runs)
        
        [validation_bif, validation_end] = Verify(img_1, img_2, w, print);
        validations_bif_2(i,j) = validation_bif;
        validations_end_2(i,j) = validation_end;
        
        validations_bif_2(j,i) = validation_bif;
        validations_end_2(j,i) = validation_end;
        j = j+1;
        clc;
    end
end

fig = figure;
fig.Position = [100 100 1000 1000];
heatmap(validations_bif_2, 'Colormap', flipud(parula));
saveas(fig, 'Data/DB2_B/Images/heat_bif.png');

fig2 = figure;
fig2.Position = [100 100 1000 1000];
heatmap(validations_end_2, 'Colormap', flipud(autumn));
saveas(fig2, 'Data/DB2_B/Images/heat_end.png');

%% Database 3

validations_bif_3 = zeros(80,80);
validations_end_3 = zeros(80,80);
w = 20;
print = false;
i = 0;
run = 0;
for img_1 = filenames_3
    i = i+1;
    j = i;
    for img_2 = filenames_3(j:end)
        run = run+1;
        runs = strcat('Database 3: ', num2str(run), '/3200');
        disp(runs)
        
        [validation_bif, validation_end] = Verify(img_1, img_2, w, print);
        validations_bif_3(i,j) = validation_bif;
        validations_end_3(i,j) = validation_end;
        
        validations_bif_3(j,i) = validation_bif;
        validations_end_3(j,i) = validation_end;
        j = j+1;
        clc;
    end
end

fig = figure;
fig.Position = [100 100 1000 1000];
heatmap(validations_bif_3, 'Colormap', flipud(parula));
saveas(fig, 'Data/DB3_B/Images/heat_bif.png');

fig2 = figure;
fig2.Position = [100 100 1000 1000];
heatmap(validations_end_3, 'Colormap', flipud(autumn));
saveas(fig2, 'Data/DB3_B/Images/heat_end.png');

% Database 4

validations_bif_4 = zeros(80,80);
validations_end_4 = zeros(80,80);
w = 20;
print = false;
i = 0;
run = 0;
for img_1 = filenames_4
    i = i+1;
    j = i;
    for img_2 = filenames_4(j:end)
        run = run+1;
        runs = strcat('Database 4: ', num2str(run), '/3200');
        disp(runs)
        
        [validation_bif, validation_end] = Verify(img_1, img_2, w, print);
        validations_bif_4(i,j) = validation_bif;
        validations_end_4(i,j) = validation_end;
        
        validations_bif_4(j,i) = validation_bif;
        validations_end_4(j,i) = validation_end;
        j = j+1;
        clc;
    end
end

fig = figure;
fig.Position = [100 100 1000 1000];
heatmap(validations_bif_4, 'Colormap', flipud(parula));
saveas(fig, 'Data/DB4_B/Images/heat_bif.png');

fig2 = figure;
fig2.Position = [100 100 1000 1000];
heatmap(validations_end_4, 'Colormap', flipud(autumn));
saveas(fig2, 'Data/DB4_B/Images/heat_end.png');