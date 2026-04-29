all:
	nvcc -std=c++17 src/main.cpp src/kernels.cu src/image_utils.cpp \
	-o image_processor `pkg-config --cflags --libs opencv4`

clean:
	rm -f image_processor