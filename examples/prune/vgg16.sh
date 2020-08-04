#!/bin/bash
export PYTHONPATH=../..:$PYTHONPATH

iter=10000
id=1
splmda=0
lmda=0
layer=1234
lr=5e-3
wd=1e-4
mmt=0

DATASETS=(MIT_67 CUB_200_2011 Flower_102 stanford_40 stanford_dog)
DATASET_NAMES=(MIT67Data CUB200Data Flower102Data Stanford40Data SDog120Data)
DATASET_ABBRS=(mit67 cub200 flower102 stanford40 sdog120)


for i in 0 
do
    for ratio in 0.2 0.5 0.7
    do

    DATASET=${DATASETS[i]}
    DATASET_NAME=${DATASET_NAMES[i]}
    DATASET_ABBR=${DATASET_ABBRS[i]}

    NAME=vgg16_${DATASET_ABBR}_\
total${ratio}_lr${lr}_iter${iter}_feat${lmda}_wd${wd}_mmt${mmt}_${id}
    DIR=results/prune/
    CKPT_DIR=results/finetune/vgg16/feat0/vgg16_${DATASET_ABBR}_lr5e-3_iter30000_wd1e-4_mmt0_1

    CUDA_VISIBLE_DEVICES=$1 \
    python -u finetune.py \
    --iterations ${iter} \
    --datapath data/${DATASET}/ \
    --dataset ${DATASET_NAME} \
    --name ${NAME} \
    --batch_size 32 \
    --feat_lmda ${lmda} \
    --lr ${lr} \
    --network vgg16_bn \
    --weight_decay ${wd} \
    --beta 1e-2 \
    --test_interval 1000 \
    --feat_layers ${layer} \
    --momentum ${mmt} \
    --output_dir ${DIR} \
    --method weight \
    --weight_ratio $ratio \
    --checkpoint ${CKPT_DIR}/ckpt.pth \
    # &


    done
done