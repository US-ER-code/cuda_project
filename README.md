# GPU-Accelerated Image Processing using CUDA

## Overview

This project implements a high-performance image processing pipeline using CUDA to accelerate computation on a GPU. The system processes over 100 real-world images and applies grayscale conversion and Sobel edge detection using custom CUDA kernels.

## Motivation

Traditional CPU-based image processing is slow when applied to large datasets. This project demonstrates how GPU parallelism significantly improves performance for pixel-wise operations.

## Implementation Details

* Language: C++ with CUDA
* Libraries: OpenCV for image I/O
* GPU Kernels:

  * Grayscale conversion
  * Sobel edge detection

Each pixel is processed in parallel using CUDA threads organized in a 2D grid.

## How to Run

```bash
make
./image_processor data/input data/output
```

## Results

* Dataset: 120 real images
* GPU execution achieved ~5–6x speedup over CPU

## Proof of Execution

* Output images stored in `/data/output`
* Logs stored in `/results/logs.txt`
* Screenshots included in `/results/screenshots`

## Challenges

* Managing memory transfers between CPU and GPU
* Correct indexing in CUDA kernels
* Integrating OpenCV with CUDA compilation

## Conclusion

This project demonstrates that GPU acceleration is highly effective for large-scale image processing tasks.
