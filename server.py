#!/usr/bin/env python

import os
import subprocess
import time
import json

import rospy
from flask import Flask, request
from std_msgs.msg import String
from std_msgs.msg import Int8
from geometry_msgs.msg import PoseWithCovarianceStamped, Pose

import time

app = Flask(__name__)

def handle_command(command):
    print("Processing request...")
    cnt = 1

    #if command == "start" :
    #    cnt = 4
    #    ret = init()
    #    return ret
    #elif command == "get_start_and_goal":
    #    get_start_and_goal()
    #elif command == "start_nav":
    #    cnt = 1
    #else :
    #    cnt = 1

    cmd_list = command.split(':')
    command_prefix = cmd_list[0]
    print("command = {}, command prefix = {}".format(command, command_prefix))
    if len(cmd_list) > 1:
        msg = cmd_list[1]

    if command_prefix == "start" :
        cnt = 4
        ret = init()
        return ret
    elif command_prefix == "get_start_and_goal":
        ret = get_start_and_goal(command.split(":")[1])
        return ret
    elif command_prefix == "set_initial_pose":
        ret = set_initial_pose(msg)
        return ret
    elif command_prefix == "set_goal":
        set_goal(msg)
    elif command_prefix == "stop_nav": 
        stop_nav()
    elif command_prefix == "start_move":
        start_move()
    elif command_prefix == "pause_move":
        pause_move()
    elif command == "start_nav":
        cnt = 1
    else :
        cnt = 1

    while cnt != 0:
        command_str = command
        rospy.loginfo("Command Sent: " +  command_str)
        pub.publish(command_str)
        rate.sleep()
        cnt-=1

    return "Received"

    #msg = command
    #rospy.loginfo(msg)
    #pub.publish(msg)
    #rospy.sleep(5)
    #rospy.loginfo("Command Sent..")
    #rospy.signal_shutdown("Command sent...")

def stop_nav():
    os.system("/home/unitree/slamware_ws/killall_guidedog.sh > log_stop_nav 2>&1 &")

def init():
    ## query the ROS server for a list of map names
    ## now
    #os.system("roscore")
    print("initialize ros stack")
    os.system("/home/unitree/slamware_ws/launch_all_mapmode.sh > log_all 2>&1 &")
    os.system("/home/unitree/app_ws/launch_app.sh > log_app 2>&1 &")
    #os.system("/home/unitree/app_ws/launch_app.sh")
    #subprocess.call(['sh', '/home/unitree/slamware_ws/launch_all_mapmode.sh'])
    db_path = "/home/unitree/app_ws/map_databse/"
    for path in os.listdir(db_path):
        if not path.endswith("json"):
            continue
        map_path = os.path.join(db_path, path)
        if os.path.isfile(map_path):
            map_name = path.split('.')[0]
            map_names.append(map_name)
            map_paths[map_name] = map_path


    #map_names = ["com3", "com3-stairs"]
    ret_str = ','.join(map_names)
    print(ret_str)
    return ret_str

    #return map_names
    ## return a list of map

def load_initial_poses(path):

    initial_pose_list = open(path, "r")
    

    for l in initial_pose_list.readlines():
        l = l.strip().split()
        place_name = l[0]
        pose_from_file = list(map(float, l[1:]))
        pose = Pose()
        pose.position.x = pose_from_file[0]
        pose.position.y = pose_from_file[1]
        pose.orientation.z = pose_from_file[-2]
        pose.orientation.w = pose_from_file[-1]
        pose_list.append(pose)
        place_list.append(place_name)
    
    initial_pose_list.close()

#def get_map_destinations(map_name):
def load_goal_poses(path):
    fin = open(path, "r")
    lines = fin.readlines()
    ngoals = int(lines[0])
    goal_list_ret = list(map(str.strip, lines[1:]))
    return goal_list_ret
    
