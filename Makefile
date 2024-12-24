# Compiler and flags
CXX=g++
CXXFLAGS=-Wall -Wextra -std=c++17 -I$(SRC_DIR) -I$(TST_DIR)
LDFLAGS=

# Directories
SRC_DIR=src
TST_DIR=tst
BUILD_DIR=build

# Files
SRC_FILES=$(wildcard $(SRC_DIR)/*.cpp)
TST_FILES=$(wildcard $(TST_DIR)/*.cpp)
OBJ_FILES=$(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRC_FILES))
OBJ_FILES_NO_MAIN=$(filter-out $(BUILD_DIR)/main.o, $(OBJ_FILES))
TST_OBJ_FILES=$(patsubst $(TST_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(TST_FILES))

# Targets
EXEC=./program
TEST_EXEC=./program_test

.PHONY: all clean run tests

# Default target
all: $(EXEC) $(TEST_EXEC)

# Ensure the build directory exists
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Build the main program
$(EXEC): $(OBJ_FILES)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Build the tests
$(TEST_EXEC): $(OBJ_FILES_NO_MAIN) $(TST_OBJ_FILES)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/%.o: $(TST_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Run the main program
run: $(EXEC)
	@$(EXEC)

# Run the tests
test: $(TEST_EXEC)
	@$(TEST_EXEC)

# Clean up build artifacts
clean:
	@rm -rf $(BUILD_DIR) $(EXEC) $(TEST_EXEC)
	@echo "Cleaned build files."
