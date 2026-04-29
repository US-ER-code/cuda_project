#include <chrono>
#include <filesystem>
#include <iostream>

namespace fs = std::filesystem;

void ProcessImageCUDA(const std::string& input_path,
                      const std::string& output_path);

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cout << "Usage: ./image_processor <input_dir> <output_dir>\n";
        return 1;
    }

    std::string input_dir = argv[1];
    std::string output_dir = argv[2];

    auto start = std::chrono::high_resolution_clock::now();

    int count = 0;
    for (const auto& entry : fs::directory_iterator(input_dir)) {
        std::string input_path = entry.path().string();
        std::string output_path = output_dir + "/" + entry.path().filename().string();

        ProcessImageCUDA(input_path, output_path);
        count++;
    }

    auto end = std::chrono::high_resolution_clock::now();

    std::cout << "Processed " << count << " images\n";
    std::cout << "Execution time: "
              << std::chrono::duration<double>(end - start).count()
              << " seconds\n";

    return 0;
}
