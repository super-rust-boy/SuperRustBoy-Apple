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

rustBoyFrameInfo rustBoyGetFrameInfo(void);

void rustBoyButtonClickDown(const void* instance, rustBoyButton button);

void rustBoyButtonClickUp(const void* instance, rustBoyButton button);

const void* rustBoyCreate(const char* cartridgePath, const char* saveFilePath);

void rustBoyDelete(const void* instance);

void rustBoyFrame(const void* instance, uint8_t* buffer, uint32_t length);

const void* rustBoyGetAudioHandle(const void* instance, uint32_t sampleRate);

void rustBoyDeleteAudioHandle(const void* instance);

void rustBoyGetAudioPacket(const void* instance, float* buffer, uint32_t length);
