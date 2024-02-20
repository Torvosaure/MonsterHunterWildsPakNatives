mod pak;
mod structure;
mod utils;

use pak::Pak;
use std::{ffi::c_void, panic};
use windows_sys::Win32::{
    Foundation::{BOOL, HINSTANCE, TRUE},
    System::{LibraryLoader::DisableThreadLibraryCalls, SystemServices::DLL_PROCESS_ATTACH},
    UI::WindowsAndMessaging::{MessageBoxW, IDCANCEL, MB_ICONERROR, MB_OKCANCEL},
};

#[allow(clippy::upper_case_acronyms)]
type DWORD = u32;
#[allow(clippy::upper_case_acronyms)]
type LPVOID = *const c_void;

#[no_mangle]
pub extern "stdcall" fn DllMain(handle: HINSTANCE, reason: DWORD, _reserved: LPVOID) -> BOOL {
    unsafe {
        DisableThreadLibraryCalls(handle);
    };

    if reason == DLL_PROCESS_ATTACH {
        match Pak::create() {
            Ok(_) => {}
            Err(e) => {
                let caption = "PakNatives\0".encode_utf16().collect::<Vec<u16>>().as_ptr();
                let txt = (e.to_string() + "\0").as_str().encode_utf16().collect::<Vec<u16>>().as_ptr();
                let utype = MB_OKCANCEL | MB_ICONERROR;

                if unsafe { MessageBoxW(0, txt, caption, utype) } == IDCANCEL {
                    panic!();
                }
            }
        }
    }

    TRUE
}
