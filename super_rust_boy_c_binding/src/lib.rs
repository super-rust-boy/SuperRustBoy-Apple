use std::ffi::{c_void, CStr};
use std::os::raw::c_char;
use rustboy::{RustBoy, UserPalette, Button};
use std::slice;

#[repr(C)]
#[allow(non_camel_case_types)]
pub enum rustBoyButton {
    rustBoyButtonLeft,
    rustBoyButtonRight,
    rustBoyButtonUp,
    rustBoyButtonDown,
    rustBoyButtonA,
    rustBoyButtonB,
    rustBoyButtonStart,
    rustBoyButtonSelect
}

impl rustBoyButton {
    fn to_button(&self) -> Button {
        use rustBoyButton::*;

        match self {
            rustBoyButtonLeft   => Button::Left,
            rustBoyButtonRight  => Button::Right,
            rustBoyButtonUp     => Button::Up,
            rustBoyButtonDown   => Button::Down,
            rustBoyButtonA      => Button::A,
            rustBoyButtonB      => Button::B,
            rustBoyButtonStart  => Button::Start,
            rustBoyButtonSelect => Button::Select,
        }
    }
}

#[no_mangle]
pub extern fn rustBoyCreate(cartridge_path: *const c_char, save_file_path: *const c_char) -> *const c_void {

    if cartridge_path.is_null() {
        println!("Cartridge path is null");
        return std::ptr::null();
    }

    let cart_path_result = unsafe { CStr::from_ptr(cartridge_path) };
    let cart_path = match cart_path_result.to_str() {
        Ok(c) => c,
        Err(_) => {
            println!("Failed to parse cartridge path");
            return std::ptr::null();
        }
    };

    if save_file_path.is_null() {
        println!("Save file path is null");
        return std::ptr::null();
    }

    let save_path_result = unsafe { CStr::from_ptr(save_file_path) };
    let save_path = match save_path_result.to_str() {
        Ok(c) => c,
        Err(_) => {
            println!("Failed to parse save file path");
            return std::ptr::null();
        }
    };

    let instance = RustBoy::new(cart_path, save_path, UserPalette::Default, false);

    Box::into_raw(instance) as *const c_void
}

#[no_mangle]
pub unsafe extern fn rustBoyDelete(instance: *const c_void) {
    let rust_boy = instance as *mut RustBoy;
    rust_boy.drop_in_place();
}

#[no_mangle]
pub unsafe extern fn rustBoyFrame(instance: *const c_void, buffer: *mut u8, length: u32) {
    let rust_boy = instance as *mut RustBoy;
    if let Some(rust_boy_ref) = rust_boy.as_mut() {

        let mut buffer_slice = slice::from_raw_parts_mut(buffer, length as usize);

        rust_boy_ref.frame(&mut buffer_slice);
    }
}

#[no_mangle]
pub unsafe extern fn rustBoyButtonClickDown(instance: *const c_void, c_button: rustBoyButton) {
    let rust_boy = instance as *mut RustBoy;
    if let Some(rust_boy_ref) = rust_boy.as_mut() {
        rust_boy_ref.set_button(c_button.to_button(), true);
    }
}

#[no_mangle]
pub unsafe extern fn rustBoyButtonClickUp(instance: *const c_void, c_button: rustBoyButton) {
    let rust_boy = instance as *mut RustBoy;
    if let Some(rust_boy_ref) = rust_boy.as_mut() {
        rust_boy_ref.set_button(c_button.to_button(), false);
    }
}
