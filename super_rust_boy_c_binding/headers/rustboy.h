#include <stdbool.h>
#include <stdint.h>

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

typedef struct {
  uint32_t width;
  uint32_t height;
  uint32_t bytesPerPixel;
} rustBoyFrameInfo;

void rustBoyButtonClickDown(const void* instance, rustBoyButton button);

void rustBoyButtonClickUp(const void* instance, rustBoyButton button);

const void* rustBoyCreate(const char* cartridgePath, const char* saveFilePath, bool mute);

void rustBoyDelete(const void* instance);

void rustBoyFrame(const void* instance, uint8_t* buffer, uint32_t length);

rustBoyFrameInfo rustBoyGetFrameInfo(void);
