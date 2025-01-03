#!/bin/bash

source install/setup.bash

# use clock from bag as sim time and start paused
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_07_11-05_28_15/ --clock -p"
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_07_18-05_47_36/ --clock -p" # pushed aroud
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_07_25-03_24_19/ --clock -p" # lidar on roll hoop test
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_07_25-05_04_46/ --clock -p" # half lap
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_07_25-05_18_42/ --clock -p" # other half of lap
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_09_04-05_14_43 --clock -p" # 2.5 laps
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_09_24-02_11_49/ --clock -p" 
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_09_24-02_16_55/ --clock -p" # ebs test run
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_10_18-01_10_29/ --clock -p" # 9 laps, recording from 1st corner
# BAG_CMD="ros2 bag play -s mcap /mnt/e/rosbag2_2024_10_18-01_40_49 --clock -p" # 10 laps recording from 2nd lap, 1st corner
# BAG_CMD="ros2 bag play -s mcap /mnt/d/rosbag2_2024_10_18-04_47_04 --clock -p" # 14 laps recording from 2nd lap, 1st corner
# BAG_CMD="ros2 bag play -s mcap /mnt/d/trackdrive-2024-11-20-02-48-40 --clock -p" #
# BAG_CMD="ros2 bag play -s mcap /mnt/d/trackdrive-2024-11-25-00-43-28 --clock -p" # QR 4.5 laps
# BAG_CMD="ros2 bag play -s mcap /mnt/d/rosbag2_2024_11_12-02_49_14 --clock -p"
BAG_CMD="ros2 bag play -s mcap /mnt/d/ebs_test-2024-12-07-05-26-36 --clock -p" # ebs crash

TOPICS=(
    # for mapping debugging
    /imu/odometry # needed for RL
    /vehicle/wheel_twist # needed for RL
    /system/av_state # needed for lap = 0 in mapping
    /system/ros_state # needed for lap = 0 in mapping

    # for detection and mapping debugging
    /lidar/objects
    /lidar/ground_plane
    # /lidar/converted_2D_scan
    # /lidar/cone_detection
    # /debug_markers/lidar_markers

    # raw data for visuals (nice to always have)
    /imu/nav_sat_fix
    /vehicle/velocity
    /vehicle/steering_angle
    /imu/data
    # /velodyne_points # only some bags

    # for fast lap debugging
    # /tf
    # /tf_static
    # /odometry/filtered
    # /slam/occupancy_grid
    # /slam/occupancy_grid_metadata
    # /slam/pose
    # /slam/graph_visualization

)

# remap these topics if you are running programs which output to the same topic names
REMAPS=(
    # /odometry/filtered:=/odometry/filtered_old
    # /sbg_translated/odometry:=/sbg_translated/odometry_old
    # /tf:=/tf_old
    # /control/driving_command:=/control/driving_command_old
    /lidar/objects:=/lidar/objects_old
    /lidar/ground_plane:=/lidar/ground_plane_old
)

# for each topic append to the command
if [ ${#TOPICS[@]} -gt 0 ]; then
    BAG_CMD+=" --topics"
    for ((i=0; i<${#TOPICS[@]}; i++)); do
        BAG_CMD+=" ${TOPICS[$i]}"
    done
fi

# for each remap, create a remap string and append to the command
if [ ${#REMAPS[@]} -gt 0 ]; then
    BAG_CMD+=" --remap"
    for ((i=0; i<${#REMAPS[@]}; i++)); do
        BAG_CMD+=" ${REMAPS[$i]}"
    done
fi

# loop if arg is given
if [ "$1" == "loop" ]; then
    BAG_CMD+=" --loop"
fi

# run the command
echo $BAG_CMD
eval $BAG_CMD
