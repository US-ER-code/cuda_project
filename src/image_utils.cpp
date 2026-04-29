#include "image_utils.h"
#include <opencv2/opencv.hpp>

bool LoadImage(const std::string& path,
               std::vector<unsigned char>& data,
               int& width,
               int& height) {
    cv::Mat img = cv::imread(path, cv::IMREAD_COLOR);
    if (img.empty()) return false;

    width = img.cols;
    height = img.rows;

    data.assign(img.data, img.data + img.total() * img.channels());
    return true;
}

bool SaveImage(const std::string& path,
               const std::vector<unsigned char>& data,
               int width,
               int height) {
    cv::Mat img(height, width, CV_8UC1, (void*)data.data());
    return cv::imwrite(path, img);
}
