#include "bmaxdebug.h"

#include <cstdio>
#include <cstring>
#include <cstdarg>

#define MAX_DEBUG_LOG_SIZE	1024

void DebugLog(const char *format,...){
	va_list ap;
	char buf[MAX_DEBUG_LOG_SIZE];

	va_start(ap,format);
	vsprintf(buf,format,ap);
	va_end(ap);

	BBString *bbstr=bbStringFromCString(buf);
	bbOnDebugLog(bbstr);
}