use std::ffi::{c_void, CStr};
use std::os::raw::c_char;
use rustboy::{RustBoy, ROMType, UserPalette, Button, RustBoyAudioHandle};
use std::slice;

#[no_mangle]
pub extern fn rustBoyGetFrameInfo() -> rustBoyFrameInfo {
    rustBoyFrameInfo {
        width: 160,
        height: 144,
        bytesPerPixel: 4
    }
}

#[repr(C)]
pub struct rustBoyFrameInfo {
    width: u32,
    height: u32,
    bytesPerPixel: u32
}

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
        Ok(c) => c.to_string(),
        Err(_) => {
            println!("Failed to parse cartridge path");
            return std::ptr::null();
        }
    };
    
    let rom_type = ROMType::File(cart_path);

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

    let instance = RustBoy::new(rom_type, save_path, UserPalette::Default);

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

#[no_mangle]
pub unsafe extern fn rustBoyGetAudioHandle(instance: *const c_void, sample_rate: u32) -> *const c_void {
    let rust_boy = instance as *mut RustBoy;

    match rust_boy.as_mut() {
        Some(rust_boy_ref) => {
            let audio_handle = Box::new(rust_boy_ref.enable_audio(sample_rate as usize));
            Box::into_raw(audio_handle) as *const c_void
        }
        None => std::ptr::null()
    }
}

#[no_mangle]
pub unsafe extern fn rustBoyDeleteAudioHandle(instance: *const c_void) {
    let audio_handle = instance as *mut RustBoyAudioHandle;
    audio_handle.drop_in_place();
}

#[no_mangle]
pub unsafe extern fn rustBoyGetAudioPacket(instance: *const c_void, buffer: *mut f32, length: u32) {
    let audio_handle = instance as *mut RustBoyAudioHandle;
    if let Some(audio_handle_ref) = audio_handle.as_mut() {
        let mut buffer_slice = slice::from_raw_parts_mut(buffer, length as usize);
        audio_handle_ref.get_audio_packet(&mut buffer_slice)
    }
}
