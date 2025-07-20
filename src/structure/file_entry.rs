use serde::Serialize;

#[derive(Serialize)]
pub struct FileEntry {
    pub file_name_lower_hash: u32,
    pub file_name_upper_hash: u32,
    pub offset: u64,
    pub compressed_size: u64,
    pub real_size: u64,
    pub flag: u64,
    pub unk140: u64,
}
