% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 2301.970524375440618 ; 2310.179761185488587 ];

%-- Principal point:
cc = [ 2004.838226707636522 ; 1179.871121085776394 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.024111826329842 ; 0.027408422623398 ; 0.007710954754638 ; 0.000906947264617 ; -0.018000729796538 ];

%-- Focal length uncertainty:
fc_error = [ 49.518610212803608 ; 10.377177094349847 ];

%-- Principal point uncertainty:
cc_error = [ 6.961940514254032 ; 94.866480607476220 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.009604298189564 ; 0.039188154996648 ; 0.001175321957311 ; 0.001115562004789 ; 0.043978625862516 ];

%-- Image size:
nx = 4000;
ny = 2250;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 30;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 1 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 2.130686e+00 ; -5.612657e-01 ; 2.502099e-01 ];
Tc_1  = [ -1.665224e+02 ; 8.049653e+01 ; 4.463656e+02 ];
omc_error_1 = [ 2.817534e-02 ; 6.616865e-03 ; 6.813871e-03 ];
Tc_error_1  = [ 1.376706e+00 ; 1.973068e+01 ; 1.014792e+01 ];

%-- Image #2:
omc_2 = [ NaN ; NaN ; NaN ];
Tc_2  = [ NaN ; NaN ; NaN ];
omc_error_2 = [ NaN ; NaN ; NaN ];
Tc_error_2  = [ NaN ; NaN ; NaN ];

%-- Image #3:
omc_3 = [ 1.609962e+00 ; -1.693000e+00 ; 8.500523e-01 ];
Tc_3  = [ 3.058325e+02 ; 7.135150e+01 ; 5.135115e+02 ];
omc_error_3 = [ 1.966192e-02 ; 1.957227e-02 ; 2.066530e-02 ];
Tc_error_3  = [ 1.577245e+00 ; 2.229894e+01 ; 1.172045e+01 ];

%-- Image #4:
omc_4 = [ NaN ; NaN ; NaN ];
Tc_4  = [ NaN ; NaN ; NaN ];
omc_error_4 = [ NaN ; NaN ; NaN ];
Tc_error_4  = [ NaN ; NaN ; NaN ];

%-- Image #5:
omc_5 = [ 3.276244e-01 ; -2.678760e+00 ; 1.353632e+00 ];
Tc_5  = [ 2.197066e+02 ; -2.027002e+02 ; 7.779658e+02 ];
omc_error_5 = [ 3.952835e-03 ; 2.220050e-02 ; 3.689934e-02 ];
Tc_error_5  = [ 2.431331e+00 ; 2.848915e+01 ; 1.702275e+01 ];

%-- Image #6:
omc_6 = [ 3.645679e-02 ; -2.775482e+00 ; 1.406113e+00 ];
Tc_6  = [ 3.004464e+02 ; -2.182995e+02 ; 8.467942e+02 ];
omc_error_6 = [ 2.647992e-03 ; 2.091342e-02 ; 3.936759e-02 ];
Tc_error_6  = [ 2.635446e+00 ; 3.103617e+01 ; 1.856170e+01 ];

%-- Image #7:
omc_7 = [ NaN ; NaN ; NaN ];
Tc_7  = [ NaN ; NaN ; NaN ];
omc_error_7 = [ NaN ; NaN ; NaN ];
Tc_error_7  = [ NaN ; NaN ; NaN ];

%-- Image #8:
omc_8 = [ NaN ; NaN ; NaN ];
Tc_8  = [ NaN ; NaN ; NaN ];
omc_error_8 = [ NaN ; NaN ; NaN ];
Tc_error_8  = [ NaN ; NaN ; NaN ];

%-- Image #9:
omc_9 = [ 1.676044e+00 ; 1.650216e+00 ; -8.603862e-01 ];
Tc_9  = [ -2.166485e+02 ; -2.767747e+02 ; 8.791976e+02 ];
omc_error_9 = [ 1.884749e-02 ; 2.006885e-02 ; 2.060250e-02 ];
Tc_error_9  = [ 2.759070e+00 ; 3.143949e+01 ; 1.889905e+01 ];

%-- Image #10:
omc_10 = [ NaN ; NaN ; NaN ];
Tc_10  = [ NaN ; NaN ; NaN ];
omc_error_10 = [ NaN ; NaN ; NaN ];
Tc_error_10  = [ NaN ; NaN ; NaN ];

