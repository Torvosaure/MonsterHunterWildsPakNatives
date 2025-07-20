use serde::Serialize;

#[derive(Serialize)]
pub struct Header {
    pub magic: u32,
    pub version: u16,
    pub flags: u16,
    pub entry_count: u32,
    pub unk60: u32,
}
