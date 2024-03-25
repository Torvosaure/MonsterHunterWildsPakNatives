#pragma once

#include "HookFunctions.hpp"

class HookManager : public HookFunctions
{
  public:
    static void initialize();
    static std::unique_ptr<::HookManager> &get();

    void add_hook();

  private:
    static inline std::unique_ptr<::HookManager> s_instance{};
};