%-- Image #11:
omc_11 = [ 2.292791e+00 ; 1.429005e-01 ; -8.601218e-02 ];
Tc_11  = [ -4.797338e+02 ; 4.624323e+01 ; 6.338312e+02 ];
omc_error_11 = [ 2.552486e-02 ; 3.050838e-03 ; 4.442428e-03 ];
Tc_error_11  = [ 1.937408e+00 ; 2.689522e+01 ; 1.398333e+01 ];

%-- Image #12:
omc_12 = [ 2.237828e+00 ; -4.989044e-01 ; 1.943529e-01 ];
Tc_12  = [ -2.212181e+02 ; 1.304121e+02 ; 5.372176e+02 ];
omc_error_12 = [ 2.553344e-02 ; 5.064145e-03 ; 6.124236e-03 ];
Tc_error_12  = [ 1.657631e+00 ; 2.436573e+01 ; 1.182293e+01 ];

%-- Image #13:
omc_13 = [ 1.941635e+00 ; -1.336705e+00 ; 5.652778e-01 ];
Tc_13  = [ 3.258548e+01 ; 1.045752e+02 ; 5.308897e+02 ];
omc_error_13 = [ 2.150487e-02 ; 1.325083e-02 ; 1.393187e-02 ];
Tc_error_13  = [ 1.623014e+00 ; 2.363429e+01 ; 1.177901e+01 ];

%-- Image #14:
omc_14 = [ NaN ; NaN ; NaN ];
Tc_14  = [ NaN ; NaN ; NaN ];
omc_error_14 = [ NaN ; NaN ; NaN ];
Tc_error_14  = [ NaN ; NaN ; NaN ];

%-- Image #15:
omc_15 = [ 1.058714e+00 ; -2.338438e+00 ; 1.033846e+00 ];
Tc_15  = [ 3.221170e+02 ; -8.830620e+01 ; 7.028612e+02 ];
omc_error_15 = [ 1.057403e-02 ; 1.983620e-02 ; 2.674908e-02 ];
Tc_error_15  = [ 2.169635e+00 ; 2.728953e+01 ; 1.576801e+01 ];

%-- Image #16:
omc_16 = [ 3.958046e-01 ; -2.704430e+00 ; 1.217871e+00 ];
Tc_16  = [ 2.774358e+02 ; -2.207229e+02 ; 7.768623e+02 ];
omc_error_16 = [ 4.553069e-03 ; 1.910463e-02 ; 3.317016e-02 ];
Tc_error_16  = [ 2.437060e+00 ; 2.800832e+01 ; 1.743424e+01 ];

%-- Image #17:
omc_17 = [ 5.416687e-02 ; -2.817583e+00 ; 1.277021e+00 ];
Tc_17  = [ 2.691517e+02 ; -2.269693e+02 ; 8.116870e+02 ];
omc_error_17 = [ 2.758909e-03 ; 1.781143e-02 ; 3.582318e-02 ];
Tc_error_17  = [ 2.526656e+00 ; 2.933436e+01 ; 1.824946e+01 ];

%-- Image #18:
omc_18 = [ NaN ; NaN ; NaN ];
Tc_18  = [ NaN ; NaN ; NaN ];
omc_error_18 = [ NaN ; NaN ; NaN ];
Tc_error_18  = [ NaN ; NaN ; NaN ];

%-- Image #19:
omc_19 = [ 1.691758e+00 ; 1.744498e+00 ; -8.336224e-01 ];
Tc_19  = [ -2.785257e+02 ; -2.769118e+02 ; 9.707929e+02 ];
omc_error_19 = [ 1.645006e-02 ; 1.861858e-02 ; 2.047783e-02 ];
Tc_error_19  = [ 3.021762e+00 ; 3.506569e+01 ; 2.150510e+01 ];

%-- Image #20:
omc_20 = [ 2.223773e+00 ; 6.096587e-01 ; -2.980530e-01 ];
Tc_20  = [ -4.985493e+02 ; -8.970264e+01 ; 6.934561e+02 ];
omc_error_20 = [ 2.464242e-02 ; 7.786226e-03 ; 7.733215e-03 ];
Tc_error_20  = [ 2.144991e+00 ; 2.697022e+01 ; 1.527816e+01 ];

