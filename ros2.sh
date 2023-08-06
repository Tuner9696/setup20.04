#!/bin/bash

# 初期設定
sudo apt update
sudo apt install -y curl gnupg2 lsb-release

# ROSリポジトリの追加
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# 依存パッケージのインストール
sudo apt update
sudo apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-lark-parser \
  python3-pip \
  python3-rosdep \
  python3-vcstool \
  wget

# ROSディストリビューションの指定
ros2_distro="foxy"  # 必要に応じて変更

# ROS 2のインストール
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
wget https://raw.githubusercontent.com/ros2/ros2/${ros2_distro}/ros2.repos
vcs import src < ros2.repos

# 依存パッケージのインストール
rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro ${ros2_distro} -y --skip-keys "console_bridge fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"

# ビルド
colcon build --symlink-install

# 環境設定の追加
echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
source ~/.bashrc

# 動作確認
# コメントアウトを解除して該当パッケージの動作確認を行う
# source ~/ros2_ws/install/setup.bash
# ros2 run demo_nodes_cpp talker
# ros2 run demo_nodes_cpp listener

