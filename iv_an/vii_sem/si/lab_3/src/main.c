#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/sha.h>
#include <openssl/evp.h>

int sign(const char* private_key_file, const char* message_file, const char* signature_file) {
    FILE *key_file = fopen(private_key_file, "r");
    if (!key_file) {
        perror("Unable to open private key file");
        return 1;
    }

    FILE *message = fopen(message_file, "rb");
    if (!message) {
        perror("Unable to open message file");
        fclose(key_file);
        return 1;
    }

    FILE *signature = fopen(signature_file, "wb");
    if (!signature) {
        perror("Unable to create signature file");
        fclose(key_file);
        fclose(message);
        return 1;
    }

    EVP_PKEY *pkey = PEM_read_PrivateKey(key_file, NULL, NULL, NULL);
    if (!pkey) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(message);
        fclose(signature);
        return 1;
    }

    unsigned char digest[SHA256_DIGEST_LENGTH];
    SHA256_CTX sha256;
    SHA256_Init(&sha256);

    unsigned char buffer[1024];
    size_t bytes_read;

    while ((bytes_read = fread(buffer, 1, sizeof(buffer), message)) > 0) {
        SHA256_Update(&sha256, buffer, bytes_read);
    }

    SHA256_Final(digest, &sha256);

    fclose(message);

    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (EVP_DigestSignInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    if (EVP_DigestSignUpdate(mdctx, digest, SHA256_DIGEST_LENGTH) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    size_t signature_length;
    if (EVP_DigestSignFinal(mdctx, NULL, &signature_length) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    unsigned char* signature_value = (unsigned char*)malloc(signature_length);
    if (!signature_value) {
        perror("Memory allocation error");
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    if (EVP_DigestSignFinal(mdctx, signature_value, &signature_length) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        free(signature_value);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    fwrite(signature_value, 1, signature_length, signature);

    fclose(key_file);
    fclose(signature);
    free(signature_value);
    EVP_PKEY_free(pkey);
    EVP_MD_CTX_free(mdctx);

    return 0;
}

int verify(const char* public_key_file, const char* message_file, const char* signature_file) {
    FILE *key_file = fopen(public_key_file, "r");
    if (!key_file) {
        perror("Unable to open public key file");
        return 1;
    }

    FILE *message = fopen(message_file, "rb");
    if (!message) {
        perror("Unable to open message file");
        fclose(key_file);
        return 1;
    }

    FILE *signature = fopen(signature_file, "rb");
    if (!signature) {
        perror("Unable to open signature file");
        fclose(key_file);
        fclose(message);
        return 1;
    }

    EVP_PKEY *pkey = PEM_read_PUBKEY(key_file, NULL, NULL, NULL);
    if (!pkey) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(message);
        fclose(signature);
        return 1;
    }

    unsigned char digest[SHA256_DIGEST_LENGTH];
    SHA256_CTX sha256;
    SHA256_Init(&sha256);

    unsigned char buffer[1024];
    size_t bytes_read;

    while ((bytes_read = fread(buffer, 1, sizeof(buffer), message)) > 0) {
        SHA256_Update(&sha256, buffer, bytes_read);
    }

    SHA256_Final(digest, &sha256);

    fclose(message);

    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (EVP_DigestVerifyInit(mdctx, NULL, EVP_sha256(), NULL, pkey) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    if (EVP_DigestVerifyUpdate(mdctx, digest, SHA256_DIGEST_LENGTH) <= 0) {
        ERR_print_errors_fp(stderr);
        fclose(key_file);
        fclose(signature);
        EVP_PKEY_free(pkey);
        EVP_MD_CTX_free(mdctx);
        return 1;
    }

    unsigned char signature_value[4096];
    size_t signature_length = fread(signature_value, 1, sizeof(signature_value), signature);

    int verify_result = EVP_DigestVerifyFinal(mdctx, signature_value, signature_length);

    fclose(key_file);
    fclose(signature);
    EVP_PKEY_free(pkey);
    EVP_MD_CTX_free(mdctx);

    if (verify_result == 1) {
        printf("Signature verified successfully.\n");
        return 0;
    } else {
        printf("Signature verification failed.\n");
        return 1;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 5) {
        printf("Usage: %s <sign|verify> <message_file> <key_file> <signature_file>\n", argv[0]);
        return 1;
    }

    const char* mode = argv[1];
    const char* message_file = argv[2];
    const char* key_file = argv[3];
    const char* signature_file = argv[4];

    if (strcmp(mode, "sign") == 0) {
        return sign(key_file, message_file, signature_file);
    } else if (strcmp(mode, "verify") == 0) {
        return verify(key_file, message_file, signature_file);
    } else {
        printf("Invalid mode. Use 'sign' or 'verify'.\n");
        return 1;
    }
}
