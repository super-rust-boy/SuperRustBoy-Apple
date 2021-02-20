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

const void* gbaCreate(const char* cartridgePath);

void gbaDelete(const void* instance);

void gbaButtonSetPressed(const void* instance, enum gbaButton cButton, bool pressed);
