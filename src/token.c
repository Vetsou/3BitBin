#include "token.h"

//
// PUBLIC
//

token_t token_create(token_type_t t_type, int32_t line, char *literal) {
    return (token_t) {
        .type = t_type,
        .line = line,
        .literal = literal
    };
}