def get_start_and_goal(map_name):

    map_info_path = map_paths[map_name]
    data = json.load(open(map_info_path))
    map_path = data['lidar_pcd_map']
    grid_map_path = data['grid_map']
    initial_poses_path = data['initial_poses']
    stair_path = data['stair_positions']
    path_folder = data['path_folder']
    rospy.set_param("/roamassist/lidar_pcd_map", map_path)
    rospy.set_param("/roamassist/grid_map", grid_map_path)
    rospy.set_param("/roamassist/lidar_initial_poses", initial_poses_path)
    rospy.set_param("/roamassist/stair_positions", stair_path)
    rospy.set_param("/roamassist/path_folder", path_folder)

    #rospy.set_param("/roamassist/path_folder", "/home/unitree/.ros/com3_stairs/")

    #fin = open("/home/unitree/.ros/com3_stairs/", "r")


    ### load the initial poses
    load_initial_poses(initial_poses_path)
    initial_poses_str = ','.join(place_list)

    goal_path = "/home/unitree/.ros/com3_stairs/goal_list.txt"
    goal_list_ret = load_goal_poses(goal_path)
    goal_poses_str = ','.join(goal_list_ret)
    goal_list.extend(goal_list_ret)

    #goal_names = ["food collection", "toilet", "seat"]
    #return ','.join(goal_names)

    time.sleep(5)

    return initial_poses_str + ":" + goal_poses_str
    ## return a list of map

def set_initial_pose(place_name):

    init_pose_msg = PoseWithCovarianceStamped()
    init_pose_msg.header.frame_id = "map"
    initial_place_id = place_list.index(place_name)
    selected_pose = pose_list[initial_place_id] 
    init_pose_msg.header.stamp = rospy.Time.now()
    #initpose.pose.pose.position.x = x
    #initpose.pose.pose.position.y = y
    init_pose_msg.pose.pose = selected_pose
    init_pose_pub.publish(init_pose_msg)

    print("initialpose published")
    
    pose_msg = rospy.wait_for_message('/loc_state', Int8)
    return loc_results

def InitStateCallback(msg):
    state = msg.data
    if state == 1:
        print("Init Localization Successfully!")
        loc_suc = True
        loc_results = "success"
    else:
        loc_suc = False
        print("Attempt to localize")
        loc_results = "fail"
    return

def set_goal(goal_name):
    goal_id = goal_list.index(goal_name)
    #goal_id = 0;
    num = Int8()
    num.data = goal_id
    for _ in range(10):
        pub_goal_id.publish(num)
        print("goal {} published".format(goal_id))
        rate.sleep()


def start_move():
    joy_stop = Int8()
    joy_stop.data = 0
    for _ in range(10):
        pub_app_joy.publish(joy_stop)
        rate.sleep()


def pause_move():
    joy_stop = Int8()
    joy_stop.data = 1
    for _ in range(10):
        pub_app_joy.publish(joy_stop)
        rate.sleep()
    


#@app.route('/command', methods=['POST'])
#def flask_callback():
#    print("Received instruction from application")
#    command = request.json.get('command')
#    handle_command(command)
#    return 'Received'

@app.route('/command', methods=['POST'])
def flask_callback():
    print("in the flask callback")
    print("Received instruction from application")
    command = request.json.get('command')
    ret = handle_command(command)
    return ret

    #return 'Received'

    #return ','.join(map_names)

if __name__ == '__main__':

    rospy.init_node("app_server")
    rospy.loginfo('roamasssist app server launched')
    rate = rospy.Rate(10) # 10hz
    pub = rospy.Publisher('application', String, queue_size=1)
    pub_goal_id = rospy.Publisher('/roamassist/app_goal_id', Int8, queue_size=1)
    pub_app_joy = rospy.Publisher('/roamassist/app_joy_stop', Int8, queue_size=1)
    init_pose_pub = rospy.Publisher('initialpose', PoseWithCovarianceStamped, queue_size=10)

    rospy.Subscriber('loc_state', Int8, InitStateCallback, queue_size=1)
    loc_results = ""

    #set_goal_pose()
    #rospy.spin()

    ### intialize variables
    map_paths = {}
    #map_names = ['com3', 'soc']
    map_names = []
    goal_list = []
    pose_list = []
    place_list = []

    #init()
    #get_start_and_goal("com3")
    #set_initial_pose("com3_entrance")
    #set_goal("stair")

    #counter = 0
    #while True:
    #    time.sleep(1)
    #    print("waiting for app to start {}".format(counter))
    #    counter += 1
    try:
        print("Running Flask server...")
        app.run(host='0.0.0.0', port=5000, debug=True)
    except rospy.ROSInterruptException:
        pass
