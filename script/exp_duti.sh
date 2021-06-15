#!/bin/bash



python_cmd=python3


#cd ../iterative_detect/


#batch_size=$8

#epochs=$7

#lr=$5


#l2_decay=$6


#outer_loop_count=2000


dataset_name=$2

model=Logistic_regression


remove_count=100

dataset_dir=$1




repeat_num=10

duti_training_lr=200

#clear_hist=$9

total_iteration=3

#running_iteration=${10}

isGPU=${3}

GPUID=${4}

tag=${5}


echo "run DUTI"

source ./hyper_${dataset_name}_one${tag}

echo "lr::"$lr
echo "l2 decay::" ${l2_decay}
echo "epochs::" ${epochs}
echo "batch size::" ${batch_size}


total_removed_count=${removed_total_count}    #$(( remove_count*repeat_num  ))


echo "total_removed_count::"${total_removed_count}

for (( i = 0 ; i < ${total_iteration} ; i++ ))
do


	if [ "${dataset_name}" == 'retina' ];
        then
                cp ${dataset_dir}/${dataset_name}/random_ids_multi_super_iterations_v${i} ${dataset_dir}/${dataset_name}/random_ids_multi_super_iterations;

                cp ${dataset_dir}/${dataset_name}/model_initial_v${i} ${dataset_dir}/${dataset_name}/model_initial;

                cp ${dataset_dir}/${dataset_name}/w_list_initial_v${i} ${dataset_dir}/${dataset_name}/w_list_initial;


                cp ${dataset_dir}/${dataset_name}/grad_list_initial_v${i} ${dataset_dir}/${dataset_name}/grad_list_initial;

        else

                cp ${dataset_dir}/random_ids_multi_super_iterations_v${i} ${dataset_dir}/random_ids_multi_super_iterations;

                cp ${dataset_dir}/model_initial_v${i} ${dataset_dir}/model_initial;

                cp ${dataset_dir}/w_list_initial_v${i} ${dataset_dir}/w_list_initial;


                cp ${dataset_dir}/grad_list_initial_v${i} ${dataset_dir}/grad_list_initial;

        fi





	echo "bash run_duti.sh ${1} $2 ${total_removed_count} 1 $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID} ${tag}"

	bash run_duti.sh ${1} $2 ${total_removed_count} 1 $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID} ${tag}

done


<<cmd
echo "start influence-l"

for (( i = 0 ; i < ${total_iteration} ; i++ ))
do

#<<cmd
        echo "bash run_full_pipeline_suggest_label.sh ${hist_period}  ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} true ${i} ${isGPU} ${GPUID}"

        bash run_full_pipeline_suggest_label.sh ${hist_period}  ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} true ${i} ${isGPU} ${GPUID}
	echo "bash run_full_pipeline_suggest_label0.sh ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID}"

        bash run_full_pipeline_suggest_label0.sh ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID}
	
	echo "bash run_full_pipeline.sh ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID}"

        bash run_full_pipeline.sh ${1} $2 ${remove_count} ${repeat_num} $lr ${l2_decay} ${epochs} ${batch_size} false ${i} ${isGPU} ${GPUID}
done
cmd
