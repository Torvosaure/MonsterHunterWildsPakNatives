#pragma once

#include "HookFunctions.hpp"

class HookManager
{
  public:
    HookManager();
    static void initialize();
    static std::unique_ptr<::HookManager> &get();

    void add_hook();

  private:
    static inline std::unique_ptr<::HookManager> s_instance{};
    std::unique_ptr<::HookFunctions> functions{};
};
