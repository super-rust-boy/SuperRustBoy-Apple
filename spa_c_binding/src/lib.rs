use std::ffi::{c_void, CStr};
use std::os::raw::c_char;
use spa::{GBA, Button};

#[repr(C)]
#[allow(non_camel_case_types)]
pub enum gbaButton {
    gbaButtonLeft,
    gbaButtonRight,
    gbaButtonUp,
    gbaButtonDown,
    gbaButtonA,
    gbaButtonB,
    gbaButtonStart,
    gbaButtonSelect,
    gbaButtonL,
    gbaButtonR
}

impl gbaButton {
    fn to_button(&self) -> Button {
        use gbaButton::*;

        match self {
            gbaButtonLeft   => Button::Left,
            gbaButtonRight  => Button::Right,
            gbaButtonUp     => Button::Up,
            gbaButtonDown   => Button::Down,
            gbaButtonA      => Button::A,
            gbaButtonB      => Button::B,
            gbaButtonStart  => Button::Start,
            gbaButtonSelect => Button::Select,
            gbaButtonL      => Button::L,
            gbaButtonR      => Button::R
        }
    }
}

#[no_mangle]
pub extern fn gbaCreate(cartridge_path: *const c_char) -> *const c_void {

    if cartridge_path.is_null() {
        println!("Cartridge path is null");
        return std::ptr::null();
    }

    let cart_path_result = unsafe { CStr::from_ptr(cartridge_path) };
    let cart_path = match cart_path_result.to_str() {
        Ok(c) => c.to_string(),
        Err(_) => {
            println!("Failed to parse cartridge path");
            return std::ptr::null();
        }
    };

    let path = std::path::Path::new(&cart_path);

    let instance = Box::new(GBA::new(path, Option::None));

    Box::into_raw(instance) as *const c_void
}

#[no_mangle]
pub unsafe extern fn gbaDelete(instance: *const c_void) {
    let gba = instance as *mut GBA;
    gba.drop_in_place();
}

#[no_mangle]
pub unsafe extern fn gbaButtonSetPressed(instance: *const c_void, c_button: gbaButton, pressed: bool) {
    let gba = instance as *mut GBA;
    if let Some(gba_ref) = gba.as_mut() {
        gba_ref.set_button(c_button.to_button(), pressed);
    }
}