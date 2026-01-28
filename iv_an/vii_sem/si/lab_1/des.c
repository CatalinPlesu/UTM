//https://people.csail.mit.edu/rivest/pubs/Riv85.txt
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define LB32_MASK   0x00000001
#define LB64_MASK   0x0000000000000001
#define L64_MASK    0x00000000ffffffff
#define H64_MASK    0xffffffff00000000

/* Initial Permutation Table */
const char IP[] = {
    58, 50, 42, 34, 26, 18, 10,  2, 
    60, 52, 44, 36, 28, 20, 12,  4, 
    62, 54, 46, 38, 30, 22, 14,  6, 
    64, 56, 48, 40, 32, 24, 16,  8, 
    57, 49, 41, 33, 25, 17,  9,  1, 
    59, 51, 43, 35, 27, 19, 11,  3, 
    61, 53, 45, 37, 29, 21, 13,  5, 
    63, 55, 47, 39, 31, 23, 15,  7
};

/* Inverse Initial Permutation Table */
const char PI[] = {
    40,  8, 48, 16, 56, 24, 64, 32, 
    39,  7, 47, 15, 55, 23, 63, 31, 
    38,  6, 46, 14, 54, 22, 62, 30, 
    37,  5, 45, 13, 53, 21, 61, 29, 
    36,  4, 44, 12, 52, 20, 60, 28, 
    35,  3, 43, 11, 51, 19, 59, 27, 
    34,  2, 42, 10, 50, 18, 58, 26, 
    33,  1, 41,  9, 49, 17, 57, 25
};

/*Expansion table */
const char E[] = {
    32,  1,  2,  3,  4,  5,  
     4,  5,  6,  7,  8,  9,  
     8,  9, 10, 11, 12, 13, 
    12, 13, 14, 15, 16, 17, 
    16, 17, 18, 19, 20, 21, 
    20, 21, 22, 23, 24, 25, 
    24, 25, 26, 27, 28, 29, 
    28, 29, 30, 31, 32,  1
};

/* Post S-Box permutation */
const char P[] = {
    16,  7, 20, 21, 
    29, 12, 28, 17, 
     1, 15, 23, 26, 
     5, 18, 31, 10, 
     2,  8, 24, 14, 
    32, 27,  3,  9, 
    19, 13, 30,  6, 
    22, 11,  4, 25
};

/* The S-Box tables */
const char S[8][64] = {{
    /* S1 */
    14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,  
     0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,  
     4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0, 
    15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
},{
    /* S2 */
    15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,  
     3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,  
     0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15, 
    13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
},{
    /* S3 */
    10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,  
    13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,  
    13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
     1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
},{
    /* S4 */
     7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,  
    13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,  
    10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
     3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
},{
    /* S5 */
     2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9, 
    14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6, 
     4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14, 
    11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
},{
    /* S6 */
    12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
    10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
     9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
     4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
},{
    /* S7 */
     4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
    13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
     1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
     6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
},{
    /* S8 */
    13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
     1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
     7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
     2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
}};

/* Permuted Choice 1 Table */
const char PC1[] = {
    57, 49, 41, 33, 25, 17,  9,
     1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
    
    63, 55, 47, 39, 31, 23, 15,
     7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4
};

/* Permuted Choice 2 Table */
const char PC2[] = {
    14, 17, 11, 24,  1,  5,
     3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32
};

/* Iteration Shift Array */
const char iteration_shift[] = {
 /* 1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16 */
    1,  1,  2,  2,  2,  2,  2,  2,  1,  2,  2,  2,  2,  2,  2,  1
};

/*
 * The DES function
 * input: 64 bit message
 * key: 64 bit key for encryption/decryption
 * mode: 'e' = encryption; 'd' = decryption
 */

typedef enum 
{
    encrypt = 0,
    decrypt
} desModes;

