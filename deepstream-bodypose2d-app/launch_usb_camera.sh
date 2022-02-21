export LD_LIBRARY_PATH=/opt/nvidia/deepstream/deepstream/lib/cvcore_libs
cd ./deepstream-bodypose2d-app
./deepstream-bodypose2d-app 3 ../configs/bodypose2d_tao/sample_bodypose2d_model_config.txt camera ./out
