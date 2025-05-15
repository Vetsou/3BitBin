#ifndef _LEXER_H_
#define _LEXER_H_

#include "types.h"
#include "token.h"

typedef enum {
    LEXER_OK = 0,
    LEXER_INVALID_CHAR,
    LEXER_WRONG_SPACE_FORMAT
} lexer_result_t;

typedef struct {
    char *curr_char;
    char *tok_start;
    char *chunk;
    size_t chunk_len;
    int32_t curr_line;
} lexer_t;

void lexer_init(lexer_t *lexer, char *chunk, size_t len);
token_t lexer_scan(lexer_t *lexer);
void lexer_free(lexer_t *lexer);

#endif // _LEXER_H_