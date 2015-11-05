#!/usr/bin/env sh

use_local=0

if [ $use_local -gt 0 ]
then
num_jobs=4
sceneJSONGMMDir='./scenes/'
sceneJSONFeatDir='./scenes/'
feat_base='scenes_2015'
inst_ord='random'
outputDataDir='./'
configDir='/home/santol/cvmlp/abstract_scenes_v002/site_data/'
else
num_jobs=50
sceneJSONGMMDir='/srv/share/vqa/release_data/abstract_v002/scene_json/scene_train2015_indv/'
sceneJSONFeatDir='/srv/share/vqa/release_data/abstract_v002/scene_json/scene_indv/'
feat_base='abstract_v002'
inst_ord='random'
outputDataDir='/srv/share/vqa/release_data/abstract_v002/scene_json/features_v2/'
configDir='/srv/share/abstract_scenes_v002/site_data/'
fi

python abstract_features_helper.py clipart_library \
        --configdir=$configDir

python abstract_features_helper.py create_gmms \
        $sceneJSONGMMDir \
        $outputDataDir \
        --configdir=$configDir \
        --overwrite

# If you don't want to install joblib,
# you can use the non-parallel version
# python abstract_features_helper.py extract_features \
#         $sceneJSONFeatDir \
#         $outputDataDir \
#         --instord=$inst_ord \
#         --configdir=$configDir \
#         --overwrite
        
python abstract_features_helper.py extract_features_parallel \
        $sceneJSONFeatDir \
        $outputDataDir \
        $num_jobs \
        --instord=$inst_ord \
        --configdir=$configDir \
        --overwrite

python abstract_features_helper.py create_feat_matrix \
        $sceneJSONFeatDir \
        $outputDataDir \
        $feat_base \
        --instord=$inst_ord \
        --configdir=$configDir \
        --overwrite
