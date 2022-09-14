# Interactive Deepstream TAO apps 

I modified a couple of sample Deepstream 6.1 TAO apps from the [deepstream_tao_apps
](https://github.com/NVIDIA-AI-IOT/deepstream_tao_apps) repository in order to enable USB camera input support. These are:

* BodyPose2D app
* Emotion Recognition app which also relies on the Facial Landmark app

## Prerequisites

* DeepStream SDK 6.1 and above

I implemneted and tested these apps on [NVIDIA Jetson](https://developer.nvidia.com/embedded-computing) running JetPack 4.6 and JetPack 5.0. In order to run it in a different environment, you might need to change some paths in make files according to your system setup. 

Clone the project and move to the project directory.

```shell
git clone https://github.com/katjasrz/deepstream_tao_interactive.git
cd deepstream_tao_interactive
```

## Body Pose 2D app

### Description 

The bodypose2D sample application uses bodypose2D model to detect human body parts coordinates. The application can output the 18 body parts:
- nose
- neck
- right shoulder
- right elbow
- right hand
- left shoulder
- left elbow
- left hand
- right hip
- right knee
- right foot
- left hip
- left knee
- left foot
- right eye
- left eye
- right ear 
- left ear

For more information refer to the original [BodyPose2d app](https://github.com/NVIDIA-AI-IOT/deepstream_tao_apps/tree/master/apps/tao_others/deepstream-bodypose2d-app).

### Model

The bodypose2D backbone and pre-trained model are provided by TAO 3.0 [bodypose 2D estimation](https://ngc.nvidia.com/catalog/models/nvidia:tao:bodyposenet). 
  
Prepare the model storage and download the model:

```shell
mkdir -p ./models/bodypose2d
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/bodyposenet/versions/deployable_v1.0.1/zip -O bodyposenet_deployable_v1.0.1.zip
unzip bodyposenet_deployable_v1.0.1.zip -d ./models/bodypose2d/
rm bodyposenet_deployable_v1.0.1.zip
```

### Building the app

```shell
make -C ./deepstream-bodypose2d-app/
```

### Executing the app in interactive mode

Make sure you have a USB camera attached to your device and then execute.

```shell
chmod 777 ./deepstream-bodypose2d-app/launch_usb_camera.sh
./deepstream-bodypose2d-app/launch_usb_camera.sh
```

On the first run the model you downloaded gets optimized with TensorRT, that's why it might take some time until you see the result. On the followng executions the optimized model will be already there and the app will start running faster. You might see some TRT warning during conversion, it's safe to ignore them.

### Executing the app with a sample video

If you don't have a USB camera, you can still run the app on a sample video. For that, place a smaple mp4 file containing people into the folder `deepstream-bodypose2d` (you can use a sample from `/opt/nvidia/deepstream/deepstream/samples/streams`), rename it as `test_video.mp4` and execute the app running

```shell
chmod 777 ./deepstream-bodypose2d-app/launch_video.sh
./deepstream-bodypose2d-app/launch_video.sh
```

## Emotion recognition app

### Description

The emotion deepstream sample application identify human emotion based on the facial landmarks. Current sample application can identify five emotions as neutral, happy, surprise, squint, disgust and scream. 

For more information refer to the original [Emotion app](https://github.com/NVIDIA-AI-IOT/deepstream_tao_apps/tree/master/apps/tao_others/deepstream-emotion-app).

### Model

The TAO 3.0 pretrained models used in the sample application are:

* [Facial Landmarks Estimation](https://ngc.nvidia.com/catalog/models/nvidia:tao:fpenet)
* [FaceNet](https://ngc.nvidia.com/catalog/models/nvidia:tao:facenet)
* [EmotionNet](https://ngc.nvidia.com/catalog/models/nvidia:tao:emotionnet)

Download the models:

```shell
mkdir -p ./models/faciallandmark
cd ./models/faciallandmark
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/fpenet/versions/deployable_v3.0/files/model.etlt -O faciallandmarks.etlt
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/fpenet/versions/deployable_v3.0/files/int8_calibration.txt -O fpenet_cal.txt
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/facenet/versions/pruned_quantized_v2.0/files/model.etlt -O facenet.etlt
wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tao/facenet/versions/pruned_quantized_v2.0/files/int8_calibration.txt -O int8_calibration.txt
cd -
mkdir -p ./models/emotion
cd ./models/emotion
wget https://api.ngc.nvidia.com/v2/models/nvidia/tao/emotionnet/versions/deployable_v1.0/files/model.etlt -O emotion.etlt
cd -
```

### Building the app

For Jetson platform:

Copy the `gst-nvdsvideotemplate` plugin source code from DeepStream for servers and workstations package, put it into the folder `/opt/nvidia/deepstream/deepstream/sources/gst-plugins/gst-nvdsvideotemplate` and make it:

```shell
cd /opt/nvidia/deepstream/deepstream/sources/gst-plugins/gst-nvdsvideotemplate
make
cp libnvdsgst_videotemplate.so /opt/nvidia/deepstream/deepstream/lib/gst-plugins/
rm -rf ~/.cache/gstreamer-1.0/
cd -
```

After returning back to the projetc directory, execute:

```shell
make -C ./deepstream-emotion-app/emotion_impl/
make -C ./deepstream-emotion-app/
```

### Executing the app in interactive mode

```shell
chmod 777 ./deepstream-emotion-app/launch_usb_camera.sh
./deepstream-emotion-app/launch_usb_camera.sh
```

Again, during the first execution optimization with TensorRT might take some time.

### Executing the app with a sample video

```shell
chmod 777 ./deepstream-emotion-app/launch_video.sh
./deepstream-emotion-app/launch_video.sh
```