uint64_t des(uint64_t input, uint64_t key, desModes mode) {
    
    int i, j;
    
    /* 8 bits */
    char row, column;
    
    /* 28 bits */
    uint32_t C                  = 0;
    uint32_t D                  = 0;
    
    /* 32 bits */
    uint32_t L                  = 0;
    uint32_t R                  = 0;
    uint32_t s_output           = 0;
    uint32_t f_function_res     = 0;
    uint32_t temp               = 0;
    
    /* 48 bits */
    uint64_t sub_key[16]        = {0};
    uint64_t s_input            = 0;
    
    /* 56 bits */
    uint64_t permuted_choice_1  = 0;
    uint64_t permuted_choice_2  = 0;
    
    /* 64 bits */
    uint64_t init_perm_res      = 0;
    uint64_t inv_init_perm_res  = 0;
    uint64_t pre_output         = 0;
    
    /* initial permutation */
    for (i = 0; i < 64; i++) {
        
        init_perm_res <<= 1;
        init_perm_res |= (input >> (64-IP[i])) & LB64_MASK;
        
    }
    
    L = (uint32_t) (init_perm_res >> 32) & L64_MASK;
    R = (uint32_t) init_perm_res & L64_MASK;
        
    /* initial key schedule calculation */
    for (i = 0; i < 56; i++) {
        
        permuted_choice_1 <<= 1;
        permuted_choice_1 |= (key >> (64-PC1[i])) & LB64_MASK;

    }
    
    C = (uint32_t) ((permuted_choice_1 >> 28) & 0x000000000fffffff);
    D = (uint32_t) (permuted_choice_1 & 0x000000000fffffff);
    
    /* Calculation of the 16 keys */
    for (i = 0; i< 16; i++) {
        
        /* key schedule */
        // shifting Ci and Di
        for (j = 0; j < iteration_shift[i]; j++) {
            
            C = 0x0fffffff & (C << 1) | 0x00000001 & (C >> 27);
            D = 0x0fffffff & (D << 1) | 0x00000001 & (D >> 27);
            
        }
        
        permuted_choice_2 = 0;
        permuted_choice_2 = (((uint64_t) C) << 28) | (uint64_t) D ;
        
        sub_key[i] = 0;
        
        for (j = 0; j < 48; j++) {
            
            sub_key[i] <<= 1;
            sub_key[i] |= (permuted_choice_2 >> (56-PC2[j])) & LB64_MASK;
            
        }
        
    }
    
    for (i = 0; i < 16; i++) {
        
        /* f(R,k) function */
        s_input = 0;
        
        for (j = 0; j< 48; j++) {
            
            s_input <<= 1;
            s_input |= (uint64_t) ((R >> (32-E[j])) & LB32_MASK);
            
        }
        
        /* 
         * Encryption/Decryption 
         * XORing expanded Ri with Ki
         */
        if (mode == decrypt) {
            // decryption
            s_input = s_input ^ sub_key[15-i];
            
        } else {
            // encryption
            s_input = s_input ^ sub_key[i];
            
        }
        
        /* S-Box Tables */
        for (j = 0; j < 8; j++) {
            
            row = (char) ((s_input & (0x0000840000000000 >> 6*j)) >> 42-6*j);
            row = (row >> 4) | row & 0x01;
            
            column = (char) ((s_input & (0x0000780000000000 >> 6*j)) >> 43-6*j);
            
            s_output <<= 4;
            s_output |= (uint32_t) (S[j][16*row + column] & 0x0f);
            
        }
        
        f_function_res = 0;
        
        for (j = 0; j < 32; j++) {
            
            f_function_res <<= 1;
            f_function_res |= (s_output >> (32 - P[j])) & LB32_MASK;
            
        }
        
        temp = R;
        R = L ^ f_function_res;
        L = temp;
        
    }
    
    pre_output = (((uint64_t) R) << 32) | (uint64_t) L;
        
    /* inverse initial permutation */
    for (i = 0; i < 64; i++) {
        
        inv_init_perm_res <<= 1;
        inv_init_perm_res |= (pre_output >> (64-PI[i])) & LB64_MASK;
        
    }
    
    return inv_init_perm_res;
    
}

void vDoMainTest()
{
    uint64_t result = 0x9474B8E8C73BCA7D;

    // Array of expected values
    uint64_t expected_values[] = {
        0x8DA744E0C94E5E17,
        0x0CDB25E3BA3C6D79,
        0x4784C4BA5006081F,
        0x1CF1FC126F2EF842,
        0xE4BE250042098D13,
        0x7BFC5DC6ADB5797C,
        0x1AB3B4D82082FB28,
        0xC1576A14DE707097,
        0x739B68CD2E26782A,
        0x2A59F0C464506EDB,
        0xA5C39D4251F0A81E,
        0x7239AC9A6107DDB1,
        0x070CAC8590241233,
        0x78F87B6E3DFECF61,
        0x95EC2578C2C433F0,
        0x1B1A2DDB4C642438
    };

    printf("Round 0: ");
    printf("%lx\n", result);

    int i;
    for (i = 1; i <= 16; i++) {
        printf("Round %d: ", i);
        if (i % 2 == 1) {
            result = des(result, 0, encrypt); // Encryption
            printf("%x\n", result);
        } else {
            result = des(result, result, decrypt); // Decryption
        }
        printf("%lx\n", result);

        // Compare with the expected value
        if (result != expected_values[i - 1]) {
            printf("Error: Round %d result does not match expected value.\n", i);
            return; // Exit with an error code
        }
    }

    printf("All rounds passed.\n");
    return;
}

char ** pacDoEncryptString(char *str, uint64_t key, uint64_t len)
{
    // Process the string in 8-byte blocks
    char *strPadded = (char*)calloc((len+7)/8 * 8, 1);
    memcpy(strPadded, str, len);
    uint64_t block;
    for (int i = 0; i < (len+7)/8 * 8; i += 8) {
        memcpy(&block, strPadded + i, 8); // Get the next 8 bytes from the string
        block = des(block, key, encrypt); // Encrypt the block using DES
        memcpy(strPadded + i, &block, 8); // Replace the original block with the encrypted block
    }
    return strPadded;
}

void vDoDecryptString(char *str, uint64_t key, uint64_t len) {
    if (len % 8 != 0) {
        printf("Error: String length must be a multiple of 8.\n");
        return;
    }

    // Process the string in 8-byte blocks
    uint64_t block;
    for (int i = 0; i < len; i += 8) {
        memcpy(&block, str + i, 8); // Get the next 8 bytes from the string
        block = des(block, key, decrypt); // Decrypt the block using DES
        memcpy(str + i, &block, 8); // Replace the original block with the decrypted block
    }
}

int main() {
    vDoMainTest();

    char text[] = "TestRabbit12345";
    uint64_t len = sizeof(text)/sizeof(char);
    uint64_t paddedLen = (len+7)/8 * 8;
    uint64_t key = 0xabcdef;

    char *padded = pacDoEncryptString(&text, key, len);
    // Print the encrypted data in hex format
    printf("Encrypted (Hex): ");
    for (int i = 0; i < paddedLen; i++) {
        printf("%02X", (unsigned char)padded[i]);
    }
    printf("\n");

    vDoDecryptString(padded, key, paddedLen);

    // Print the decrypted data
    printf("Decrypted: %s\n", padded);

    free(padded);


    return 0;
}