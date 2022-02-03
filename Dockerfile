# Specify the base image
FROM tensorflow/tensorflow:2.7.0

# Update the package manager and install a simple module. The RUN command
# will execute a command on the container and then save a snapshot of the
# results. The last of these snapshots will be the final image
RUN apt-get update -y && apt-get install -y zip graphviz wget \
    gcc g++ gfortran liblapack3 libtbb2 libcliquer1 libopenblas-dev libgsl23

# Make sure the contents of our repo are in /app
COPY . /app

# Install the SCIP solver
RUN dpkg -i /app/dependencies/SCIPOptSuite-8.0.0-Linux-ubuntu.deb

# Install additional Python packages
RUN pip install --upgrade pip
RUN pip install jupyter pandas sklearn matplotlib ipympl ortools pydot \
    RISE jupyter_contrib_nbextensions tables pyscipopt
RUN jupyter contrib nbextension install --system

# Specify working directory
WORKDIR /app/notebooks

# Use CMD to specify the starting command
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", \
     "--ip=0.0.0.0", "--allow-root"]
