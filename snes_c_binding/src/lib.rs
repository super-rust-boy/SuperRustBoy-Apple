use std::ffi::{c_void, CStr, CString};
use std::os::raw::c_char;
use oxide7::{SNES, Button, SNESAudioHandler};
use std::slice;

#[no_mangle]
pub extern fn snesGetFrameInfo() -> snesFrameInfo {
    snesFrameInfo {
        width: 512,
        height: 224,
        bytesPerPixel: 4,
        fps: 60,

        targetWidth: 256,
        targetHeight: 224,
    }
}

#[repr(C)]
#[allow(non_camel_case_types)]
pub struct snesFrameInfo {
    width: u32,
    height: u32,
    bytesPerPixel: u32,
    fps: u32,
    
    targetWidth: u32,
    targetHeight: u32,
}

#[repr(C)]
#[allow(non_camel_case_types)]
pub enum snesButton {
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
}

impl snesButton {
    fn to_button(&self) -> Button {
        use snesButton::*;

        match self {
            snesButtonLeft   => Button::Left,
            snesButtonRight  => Button::Right,
            snesButtonUp     => Button::Up,
            snesButtonDown   => Button::Down,
            snesButtonA      => Button::A,
            snesButtonB      => Button::B,
            snesButtonX      => Button::X,
            snesButtonY      => Button::Y,
            snesButtonStart  => Button::Start,
            snesButtonSelect => Button::Select,
            snesButtonL      => Button::L,
            snesButtonR      => Button::R,
        }
    }
}

#[no_mangle]
pub extern fn snesCreate(cartridge_path: *const c_char, save_file_path: *const c_char) -> *const c_void {

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

    let instance = Box::new(SNES::new(cart_path, save_path, None));

    Box::into_raw(instance) as *const c_void
}

#[no_mangle]
pub unsafe extern fn snesDelete(instance: *const c_void) {
    let snes = instance as *mut SNES;
    snes.drop_in_place();
}

#[no_mangle]
pub unsafe extern fn snesFrame(instance: *const c_void, buffer: *mut u8, length: u32) {
    let snes = instance as *mut SNES;
    if let Some(snes_ref) = snes.as_mut() {

        let mut buffer_slice = slice::from_raw_parts_mut(buffer, length as usize);

        snes_ref.frame(&mut buffer_slice);
    }
}

#[no_mangle]
pub unsafe extern fn snesButtonClickDown(instance: *const c_void, c_button: snesButton, controller: u32) {
    let snes = instance as *mut SNES;
    if let Some(snes_ref) = snes.as_mut() {
        snes_ref.set_button(c_button.to_button(), true, controller as usize);
    }
}

#[no_mangle]
pub unsafe extern fn snesButtonClickUp(instance: *const c_void, c_button: snesButton, controller: u32) {
    let snes = instance as *mut SNES;
    if let Some(snes_ref) = snes.as_mut() {
        snes_ref.set_button(c_button.to_button(), false, controller as usize);
    }
}

#[no_mangle]
pub unsafe extern fn snesCartName(instance: *const c_void, out_buffer: *mut u8, out_buffer_len: u32) {
    let snes = instance as *mut SNES;
    if let Some(snes_ref) = snes.as_ref() {
        let cart_name = snes_ref.rom_name();
        if let Ok(raw_string) = CString::new(cart_name) {
            let raw_bytes = raw_string.as_bytes_with_nul();
            let out_str = slice::from_raw_parts_mut(out_buffer, out_buffer_len as usize);
            out_str[..raw_bytes.len()].copy_from_slice(raw_bytes);
        }
        
    }
}
