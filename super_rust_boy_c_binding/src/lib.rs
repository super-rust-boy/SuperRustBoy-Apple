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
pub unsafe extern fn rustBoyDelete(instance: *const c_void) {
    let rust_boy = instance as *mut RustBoy;
    rust_boy.drop_in_place();
}

#[no_mangle]
pub unsafe extern fn rustBoyButtonClickDown(instance: *const c_void, button: rustBoyButton) {
    let rust_boy = instance as *mut RustBoy;
    if let Some(rust_boy_ref) = rust_boy.as_mut() {
        rust_boy_ref.set_button(button_for_rust_boy_button(button), true);
    }
}

#[no_mangle]
pub unsafe extern fn rustBoyButtonClickUp(instance: *const c_void, button: rustBoyButton) {
    let rust_boy = instance as *mut RustBoy;
    if let Some(rust_boy_ref) = rust_boy.as_mut() {
        rust_boy_ref.set_button(button_for_rust_boy_button(button), false);
    }
}

fn button_for_rust_boy_button(button: rustBoyButton) -> Buttons {
	match button {
		rustBoyButton::rustBoyButtonLeft => Buttons::A,
		rustBoyButton::rustBoyButtonRight => Buttons::A,
		rustBoyButton::rustBoyButtonUp => Buttons::A,
		rustBoyButton::rustBoyButtonDown => Buttons::A,

		rustBoyButton::rustBoyButtonA => Buttons::A,
		rustBoyButton::rustBoyButtonB => Buttons::B,
		rustBoyButton::rustBoyButtonStart => Buttons::START,
		rustBoyButton::rustBoyButtonSelect => Buttons::SELECT
	}
}
