% Creates GCP structure

% GCP 1
gcp(1).num = 1;
gcp(1).name = 'GCP1';
gcp(1).x = 342543.868;
gcp(1).y = 6266664.640;
gcp(1).z = 2.422;

% GCP 2
gcp(2).num = 2;
gcp(2).name = 'GCP2';
gcp(2).x = 342523.292;
gcp(2).y = 6266737.072;
gcp(2).z = 2.299;

% GCP 3
gcp(3).num = 3;
gcp(3).name = 'GCP3';
gcp(3).x = 342502.603;
gcp(3).y = 6266811.467;
gcp(3).z = 2.466;

% GCP 4
gcp(4).num = 4;
gcp(4).name = 'GCP4';
gcp(4).x = 342487.951;
gcp(4).y = 6266901.342;
gcp(4).z = 2.712;

% Argus camera
gcp(5).num = 5;
gcp(5).name = 'Argus camera';
gcp(5).x = 342513.077;
gcp(5).y = 6266720.103;
gcp(5).z = 44.475;


% save the gcpFile
save('gcpFileNarrabeen.mat','gcp')
