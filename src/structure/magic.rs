pub struct Magic {}

impl Magic {
    pub const PAK: &'static [u8; 4] = b"KPKA";
    pub const BNK: &'static [u8; 4] = b"BKHD";
    pub const PCK: &'static [u8; 4] = b"AKPK";
}
