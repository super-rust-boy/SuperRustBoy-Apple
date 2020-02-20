#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum {
  rustBoyButtonLeft,
  rustBoyButtonRight,
  rustBoyButtonUp,
  rustBoyButtonDown,
  rustBoyButtonA,
  rustBoyButtonB,
  rustBoyButtonStart,
  rustBoyButtonSelect,
} rustBoyButton;

void rustBoyButtonClickDown(const void *instance, rustBoyButton cButton);

void rustBoyButtonClickUp(const void *instance, rustBoyButton cButton);

const void *rustBoyCreate(const char *cartridgePath, const char *saveFilePath);

void rustBoyDelete(const void *instance);

void rustBoyFrame(const void *instance, uint8_t *buffer, uint32_t length);
