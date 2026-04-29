#ifndef IMAGE_UTILS_H_
#define IMAGE_UTILS_H_

#include <string>
#include <vector>

bool LoadImage(const std::string& path,
               std::vector<unsigned char>& data,
               int& width,
               int& height);

bool SaveImage(const std::string& path,
               const std::vector<unsigned char>& data,
               int width,
               int height);

#endif
