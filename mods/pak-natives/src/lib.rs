mod pak;
mod structure;
mod utils;

use pak::Pak;
use std::{ffi::c_void, panic};
use windows::{
    core::{self, PCWSTR},
    Win32::{
        Foundation::{BOOL, HINSTANCE, TRUE},
        System::{LibraryLoader::DisableThreadLibraryCalls, SystemServices::DLL_PROCESS_ATTACH},
        UI::WindowsAndMessaging::{MessageBoxW, IDCANCEL, MB_ICONERROR, MB_OKCANCEL},
    },
};

#[allow(clippy::upper_case_acronyms)]
type DWORD = u32;
#[allow(clippy::upper_case_acronyms)]
type LPVOID = *const c_void;

#[no_mangle]
pub extern "stdcall" fn DllMain(handle: HINSTANCE, reason: DWORD, _reserved: LPVOID) -> BOOL {
    unsafe {
        let _ = DisableThreadLibraryCalls(handle);
    };

    if reason == DLL_PROCESS_ATTACH {
        match Pak::create() {
            Ok(_) => {}
            Err(e) => {
                let txt = PCWSTR(e.to_string().encode_utf16().chain([0u16]).collect::<Vec<u16>>().as_ptr());
                let caption = core::w!("PakNatives");
                let utype = MB_OKCANCEL | MB_ICONERROR;

                if unsafe { MessageBoxW(None, txt, caption, utype) } == IDCANCEL {
                    panic!();
                }
            }
        }
    }

    TRUE
}
