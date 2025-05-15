# Paths
SRC_DIR = src
OBJ_DIR = out
VENDOR_DIR = vendor
TEST_DIR = test

# Source files
SRCS = $(wildcard $(SRC_DIR)/*.c)
APP_SRCS = $(filter-out $(SRC_DIR)/main.c, $(SRCS))
APP_OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(APP_SRCS))
MAIN_OBJ = $(OBJ_DIR)/main.o

DEPS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.d, $(SRCS))
TARGET = $(OBJ_DIR)/3BitBin

# Test files
TEST_SRCS = $(wildcard $(TEST_DIR)/*.c)
TEST_OBJS = $(patsubst $(TEST_DIR)/%.c, $(OBJ_DIR)/%.o, $(TEST_SRCS))
TEST_TARGET = $(TEST_BIN)/3BitBin_test

# Unity testing library
UNITY_SRC = $(VENDOR_DIR)/unity.c
UNITY_OBJ = $(OBJ_DIR)/unity.o

# Compiler and flags
CC = gcc
CFLAGS = -std=c99 -I$(SRC_DIR)/include -m64 -fanalyzer -Wall -Wextra -Wno-format
TEST_CFLAGS = -std=c99 -I$(SRC_DIR)/include -I$(VENDOR_DIR) -m64 -fanalyzer -Wall -Wextra -Wno-format
##############################
# COMMANDS
##############################

.PHONY: build run test setup run-test

-include $(DEPS)

setup:
ifeq ($(OS),Windows_NT)
	@if not exist "$(OBJ_DIR)" mkdir "$(OBJ_DIR)"
else
	@mkdir -p "$(OBJ_DIR)"
endif

build: setup $(TARGET)

run: setup $(TARGET)
	$(TARGET) example/test.tbb

test: setup $(TEST_TARGET)

run-test: setup $(TEST_TARGET)
	$(TEST_TARGET)

##############################
# RULES
##############################

# Target
$(TARGET): $(APP_OBJS) $(MAIN_OBJ)
	$(CC) $(CFLAGS) -o $@ $^

# Objects
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Test target
$(TEST_TARGET): $(TEST_OBJS) $(APP_OBJS) $(UNITY_OBJ)
	$(CC) $(TEST_CFLAGS) -o $@ $^

# Test objects
$(OBJ_DIR)/%.o: $(TEST_DIR)/%.c
	$(CC) $(TEST_CFLAGS) -c $< -o $@

# Vendor objects
$(OBJ_DIR)/unity.o: $(UNITY_SRC)
	$(CC) $(TEST_CFLAGS) -c $< -o $@