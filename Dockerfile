# Use an official Python runtime as a parent image
FROM python:3.10

RUN apt-get update

RUN apt-get install -y libgdal-dev libgl1-mesa-glx

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install detectron2 and DeepSolo
RUN python -m pip install torch==2.2.2 torchvision==0.17.2 -f https://download.pytorch.org/whl/torch_stable.html
RUN python -m pip install 'git+https://github.com/facebookresearch/detectron2.git'
RUN python -m pip install 'git+https://github.com/maps-as-data/DeepSolo.git'

# Install other packages specified in requirements.txt
RUN python -m pip install -r requirements.txt

# Clone the DeepSolo repository
RUN git clone https://github.com/maps-as-data/DeepSolo.git

# Get the weights file
RUN wget https://huggingface.co/rwood-97/DeepSolo_ic15_res50/resolve/main/ic15_res50_finetune_synth-tt-mlt-13-15-textocr.pth

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Define environment variables
# ENV NAME World

# Run Jupyter Notebook when the container launches
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
