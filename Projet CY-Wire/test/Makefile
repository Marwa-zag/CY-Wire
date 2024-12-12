# Variables
CC = gcc
CFLAGS = -Wall -Wextra -g
LDFLAGS =
SOURCES = progC/main.c progC/avl.c
HEADERS = 
TARGET = c-wire

# Règles
build all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)

clean:
	rm -f $(TARGET) *.o

.PHONY: all clean

