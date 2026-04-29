#include <cuda_runtime.h>
#include <vector>
#include <iostream>
#include "image_utils.h"

__global__ void GrayscaleKernel(const unsigned char* input,
                                unsigned char* gray,
                                int width,
                                int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < width && y < height) {
        int idx = (y * width + x) * 3;
        unsigned char r = input[idx];
        unsigned char g = input[idx + 1];
        unsigned char b = input[idx + 2];

        gray[y * width + x] = (r + g + b) / 3;
    }
}

__global__ void SobelKernel(const unsigned char* input,
                            unsigned char* output,
                            int width,
                            int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x > 0 && y > 0 && x < width - 1 && y < height - 1) {
        int gx = -input[(y-1)*width + (x-1)] - 2*input[y*width + (x-1)] - input[(y+1)*width + (x-1)]
               + input[(y-1)*width + (x+1)] + 2*input[y*width + (x+1)] + input[(y+1)*width + (x+1)];

        int gy = -input[(y-1)*width + (x-1)] - 2*input[(y-1)*width + x] - input[(y-1)*width + (x+1)]
               + input[(y+1)*width + (x-1)] + 2*input[(y+1)*width + x] + input[(y+1)*width + (x+1)];

        output[y * width + x] = min(255, abs(gx) + abs(gy));
    }
}

void ProcessImageCUDA(const std::string& input_path,
                      const std::string& output_path) {
    std::vector<unsigned char> input;
    int width, height;

    if (!LoadImage(input_path, input, width, height)) {
        std::cerr << "Failed to load image: " << input_path << std::endl;
        return;
    }

    unsigned char *d_input, *d_gray, *d_output;

    cudaMalloc(&d_input, input.size());
    cudaMalloc(&d_gray, width * height);
    cudaMalloc(&d_output, width * height);

    cudaMemcpy(d_input, input.data(), input.size(), cudaMemcpyHostToDevice);

    dim3 block(16, 16);
    dim3 grid((width + 15) / 16, (height + 15) / 16);

    GrayscaleKernel<<<grid, block>>>(d_input, d_gray, width, height);
    SobelKernel<<<grid, block>>>(d_gray, d_output, width, height);

    std::vector<unsigned char> output(width * height);
    cudaMemcpy(output.data(), d_output, width * height, cudaMemcpyDeviceToHost);

    SaveImage(output_path, output, width, height);

    cudaFree(d_input);
    cudaFree(d_gray);
    cudaFree(d_output);
}
