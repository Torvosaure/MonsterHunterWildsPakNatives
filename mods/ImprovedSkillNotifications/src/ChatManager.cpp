#include "ChatManager.hpp"

#include "Namespaces.hpp"

using namespace Namespaces;

void ChatManager::initialize()
{
    s_instance = std::make_unique<::ChatManager>();
}

std::unique_ptr<::ChatManager> &ChatManager::get()
{
    assert(s_instance != nullptr);

    return s_instance;
}

void ChatManager::req_add_chat_infomation(std::wstring_view str) const
{
    auto *const txt = sdk::VM::create_managed_string(str);

    req_add_chat_infomation(txt);
}

void ChatManager::req_add_chat_infomation(::SystemString *const txt) const
{
    auto *const vmctx = sdk::get_thread_context();
    static auto *const gui_chat_manager = sdk::get_managed_singleton<::REManagedObject>("snow.gui.ChatManager");

    const auto wise_trigger = mhrise::snow::gui::COMMON::GUI_COMMON_NOTICE_SIDE_OPEN->get_data();

    mhrise::snow::gui::ChatManager::reqAddChatInfomation244588->call(vmctx, gui_chat_manager, txt, wise_trigger);
}

void ChatManager::process_skill_e(const uint8_t &id, const bool is_on) const
{
    auto *const vmctx = sdk::get_thread_context();
    auto *const skill_name = mhrise::snow::data::DataShortcut::getName249386->call(vmctx, id);

    process_skill(skill_name, is_on);
}

void ChatManager::process_skill_k(const uint32_t &id, const bool is_on) const
{
    auto *const vmctx = sdk::get_thread_context();
    auto *const skill_name = mhrise::snow::data::DataShortcut::getName249402->call(vmctx, id);

    process_skill(skill_name, is_on);
}

void ChatManager::send_damage_reduce_message() const
{
    auto *const name = sdk::VM::create_managed_string(L"ChatLog_Co_Skill_01");
    auto *const txt = get_message_by_name(name);

    req_add_chat_infomation(txt);
}

void ChatManager::process_skill(::SystemString *const obj, const bool is_on) const
{
    auto *const vmctx = sdk::get_thread_context();

    auto *const name = sdk::VM::create_managed_string(is_on ? L"ChatLog_Pl_Skill_01" : L"ChatLog_Pl_Skill_02");
    auto *const format = get_message_by_name(name);

    auto *const txt = mhrise::System::String::Format722162->call(vmctx, format, obj);

    req_add_chat_infomation(txt);
}

::SystemString *ChatManager::get_message_by_name(::SystemString *const name) const
{
    auto *const vmctx = sdk::get_thread_context();

    std::array<uint64_t, 2> guid{};
    mhrise::via::gui::message::getGuidByName778372->call(&guid, vmctx, name);

    auto *const message = mhrise::via::gui::message::get778345->call(vmctx, &guid);

    return message;
}
