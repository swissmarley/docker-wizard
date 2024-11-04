#!/bin/bash

echo """
                      ****                  
                      ****                  
              ************       #          
              ************      #**#        
          ********************  #***####    
          ********************   ******#    
        ***************************         
        **************************#         
        #********+**************#           
         #*********************#            
           *++++++**********#               
             ##*+++++*###                   

        ╦ ╦╔═╗╦  ╔═╗╔═╗╔╦╗╔═╗  ╔╦╗╔═╗
        ║║║║╣ ║  ║  ║ ║║║║║╣    ║ ║ ║
        ╚╩╝╚═╝╩═╝╚═╝╚═╝╩ ╩╚═╝   ╩ ╚═╝
    ╔╦╗╔═╗╔═╗╦╔═╔═╗╦═╗  ╦ ╦╦╔═╗╔═╗╦═╗╔╦╗
     ║║║ ║║  ╠╩╗║╣ ╠╦╝  ║║║║╔═╝╠═╣╠╦╝ ║║
    ═╩╝╚═╝╚═╝╩ ╩╚═╝╩╚═  ╚╩╝╩╚═╝╩ ╩╩╚══╩╝
"""

echo ""

# Function to display the main menu
display_menu() {
    # clear
    echo "Docker Wizard Menu:"
    echo ""
    echo "1. Create Container with Dockerfile"
    echo "2. Create Container with Docker Compose"
    echo "3. Build Container"
    echo "4. Show Running Containers"
    echo "5. Upload Container"
    echo "6. Download Container"
    echo "7. Manage Local Containers"
    echo "8. Show/Manage Docker Images"
    echo "9. Exit"
    echo ""
    echo -n "Enter your choice (1-9): "
    echo ""
}

# Function to create a container with Dockerfile
create_container_dockerfile() {
    # Prompt user for Dockerfile parameters
    echo "Creating container with Dockerfile:"
    read -p "Enter container name: " container_name_df
    read -p "Enter base image : " image_name_df
    read -p "Enter app directory: " working_directory_df
    read -p "Enter file for include dependencies: " requirements
    read -p "Enter command to install dependencies: " run_dependencies
    read -p "Enter your environment variables: " environment_df
    read -p "Enter port to expose your app: " port_df
    read -p "Enter command to run your app: " run_command_df
    
    # Generate Dockerfile
    echo "FROM $image_name_df" >> Dockerfile
    echo "WORKDIR /$working_directory_df" >> Dockerfile
    echo "COPY $requirements" >> Dockerfile
    echo "RUN $run_dependencies" >> Dockerfile
    echo "ENV $environment_df" >> Dockerfile
    echo "COPY . ." >> Dockerfile
    echo "EXPOSE $port_df" >> Dockerfile
    echo "CMD $run_command_df" >> Dockerfile
    
    # Build and run the container
    docker build -t $container_name_df .
    docker run -dp 127.0.0.1:$port_df:$port_df $container_name_df
    
    echo "Container '$container_name_df' created and running."
    echo ""
}

# Function to create a container with Docker Compose
create_container_compose() {
    # Prompt user for Docker Compose parameters
    echo "Creating container with Docker Compose:"
    read -p "Enter container name: " container_name_dc
    read -p "Enter service name: " service_name
    read -p "Enter image name: " image_name_dc
    read -p "Enter command to run: " run_command_dc
    read -p "Enter port to expose: " port_dc
    read -p "Enter the app directory: " working_directory_dc
    read -p "Enter your environment variables: " environment_dc
    
    # Generate Docker Compose YAML
    cat << EOF > docker-compose.yml
version: '1.0'
services:
  $service_name:
    image: $image_name_dc
    command: $run_command_dc
    ports: 
      - 127.0.0.1:$port_dc:$port_dc
    working_dir: /$working_directory_dc
    volumes:
      - .:/$working_directory_dc
    environment:
      - ENV_PATH=/$working_directory_dc/.env
      - $environment_dc
EOF
    
    # Build and run the container
    docker-compose -p $container_name_dc up -d
    
    echo "Container '$service_name' created and running."
    echo ""
}

# Function to build a container
build_container() {
    echo ""
    echo "Building container:"
    echo "1. Build with Dockerfile"
    echo "2. Build with Docker Compose"
    read -p "Enter your choice (1 or 2): " build_choice
    
    if [ $build_choice -eq 1 ]; then
        echo ""
        read -p "Enter name of the Dockerfile: " df_name
        read -p "Enter port to run your app: " build_port_df
        docker build -t $df_name .
        docker run -dp 127.0.0.1:$build_port_df:$build_port_df $df_name
        echo "Container $df_name created and running."
        echo ""
    elif [ $build_choice -eq 2 ]; then
        echo ""
        read -p "Enter name of the yml file: " dc_name
        read -p "Enter port to run your app: " build_port_dc
        docker-compose -p $dc_name up -d
        echo "Container $dc_name created and running."
        echo ""
    else
        echo "Invalid choice."
    fi
}

# Function to show running containers
show_running_containers() {
    echo ""
    echo "Currently running containers:"
    docker ps
    echo ""
}

