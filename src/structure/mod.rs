pub mod file_entry;
pub mod header;
pub mod magic;

pub enum CompressType {
    Store,
    Deflate,
    Zstd,
}
