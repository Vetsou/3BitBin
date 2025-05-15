#include "lexer.h"
#include <stdlib.h>

// Lexer error messages
#define ERR_INVALID_INDENT_CHAR "Tabs and vertical tabs are not allowed for indentation."
#define ERR_BAD_INDENT_SPACES   "Leading spaces must be a multiple of 4."
#define ERR_GENERIC_UNEXPECTED  "Unexpected character."

//
// PRIVATE
//

static inline char _peek_curr(lexer_t *lexer) {
    return *lexer->curr_char;
}

static inline bool _is_file_end(lexer_t *lexer) {
    return *lexer->curr_char == '\0';
}

static lexer_result_t _skip_leading_whitespace(lexer_t *lexer) {
    int32_t spaces = 0;

    while (true) {
        switch(_peek_curr(lexer)) {
            case ' ': case '\r':
                spaces++;
                lexer->curr_char++;
                break;
            case '\n':
                spaces = 0;
                lexer->curr_line++;
                lexer->curr_char++;
                break;
            case '\t': case '\v':
                return LEXER_INVALID_CHAR;
            default:
                if (spaces % 4 != 0) return LEXER_WRONG_SPACE_FORMAT;
                return LEXER_OK;
        }
    }
}

//
// PUBLIC
//

void lexer_init(lexer_t *lexer, char *chunk, size_t len) {
    *lexer = (lexer_t) {
        .curr_char = chunk,
        .tok_start = chunk,
        .chunk = chunk,
        .chunk_len = len,
        .curr_line = 1
    };
}

token_t lexer_scan(lexer_t *lexer) {
    switch(_skip_leading_whitespace(lexer)) {
        case LEXER_INVALID_CHAR:       return token_create(TOK_ERROR, lexer->curr_line, ERR_INVALID_INDENT_CHAR);
        case LEXER_WRONG_SPACE_FORMAT: return token_create(TOK_ERROR, lexer->curr_line, ERR_BAD_INDENT_SPACES);
        default: // OK
    }

    return token_create(TOK_ERROR, lexer->curr_line, ERR_GENERIC_UNEXPECTED);
}

void lexer_free(lexer_t *lexer) {
    free(lexer->chunk);
    lexer->chunk = NULL;

    lexer = NULL;
}