%-- Image #21:
omc_21 = [ -1.074401e-02 ; 3.010968e+00 ; -8.689610e-01 ];
Tc_21  = [ 2.098643e+02 ; -2.851951e+02 ; 9.019351e+02 ];
omc_error_21 = [ 1.869067e-03 ; 7.370281e-03 ; 2.069287e-02 ];
Tc_error_21  = [ 2.821041e+00 ; 3.208675e+01 ; 1.998040e+01 ];

%-- Image #22:
omc_22 = [ 2.494062e+00 ; -7.163557e-01 ; 2.051422e-01 ];
Tc_22  = [ -1.601183e+02 ; 1.699304e+02 ; 6.147717e+02 ];
omc_error_22 = [ 1.307379e-02 ; 4.012069e-03 ; 6.381739e-03 ];
Tc_error_22  = [ 1.875162e+00 ; 2.822589e+01 ; 1.375554e+01 ];

%-- Image #23:
omc_23 = [ 2.173944e+00 ; -1.499776e+00 ; 4.159216e-01 ];
Tc_23  = [ 1.154983e+02 ; 1.692672e+02 ; 6.246060e+02 ];
omc_error_23 = [ 1.105467e-02 ; 7.286664e-03 ; 9.424908e-03 ];
Tc_error_23  = [ 1.898266e+00 ; 2.860726e+01 ; 1.393902e+01 ];

%-- Image #24:
omc_24 = [ 1.913885e+00 ; -1.880722e+00 ; 5.061417e-01 ];
Tc_24  = [ 3.755132e+02 ; 1.809314e+02 ; 6.584538e+02 ];
omc_error_24 = [ 9.377506e-03 ; 8.278652e-03 ; 1.061558e-02 ];
Tc_error_24  = [ 2.029517e+00 ; 3.021066e+01 ; 1.484700e+01 ];

%-- Image #25:
omc_25 = [ 1.162285e+00 ; -2.563166e+00 ; 7.004719e-01 ];
Tc_25  = [ 3.064569e+02 ; -9.385554e+01 ; 8.397709e+02 ];
omc_error_25 = [ 4.922831e-03 ; 9.223101e-03 ; 1.510931e-02 ];
Tc_error_25  = [ 2.592372e+00 ; 3.290371e+01 ; 1.845769e+01 ];

%-- Image #26:
omc_26 = [ 5.237563e-02 ; -3.004259e+00 ; 8.285043e-01 ];
Tc_26  = [ 2.885516e+02 ; -2.654285e+02 ; 8.608021e+02 ];
omc_error_26 = [ 1.816320e-03 ; 7.006765e-03 ; 1.879239e-02 ];
Tc_error_26  = [ 2.680268e+00 ; 3.081014e+01 ; 1.880682e+01 ];

%-- Image #27:
omc_27 = [ 7.425706e-01 ; 2.820917e+00 ; -7.883844e-01 ];
Tc_27  = [ 1.793303e+02 ; -4.323670e+02 ; 9.617756e+02 ];
omc_error_27 = [ 1.786456e-03 ; 7.912255e-03 ; 1.774733e-02 ];
Tc_error_27  = [ 3.067156e+00 ; 3.205981e+01 ; 2.094899e+01 ];

%-- Image #28:
omc_28 = [ 2.122452e+00 ; -1.611339e+00 ; 4.352841e-01 ];
Tc_28  = [ 1.337064e+02 ; 1.580574e+02 ; 6.233741e+02 ];
omc_error_28 = [ 1.003888e-02 ; 7.268598e-03 ; 9.582057e-03 ];
Tc_error_28  = [ 1.893151e+00 ; 2.835066e+01 ; 1.394448e+01 ];

%-- Image #29:
omc_29 = [ 1.945465e+00 ; -1.842803e+00 ; 5.071931e-01 ];
Tc_29  = [ 1.563166e+02 ; 1.837392e+02 ; 6.410756e+02 ];
omc_error_29 = [ 9.596666e-03 ; 8.366644e-03 ; 1.109555e-02 ];
Tc_error_29  = [ 1.978960e+00 ; 2.951515e+01 ; 1.420706e+01 ];

%-- Image #30:
omc_30 = [ 1.681737e+00 ; -2.145831e+00 ; 5.850051e-01 ];
Tc_30  = [ 2.765179e+02 ; 7.585478e+01 ; 7.336491e+02 ];
omc_error_30 = [ 7.776293e-03 ; 8.991981e-03 ; 1.251896e-02 ];
Tc_error_30  = [ 2.245452e+00 ; 3.146309e+01 ; 1.623206e+01 ];

