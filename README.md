# turtlebot3_d435

Project Description:
In our endeavor, we have successfully integrated and applied the Intel RealSense Camera D435i alongside the Turtlebot3 OpenManipulator platform to achieve seamless path planning and obstacle avoidance using the Move Base package during navigation. Additionally, we have implemented MoveIt, a comprehensive motion planning framework, to facilitate accurate movements of the OpenManipulator by leveraging depth data from the RealSense camera.

The integration and utilization of the Intel RealSense Camera D435i with the Turtlebot3 OpenManipulator platform, presents several interesting aspects:
1-  Advanced path planning and motion control: The combination of the Move Base package and MoveIt motion planning framework provides sophisticated algorithms and tools for efficient path planning and motion control. This allows the robot to optimize its trajectories, leading to smoother and more precise movements, especially when operating the OpenManipulator arm.
2- Real-world applications: The integration of these technologies opens up possibilities for various real-world applications. For example, in industrial settings, the robot can efficiently navigate through cluttered environments while safely avoiding obstacles and perform intricate manipulation tasks using the OpenManipulator arm. This can lead to increased productivity and automation in manufacturing processes.
3- Research and development opportunities: This integration presents exciting opportunities for further research and development in robotics. Researchers can explore and refine algorithms for depth-based navigation, obstacle avoidance, and motion planning, contributing to advancements in the field of robotics and automation.

At this moment, the robot can used in HECTOR mapping to create a high precise map.
Then it can be used by the robot for navigation.
The robot can be localized using AMCL algortihm. Although all the global planner, local planner, global costmap, and local DWA costmap parameters are tuned, the robot still face an issue with the laser scanner that rotates along with the robot rotation which makes the robot not able to move to the goal because it is always facing an obstacle. This may be due to odometry prroblem.

Our project is centered around the Waffle Pi TurtleBot3 model, which includes the OpenManipulator, a 2 Degree of Freedom (DoF) mobile robot with Dynamixel motors developed in collaboration with ROBOTIS and Open Robotics. The key components of this robot comprise actuators, a single-board computer (SBC) running ROS, a SLAM and navigation sensor, a restructurable mechanism, an OpenCR embedded board as a sub-controller, sprocket wheels for use with tire and caterpillar, a 3-cell lithium-polymer battery, and the OpenManipulator arm. The Waffle Pi model differs from the Burger model in its platform shape, allowing convenient component mounting, and features higher torque actuators and a high-performance SBC with an Intel processor. Notably, the robot is equipped with an Intel RealSense Depth Camera for 3D recognition. While both Waffle and Burger models share the same platform shape, TurtleBot3 Waffle Pi stands out by utilizing the Raspberry Pi as the SBC and the Raspberry Pi Camera, making it a more cost-effective solution. These components synergistically combine to create a versatile robotic system capable of sophisticated mobility, manipulation, SLAM, and 3D perception tasks.





System Architecture:
 In path planning part, the following robotics algorithm has been used:
1- AMCL:
Because robots and sensors are also nonlinear, particle filters are often used for pose
estimation. If the Kalman filter is an analytical method that assumes the sysm as a linear and
searches for parameters by linear motion, the particle filter is a technique to predict through
simulation based on try-and-error method. A particle filter gained its name because the
estimated value generated by the probability distribution in the system is represented as
particles. This is also called the Sequential Monte Carlo (SMC) method or the Monte Carlo
method. Here are the steps done by AMCL:

➊ Initialization
Since the robot’s initial pose (position, orientation) is unknown, the particles are randomly
arranged within the range where the pose can be obtained with N particles. Each of the initial
particle weighs 1/N, and the sum of the weight of particles is 1. N is empirically determined,
usually in the hundreds. If the initial position is known, particles are placed near the robot.
➋ Prediction
Based on the system model describing the motion of the robot, it moves each particle as the
amount of observed movement with odometry information and noise.
➌ Update
Based on the measured sensor information, the probability of each particle is calculated and the
weight value of each particle is updated based on the calculated probability.
➍ Pose estimation
The position, orientation, and weight of all particles are used to calculate the average weight,
median value, and the maximum weight value for estimating pose of the robot.
➎ Resampling
The step of generating new particles is to remove the less weighed particles and to create new
particles that inherit the pose information of the weighted particles. Here, the number of
particles N must be maintained.

