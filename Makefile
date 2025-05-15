# Compiler and flags
CC = gcc
CFLAGS = -std=c99 -Isrc/include -m64 -fanalyzer -Wall -Wextra -Wno-format

# Paths
SRC_DIR = src
OBJ_DIR = out

# Files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))
DEPS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.d, $(SRCS))
TARGET = $(OBJ_DIR)/3BitBin



.PHONY: run

-include $(DEPS)

build: $(TARGET)

run: $(TARGET)
	$(TARGET) example/test.tbb

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@