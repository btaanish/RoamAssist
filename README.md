# RoamAssist

RoamAssist is an innovative application designed to assist visually impaired individuals by facilitating communication with an autonomous robotic guide dog. This project integrates sophisticated technologies in mobile development, speech recognition, and robotics to create a reliable and user-friendly navigation aid.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)

## Overview

RoamAssist leverages a combination of mobile development, cloud services, and robotic systems to provide visually impaired users with a comprehensive navigation solution. The application features a Flutter-based frontend designed for accessibility, a backend powered by Firebase for real-time data synchronization, and a Flask server for handling application logic. The backend communicates with a ROS (Robot Operating System) node to enable real-time interaction with the robotic guide dog. OpenAI's Whisper is employed for multilingual speech recognition, allowing users to interact with the application using voice commands in multiple languages.

## Features

- **Accessible User Interface**: The frontend is developed using Flutter, incorporating accessibility features such as high-contrast themes, large buttons, and voice feedback to enhance usability for visually impaired users.
- **Multilingual Speech Recognition**: Utilizes OpenAI's Whisper to provide accurate speech recognition in multiple languages, enabling users to issue commands and interact with the application using their preferred language.
- **Destination and Map Management**: Users can easily enter destinations and select maps, facilitating straightforward navigation and route planning.
- **Real-Time Robotic Communication**: The application interfaces with a ROS node to communicate with the robotic guide dog, providing real-time updates and control.
- **Obstruction Detection Alerts**: The robotic guide dog is equipped with sensors to detect obstructions, and the application alerts users to ensure safe navigation.
- **Bark Feature**: Allows users to determine the location of the robotic guide dog through an auditory signal, enhancing spatial awareness.

## Architecture

### Frontend
- **Framework**: Flutter
- **Accessibility**: Designed with visually impaired users in mind, featuring high-contrast themes, large buttons, and voice feedback.

### Backend
- **Server**: Flask
- **Database**: Firebase for real-time data synchronization and user authentication
- **Speech Recognition**: OpenAI's Whisper for multilingual voice command processing

### Robotics
- **System**: ROS (Robot Operating System)
- **Communication**: Integration with the Flask server to enable real-time interaction between the app and the robotic guide dog

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Firebase, Flask
- **Speech Recognition**: OpenAI's Whisper
- **Robotics**: ROS (Robot Operating System)

## Setup and Installation

To set up RoamAssist on your local machine, follow these steps:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/RoamAssist.git
   cd RoamAssist
   ```

2. **Frontend Setup**
   - Ensure Flutter is installed. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
   - Navigate to the `frontend` directory and install dependencies:
     ```bash
     cd frontend
     flutter pub get
     ```

3. **Backend Setup**
   - Ensure Python and Flask are installed. Create a virtual environment and install dependencies:
     ```bash
     python -m venv venv
     source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
     pip install -r requirements.txt
     ```

4. **Firebase Setup**
   - Set up a Firebase project and update the configuration in both the frontend and backend with your project's credentials.

5. **ROS Setup**
   - Ensure ROS is installed and configured. Follow the [ROS installation guide](http://wiki.ros.org/ROS/Installation).
   - Connect the Flask server to the ROS node.

## Usage

1. **Run the Frontend**
   ```bash
   cd frontend
   flutter run
   ```

2. **Run the Backend**
   ```bash
   cd backend
   source venv/bin/activate  # If not already activated
   flask run
   ```

3. **Connect to the ROS Node**
   - Ensure the ROS node is running and properly configured for communication with the Flask server.
