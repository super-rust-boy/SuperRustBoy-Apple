#include <stdbool.h>
#include <stdint.h>

typedef enum gbaButton {
  gbaButtonLeft,
  gbaButtonRight,
  gbaButtonUp,
  gbaButtonDown,
  gbaButtonA,
  gbaButtonB,
  gbaButtonStart,
  gbaButtonSelect,
  gbaButtonL,
  gbaButtonR,
} gbaButton;

typedef struct gbaRenderSize {
    uint32_t width;
    uint32_t height;
} gbaRenderSize;

const void* gbaCreate(const char* biosPath, const char* cartridgePath);

void gbaDelete(const void* instance);

gbaRenderSize gbaFetchRenderSize(const void* instance);

void gbaButtonSetPressed(const void* instance, enum gbaButton cButton, bool pressed);

void gbaFrame(const void* instance, uint8_t* buffer, uint32_t length);
