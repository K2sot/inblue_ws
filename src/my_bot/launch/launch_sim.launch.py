import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource

from launch_ros.actions import Node

def generate_launch_description():
    
    package_name = 'my_bot'

    rsp = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory(package_name), 'launch', 'rsp.launch.py')])
            , launch_arguments={'use_sim_time':'true'}.items()    
    )

    gazebo = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('gazebo_ros'),'launch','gazebo.launch.py'
        )]),
    )

    lidar = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('cspc_lidar'),'launch','lidar_launch.py'
        )]),
    )

    spawn_entity = Node(package='gazebo_ros', executable='spawn_entity.py',
                        arguments=['-entity', 'my_bot', '-topic', 'robot_description'],
                        output='screen')
    
    return LaunchDescription([
        rsp,
        gazebo,
        lidar,
        spawn_entity
    ])