use crate::{
    structure::{file_entry::FileEntry, header::Header, magic::Magic, CompressType},
    utils::Utils,
};
use murmurhash3::murmurhash3_x86_32;
use path_slash::PathExt;
use std::{
    env,
    error::Error,
    fs,
    io::{Seek, SeekFrom, Write},
    mem,
    path::PathBuf,
};
use walkdir::WalkDir;

pub struct Pak {}

impl Pak {
    const NATIVES: &'static str = "natives";
    const OUT_FILE: &'static str = "re_chunk_000.pak.sub_000.pak.patch_004.pak";

    pub fn create() -> Result<(), Box<dyn Error>> {
        let exe_path = env::current_exe()?;
        let exe_dir = exe_path.parent().unwrap(); // As long as the path to the executable is returned, the parent directory exists.

        let natives_dir = exe_dir.join(Self::NATIVES);

        if natives_dir.exists() {
            let mut out_file = fs::File::create(exe_dir.join(Self::OUT_FILE))?;

            let files: Vec<PathBuf> = WalkDir::new(natives_dir)
                .into_iter()
                .filter_map(|entry| entry.ok())
                .filter(|entry| entry.file_type().is_file())
                .map(|entry| entry.into_path())
                .collect();

            let header = Header {
                magic: u32::from_ne_bytes(*Magic::PAK),
                version: 4u16,
                flags: 0u16,
                entry_count: files.len() as u32,
                unk60: 0u32,
            };

            out_file.write_all(&bincode::serialize(&header)?)?;

            out_file.seek(SeekFrom::Current((mem::size_of::<FileEntry>() * header.entry_count as usize).try_into()?))?;

            let mut file_entrys: Vec<FileEntry> = vec![];

            for file in &files {
                let rel_path = file
                    .strip_prefix(exe_dir)?
                    .to_slash()
                    .ok_or(format!("{}: Failed to convert the file path into slash path as UTF-8 string.", file.display()))?;

                let file_data = fs::read(file)?;

                let (compress_type, compress_data) = match &file_data[..4] {
                    m if m == Magic::BNK => (CompressType::Store, &file_data),
                    m if m == Magic::PCK => (CompressType::Store, &file_data),
                    _ => (CompressType::Store, &file_data), // TODO: Implement Deflate or Zstd compression.
                };

                let file_entry = FileEntry {
                    file_name_lower_hash: Self::calc_hash(&rel_path.to_lowercase()),
                    file_name_upper_hash: Self::calc_hash(&rel_path.to_uppercase()),
                    offset: out_file.stream_position()?,
                    compressed_size: compress_data.len() as u64,
                    real_size: file.metadata()?.len(),
                    flag: compress_type as u64,
                    unk140: 0u64,
                };

                file_entrys.push(file_entry);

                out_file.write_all(compress_data)?;
            }

            out_file.seek(SeekFrom::Start(mem::size_of::<Header>().try_into()?))?;

            for file_entry in file_entrys {
                out_file.write_all(bincode::serialize(&file_entry)?.as_slice())?;
            }
        }

        Ok(())
    }

    fn calc_hash(path: &str) -> u32 {
        murmurhash3_x86_32(Utils::encode_utf16_bytes(path).as_slice(), u32::MAX)
    }
}
