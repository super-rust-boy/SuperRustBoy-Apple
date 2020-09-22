#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum {
  snesButtonLeft,
  snesButtonRight,
  snesButtonUp,
  snesButtonDown,
  snesButtonA,
  snesButtonB,
  snesButtonX,
  snesButtonY,
  snesButtonStart,
  snesButtonSelect,
  snesButtonL,
  snesButtonR,
} snesButton;

typedef struct {
  uint32_t width;
  uint32_t height;
  uint32_t bytesPerPixel;
  uint32_t fps;
  uint32_t targetWidth;
  uint32_t targetHeight;
} snesFrameInfo;

void snesButtonClickDown(const void *instance, snesButton cButton, uint32_t controller);

void snesButtonClickUp(const void *instance, snesButton cButton, uint32_t controller);

void snesCartName(const void *instance, uint8_t *outBuffer, uint32_t outBufferLen);

const void *snesCreate(const char *cartridgePath, const char *saveFilePath);

void snesDelete(const void *instance);

void snesFrame(const void *instance, uint8_t *buffer, uint32_t length);

snesFrameInfo snesGetFrameInfo(void);
