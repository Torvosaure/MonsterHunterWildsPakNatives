pub struct Utils {}

impl Utils {
    pub fn encode_utf16_bytes(s: &str) -> Vec<u8> {
        let u16_vec: Vec<u16> = s.encode_utf16().collect();

        let mut u8_vec: Vec<u8> = vec![];

        for utf16 in &u16_vec {
            u8_vec.extend_from_slice(&utf16.to_le_bytes());
        }

        u8_vec
    }
}
