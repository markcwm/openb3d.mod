#ifndef BMAXDEBUG_H
#define BMAXDEBUG_H

typedef void BBString;

extern "C"{
BBString *bbStringFromCString(const char *p);
extern void (*bbOnDebugLog)(BBString *str);
}
//#include <brl.mod/blitz.mod/blitz_debug.h>

void DebugLog(const char *format,...);

#endif // BMAXBEBUG_H

