function results=run_HC_HCFT(seq, res_path, bSaveImage)

close all

s_frame = seq.s_frames;

dbstop if error;

addpath('utility','train');

% Path to MatConvNet. Please run external/matconvnet/vl_compilenn.m to
% set up the MatConvNet

addpath './matconvnet/matlab'
vl_setupnn();

% Where the 'imagenet-vgg-verydeep-19.mat' file is
addpath './vgg_model'

addpath(genpath('edgesbox'));
addpath(genpath('piotr_toolbox'));
addpath(genpath('Diagnose'))

% Extra area surrounding the target
padding = struct('generic', 1.8, 'large', 1, 'height', 0.4);

lambda = 1e-4;              % Regularization parameter (see Eqn 3 in our paper)
output_sigma_factor = 0.1;  % Spatial bandwidth (proportional to the target size)

interp_factor = 0.01;       % Model learning rate (see Eqn 6a, 6b)
config.kernel_sigma = 1;
config.motion_thresh= 0.181; %0.25 for singer2 0.32;%0.15
config.appearance_thresh=0.38; %0.38
config.features.hog_orientations = 9;
config.features.cell_size = 4;   % size of hog grid cell		
config.features.window_size = 6; % size of local region for intensity historgram  
config.features.nbins=8; 
global enableGPU;
enableGPU = false;


    target_sz = [seq.init_rect(1,4), seq.init_rect(1,3)];
    pos = [seq.init_rect(1,2), seq.init_rect(1,1)] + floor(target_sz/2);

    [rect_position, time] = tracker_HC_HCFT(s_frame, pos, target_sz, ...
    padding, lambda, output_sigma_factor, interp_factor,config); %tracker_ensemble_RPnew1 

    fps = numel(s_frame)/time;
    
    disp(['fps: ' num2str(fps)])
    
results.type = 'rect';
results.res = rect_position;%each row is a rectangle
results.fps = fps;

































