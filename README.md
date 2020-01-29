# SuperRustBoy-Apple

iOS and macOS clients for [super-rust-boy](https://github.com/coopersimon/super-rust-boy)

# Building and running for iOS

1. Clone repo
2. Open `SuperRustBoy.xcworkspace`
3. Build and run target `SuperRustBoy-iOS`

# Building and running for macOS

## Prerequisites 

* Rust and cargo installed (TLDR; Run `curl https://sh.rustup.rs -sSf | sh` in terminal)
* MoltenVK installed (TLDR; [Downloads page](https://vulkan.lunarg.com/sdk/home))

### Steps

1. Clone repo
2. Open the terminal and run `cargo install cargo-xcode`
3. Navigate to folder `super_rust_boy_c_binding` in the terminal
4. Run `cargo xcode`. This will generate the Xcode project for the C-Bindings
5. Install `cbindgen` by calling `cargo install cbindgen`
6. While still in the folder `super_rust_boy_c_binding` run `cbindgen --config cbindgen.toml --crate rustboy_c_binding --output headers/rustboy.h`
7. Open `SuperRustBoy.xcworkspace`
8. Build and run target `SuperRustBoy`