# Function to upload container to Dockerhub/Local Registry
upload_container() {
    echo ""
    echo "Choose where to upload container:"
    echo "1. Dockerhub"
    echo "2. Local Registry"
    echo "3. Github Container Registry"
    read -p "Enter your choice (1 , 2 or 3): " repo_choice
    echo ""

    if [ $repo_choice -eq 1 ]; then
        echo "Upload container to Dockerhub:"
        read -p "Enter your username/tag: " tag_container
        read -p "Enter name of container: " upload_name
        echo "1. Upload with Docker CLI"
        echo "2. Upload with Docker Compose"
        read -p "Enter your choice: " upload_choice
        echo ""

        if [ $upload_choice -eq 1 ]; then
            docker login
            docker build -t $tag_container/$upload_name .
            docker push $tag_container/$upload_name
            echo "Container uploaded to Dockerhub."
            echo ""
        elif [ $upload_choice -eq 2 ]; then
            docker login
            docker-compose -p $tag_container/$upload_name up -d
            docker-compose -p $tag_container/$upload_name push
            echo "Container uploaded to Dockerhub."
            echo ""
        else
            echo "Invalid choice."
        fi

    elif [ $repo_choice -eq 2 ]; then
        echo "Upload container to Local Registry:"
        docker run -d -p 127.0.0.1:5000:5000 --name registry registry:2
        echo "Local Registry running on port 5000."
        echo ""
        read -p "Enter name of container: " upload_name_lr
        docker build -t localhost:5000/$upload_name_lr .
        docker tag $upload_name_lr localhost:5000/$upload_name_lr
        docker push localhost:5000/$upload_name2
        echo "Container $upload_name_lr uploaded to Local Registry."
        echo ""

    elif [ $repo_choice -eq 3 ]; then
        echo "Upload container to Github Container Registry:"
        read -p "Enter your Github Username: " github_user
        read -p "Enter your Personal Access Token: " github_token
        docker login -u $github_user -p $github_token ghcr.io
        read -p "Enter name of container: " upload_name_gh
        docker build -t ghcr.io/$github_user/$upload_name_gh:latest .
        docker tag $upload_name_gh ghcr.io/$github_user/$upload_name_gh:latest
        docker push ghcr.io/$github_user/$upload_name_gh:latest
        echo "Container $upload_name_gh uploaded to Github Container Registry."
        echo ""
    else
        echo "Invalid choice."
    fi
}

# Funtion to download container from Dockerhub/Local Registry
download_container() {
    echo ""
    echo "Choose where to download container:"
    echo "1. Dockerhub"
    echo "2. Local Registry"
    read -p "Enter your choice (1 or 2): " repo_choice_dl
    echo ""

    if [ $repo_choice_dl -eq 1 ]; then
        echo "Download container from Dockerhub:"
        read -p "Enter your username/tag: " tag_container_dl
        read -p "Enter name of container: " download_name_dl
        docker pull $tag_container_dl/$download_name_dl
        echo "Container $download_name_dl downloaded from Dockerhub."
        echo ""
        echo "You wanna run it?"
        read -p "1. Yes 2. No: " run_choice
        if [ $run_choice -eq 1 ]; then
            echo "Enter port to run your app: " port_dl
            docker run -dp 127.0.0.1:$port_dl:$port_dl $download_name_dl
        fi
        echo ""
    elif [ $repo_choice_dl -eq 2 ]; then
        echo "Download container from Local Registry:"
        docker run -d -p 127.0.0.1:5000:5000 --name registry registry:2
        echo "Local Registry running on port 5000."
        echo ""
        read -p "Enter name of container: " download_name_lr_dl
        docker pull localhost:5000/$download_name_lr_dl
        echo "Container $download_name_lr_dl downloaded from Local Registry."
        echo "You wanna run it?"
        read -p "1. Yes 2. No: " run_choice_lr
        if [ $run_choice_lr -eq 1 ]; then
            echo "Enter port to run your app: " port_lr_dl
            docker run -dp 127.0.0.1:$port_lr_dl:$port_lr_dl $download_name_lr_dl
        fi
        echo ""
    else
        echo "Invalid choice."
    fi
}

# Function to manage containers
manage_containers() {
    echo ""
    echo "Managing containers:"
    echo "1. Stop container"
    echo "2. Delete container"
    read -p "Enter your choice (1 or 2): " manage_choice
    echo ""
    
    if [ $manage_choice -eq 1 ]; then
        read -p "Enter name of container: " container_stop
        docker stop $container_stop
        echo "Container $container_stop stopped."
    elif [ $manage_choice -eq 2 ]; then
        read -p "Enter name of container: " container_delete
        docker rm -f /$container_delete
        echo "Container $container_delete deleted."
    else
        echo "Invalid choice."
    fi
}

# Function to show and manage Docker images
manage_images() {
    echo ""
    echo "Managing Docker images:"
    echo "1. Show images"
    echo "2. Delete image"
    read -p "Enter your choice (1 or 2): " image_choice
    echo ""
    
    if [ $image_choice -eq 1 ]; then
        echo "Docker images:"
        docker image ls
        echo ""
    elif [ $image_choice -eq 2 ]; then
        read -p "Enter name of image: " image_delete
        docker rmi $image_delete
        echo "Image $image_delete deleted."
        echo ""
    else
        echo "Invalid choice."
    fi
}

# Main script loop
while true; do
    display_menu
    read -n1 choice
    case $choice in
        1) create_container_dockerfile ;;
        2) create_container_compose ;;
        3) build_container ;;
        4) show_running_containers ;;
        5) upload_container ;;
        6) download_container ;;
        7) manage_containers ;;
        8) manage_images ;;
        9) echo "" && echo "Exiting..." && exit 0 ;;
        *) echo "Invalid choice. Please try again." && sleep 2
    esac
done
