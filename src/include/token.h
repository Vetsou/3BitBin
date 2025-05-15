#ifndef _TOKEN_H_
#define _TOKEN_H_

#include "types.h"

typedef enum {
    TOK_EOF = 0, TOK_ERROR,
} token_type_t;

typedef struct {
    token_type_t type;
    int32_t line;
    char *literal;
} token_t;

token_t token_create(token_type_t t_type, int32_t line, char *literal);

#endif // _TOKEN_H_