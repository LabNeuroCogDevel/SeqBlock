#!/usr/bin/env sh

runTime=600                  # length of run:  5min*60sec/min (was too long, 20min*60sec/min)
TR=1.5                       # t_r, MRI setting
nTR=$(echo $runTime/$TR| bc) # number of TRs  # 200 TRs

echo "nTR = $nTR"
meanISI=5

blockReps=2

cueDur=2
viewDur=2
retDur=5
fixDur=18

nIts=1000

rm -rf stims
mkdir -p stims
echo "iter lcnorm" > allstats.txt

for i in $(seq 1 $nIts); do
	ii=$(printf %05d $i)

	python /Applications/afni/make_random_timing.py -num_runs 1 -run_time $runTime  \
			  -tr $TR \
			  -num_stim 29  \
			  -stim_labels 	cue1 view1 ret1 \
							cue2 view2 ret2 \
							cue3 view3 ret3 \
							cue4 view4 ret4 \
							cue5 view5 ret5 \
							cue6 view6 ret6 \
							cue7 view7 ret7 \
							cue8 view8 ret8 \
							test_cue1 test_ret1 \
							test_cue2 test_ret2 \
							fix \
			  -num_reps     $blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps \
							$blockReps $blockReps $blockReps $blockReps $blockReps \
				-stim_dur   $cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $retDur  \
							$cueDur $retDur \
							$fixDur \
			  -ordered_stimuli cue1 view1 ret1 \
							cue2 view2 ret2 \
							cue3 view3 ret3 \
							cue4 view4 ret4 \
							cue5 view5 ret5 \
							cue6 view6 ret6 \
							cue7 view7 ret7 \
							cue8 view8 ret8 \
							test_cue1 test_ret1 \
							test_cue2 test_ret2 \
							fix \
			  -pre_stim_rest 2 -post_stim_rest 2           	\
			  -min_rest 2 -max_rest 6                   	\
			  -show_timing_stats -prefix stims/seq_${ii} > stims/seq_${ii}_maketiming.log


	python /Applications/afni/timing_tool.py -multi_timing stims/seq_${ii}*.1D \
		-multi_timing_to_events summary/alltimes_${ii}.txt \
		-multi_stim_dur 	$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $viewDur $retDur \
							$cueDur $retDur \
							$cueDur $retDur \
							$fixDur \
		-tr $TR \
		-min_frac 0.5 \
		-per_run \
		-run_len $runTime


	model_cue="BLOCK(2,1)"
	model_encode="BLOCK(2,1)"
	model_retrieve="BLOCK(3,1)"

    3dDeconvolve                                           			\
          -nodata $nTR $TR                                			\
          -polort 9                                        			\
          -num_stimts 28                                    		\
          -local_times												\
          -stim_times 1 stims/seq_${ii}_01_cue1.1D $model_cue 		\
          -stim_label 1 cue1                               			\
          -stim_times 2 stims/seq_${ii}_02_view1.1D $model_encode 	\
          -stim_label 2 view1                              			\
          -stim_times 3 stims/seq_${ii}_03_ret1.1D $model_retrieve 	\
          -stim_label 3 ret1                               			\
          -stim_times 4 stims/seq_${ii}_04_cue2.1D $model_cue 		\
          -stim_label 4 cue2                             			\
          -stim_times 5 stims/seq_${ii}_05_view2.1D $model_encode 	\
          -stim_label 5 view2                              			\
          -stim_times 6 stims/seq_${ii}_06_ret2.1D $model_retrieve 	\
          -stim_label 6 ret2                              			\
          -stim_times 7 stims/seq_${ii}_07_cue3.1D $model_cue 		\
          -stim_label 7 cue3                               			\
          -stim_times 8 stims/seq_${ii}_08_view3.1D $model_encode 	\
          -stim_label 8 view3                              			\
          -stim_times 9 stims/seq_${ii}_09_ret3.1D $model_retrieve 	\
          -stim_label 9 ret3                               			\
          -stim_times 10 stims/seq_${ii}_10_cue4.1D $model_cue 		\
          -stim_label 10 cue4                               			\
          -stim_times 11 stims/seq_${ii}_11_view4.1D $model_encode 		\
          -stim_label 11 view4                              			\
          -stim_times 12 stims/seq_${ii}_12_ret4.1D $model_retrieve 	\
          -stim_label 12 ret4                               			\
          -stim_times 13 stims/seq_${ii}_13_cue5.1D $model_cue 			\
          -stim_label 13 cue5                               			\
          -stim_times 14 stims/seq_${ii}_14_view5.1D $model_encode 		\
          -stim_label 14 view5                              			\
          -stim_times 15 stims/seq_${ii}_15_ret5.1D $model_retrieve 	\
          -stim_label 15 ret5                               			\
          -stim_times 16 stims/seq_${ii}_16_cue6.1D $model_cue 			\
          -stim_label 16 cue6                               			\
          -stim_times 17 stims/seq_${ii}_17_view6.1D $model_encode 		\
          -stim_label 17 view6                              			\
          -stim_times 18 stims/seq_${ii}_18_ret6.1D $model_retrieve 	\
          -stim_label 18 ret6                               			\
          -stim_times 19 stims/seq_${ii}_19_cue7.1D $model_cue 			\
          -stim_label 19 cue7                               			\
          -stim_times 20 stims/seq_${ii}_20_view7.1D $model_encode 		\
          -stim_label 20 view7                              			\
          -stim_times 21 stims/seq_${ii}_21_ret7.1D $model_retrieve 	\
          -stim_label 21 ret7                               			\
          -stim_times 22 stims/seq_${ii}_22_cue8.1D $model_cue 			\
          -stim_label 22 cue8                               			\
          -stim_times 23 stims/seq_${ii}_23_view8.1D $model_encode 		\
          -stim_label 23 view8                              			\
          -stim_times 24 stims/seq_${ii}_24_ret8.1D $model_retrieve 	\
          -stim_label 24 ret8                               			\
          -stim_times 25 stims/seq_${ii}_25_test_cue1.1D $model_cue 		\
          -stim_label 25 testcue1                               			\
          -stim_times 26 stims/seq_${ii}_26_test_ret1.1D $model_retrieve \
          -stim_label 26 testret1                              			\
          -stim_times 27 stims/seq_${ii}_27_test_cue2.1D $model_cue 		\
          -stim_label 27 testcue2                               			\
          -stim_times 28 stims/seq_${ii}_28_test_ret2.1D $model_retrieve \
          -stim_label 28 testret2                              			\
          -num_glt 2                                           \
          -gltsym "SYM: view4 view3 -view2 -view1" \
          -glt_label 1 view4_view1  \
          -gltsym "SYM: ret1 +ret2 +ret3 +ret4 +ret5 +ret6 +ret7 +ret8 -view1 -view2 -view3 -view4 -view5 -view6 -view7 -view8" \
          -glt_label 2 ret_view \
          -x1D stims/${ii}_X.xmat.1D   >  stims/${ii}.3ddlog 2>&1


	# correlation between regressors
    python $(which 1d_tool.py) -cormat_cutoff 0 -show_cormat_warnings -infile stims/${ii}_X.xmat.1D  \
        >> stims/${ii}.info

	# get mean LC norm std dev
    LCnorm=$(echo $(perl -ne \
        'push @a,$2 if m/.*(h|LC)\[.*norm. std. dev. = *(\d+.\d+)/; END{print join(" ",map(sprintf("%.05f",$_), @a))}'\
          stims/${ii}.3ddlog \
     ) | awk '{s+=$1}END{print s}' RS=" ")

	echo "${ii} $LCnorm" >> allstats.txt
	echo "${ii} $LCnorm"

done




