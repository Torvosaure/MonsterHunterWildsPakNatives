#pragma once

#include <sdk/RETypeDB.hpp>

class ChatManager
{
  public:
    static void initialize();
    static std::unique_ptr<::ChatManager> &get();

    void req_add_chat_infomation(std::wstring_view str) const;
    void req_add_chat_infomation(::SystemString *const txt) const;
    void process_skill_e(const uint8_t &id, const bool is_on) const;
    void process_skill_k(const uint32_t &id, const bool is_on) const;
    void send_damage_reduce_message() const;

  private:
    static inline std::unique_ptr<::ChatManager> s_instance{};

    void process_skill(::SystemString *const obj, const bool is_on) const;
    ::SystemString *get_message_by_name(::SystemString *const name) const;
};