There are many parameters that need to defined for AMCL algorithm. In our code, it is defined in AMCL launch file. The following figure shows those those parameters:





2- HECTOR SLAM:
This algorithm has advantages over gmapping.
    • It does not require odometry data, relying solely on LaserScan data.
    • But it is lacking of loop closing ability.
    • It adopts the concept of Continuous-time SLAM (CT-SLAM) in contrast to discrete approaches used in gmapping. 
    • In CT-SLAM, the estimated trajectory of the robot is represented by a continuous function that is defined by a discrete set of control points. Unlike discrete approaches, where the state estimation relies on discrete time steps and the frequency of sensor data, continuous approaches offer the advantage of easily fusing high-frequency data.
      
There are many parameters that need to defined for HECTOR SLAM algorithm. In our code, it is defined in slam2 launch file. The following figure shows those those parameters:




3- move base global planner:
When a new goal is received by the move_base node, it is immediately sent to the global planner. The global planner, then, will calculate a safe path for the robot to use to arrive to the specified goal. The global planner uses the global costmap data in order to calculate this path.
The movebase global planner parameters are defined in global_planner_params yaml file.



























4- move base DWA local planner:
After the global planner has determined the path for the robot to follow, this path is transmitted to the local planner. The local planner subsequently processes each segment of the global plan, effectively dividing it into smaller parts for execution. Consequently, the local planner takes the plan provided by the global planner, along with the map, and generates velocity commands to guide the robot's movements. The DWA samples from the set of achievable velocities for a single simulation step, considering the robot's acceleration limits. This makes DWA a more efficient algorithm as it samples a smaller space. However, for robots with low acceleration limits, Trajectory Rollout may outperform DWA since it accounts for forward simulation with constant accelerations.
The movebase DWA planner parameters are defined in dwa_local_planner_params yaml file.




5- move base global costmap:
It is is generated from a static map created by the user, similar to the one produced in the SLAM Mapping section. During initialization, the costmap is aligned with the dimensions and obstacle details specified in the static map. This configuration is commonly employed alongside a localization system, like amcl. This initialization method is utilized for setting up the global costmap.
The global costmap is governed by specific parameters outlined in a YAML file.


6- move base local costmap:
The local planner employs the local costmap to compute local plans. Unlike the global costmap, the local costmap is generated directly from the real-time sensor readings of the robot. After being provided with specified width and height parameters defined by the user, the local costmap ensures that the robot remains at the center of the costmap while navigating through the environment. As the robot moves, the local costmap continuously updates and removes obstacle information from the map, dynamically adjusting its representation to match the robot's position.

The local costmap is governed by specific parameters outlined in a YAML file.



6- move base costmap common parameters:
some common parameters for both local and global costmaps are defined in costmap_common_parameters.



Execution:
1- enter into the project directory using the following command:
cd turtlebot3_d435/src.

2- run slam2.launch file to run HECTOR SLAM using the following command:
roslaunch turtlebot3_d435i_description slam2.launch. It will launch both gazebo and Rviz environments.
Note: slam2 file is only used for HECTOR mapping. In order to localize the robot, and then execute path planning, please exit slam2.launch file using ctrl c and launch navigation launch file.

3- run navigation.launch file to run movebase in order to command the robot to move using the following command:
roslaunch turtlebot3_d435i_description navigation.launch


Challenges
1- Merging Realsense camera plugin with turtlebot3 gazebo file.
2- The robot sometimes can not move through the obstacles due to a problem in the map.
