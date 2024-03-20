#pragma once

#include <type_traits>

namespace Utils
{
    template <typename T> constexpr std::underlying_type_t<T> enum_cast(T e) noexcept
    {
        return static_cast<std::underlying_type_t<T>>(e);
    }
}
