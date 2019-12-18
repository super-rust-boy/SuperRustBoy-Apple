use std::ffi::{c_void, CStr};
use std::os::raw::c_char;
use rustboy::{RustBoy, UserPalette, VulkanRenderer, WindowType, Buttons};
use winit::EventsLoop;

#[repr(C)]
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

#[no_mangle]
pub extern fn rustBoyCreate(cartridge_path: *const c_char, save_file_path: *const c_char) -> *const c_void {

	if cartridge_path.is_null() {
		println!("Cartridge path is null");
		return std::ptr::null()
	}

	let cart_path_result = unsafe { CStr::from_ptr(cartridge_path) };
	let cart_path = match cart_path_result.to_str() {
		Ok(c) => c,
		Err(_) => {
			println!("Failed to parse cartridge path");
			return std::ptr::null()
		}
	};

	if save_file_path.is_null() {
		println!("Save file path is null");
		return std::ptr::null()
	}

	let save_path_result = unsafe { CStr::from_ptr(save_file_path) };
	let save_path = match save_path_result.to_str() {
		Ok(c) => c,
		Err(_) => {
			println!("Failed to parse save file path");
			return std::ptr::null()
		}
	};

	let events_loop = EventsLoop::new();
	let renderer = VulkanRenderer::new(WindowType::Winit(&events_loop));
	let instance = RustBoy::new(cart_path, save_path, UserPalette::Default, false, renderer);

	Box::into_raw(instance) as *const c_void
}

#[no_mangle]
pub extern fn rustBoyDelete(instance: *const c_void) {

}

#[no_mangle]
pub extern fn rustBoyButtonClickDown(instance: *const c_void, button: rustBoyButton) {
	let mut rustboy = unsafe { Box::from_raw(instance as *mut RustBoy) };

	rustboy.set_button(Buttons::SELECT, true);
}

#[no_mangle]
pub extern fn rustBoyButtonClickUp(instance: *const c_void, button: rustBoyButton) {
	let mut rustboy = unsafe { Box::from_raw(instance as *mut RustBoy) };

	rustboy.set_button(Buttons::SELECT, false);
}
