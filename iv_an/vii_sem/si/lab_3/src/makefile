# Define the compiler and compiler flags
CC = gcc
CFLAGS = -lm -lssl -lcrypto

# Define the target name for the executable
TARGET = dsa.run

# Define the source file
SRC = main.c

# Define key file names
PRIVATE_KEY = private.pem
PUBLIC_KEY = public.pem

MESSAGE = message
SIGNATURE = message_signature

# Default target: Build the executable
$(TARGET): $(SRC)
	$(CC) $(SRC) $(CFLAGS) -o $(TARGET)

# Rule to sign a message
sign: $(TARGET) $(PRIVATE_KEY) $(PUBLIC_KEY)
	./$(TARGET) sign $(MESSAGE) $(PRIVATE_KEY) $(SIGNATURE)

# Rule to verify a signature
check: $(TARGET) $(PUBLIC_KEY)
	./$(TARGET) verify $(MESSAGE) $(PUBLIC_KEY) $(SIGNATURE)

# Rule to generate a private key
$(PRIVATE_KEY):
	openssl genpkey -algorithm RSA -out $(PRIVATE_KEY)

# Rule to generate a public key
$(PUBLIC_KEY): $(PRIVATE_KEY)
	openssl rsa -pubout -in $(PRIVATE_KEY) -out $(PUBLIC_KEY)

# Clean rule to remove generated files
clean:
	rm -f $(TARGET) $(SIGNATURE) $(PRIVATE_KEY) $(PUBLIC_KEY)

.PHONY: sign check clean
