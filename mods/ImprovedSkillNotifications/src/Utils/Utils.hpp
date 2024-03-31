#pragma once

#include <atomic>
#include <type_traits>

namespace Utils
{
    template <typename T> constexpr std::underlying_type_t<T> enum_cast(T e) noexcept
    {
        return static_cast<std::underlying_type_t<T>>(e);
    }

    template <typename T> class AtomicBitset
    {
      public:
        AtomicBitset(std::underlying_type_t<T> b) : m_bitset{b} {}

        void set(const T pos, const bool val = true) noexcept
        {
            if (val)
            {
                m_bitset |= std::underlying_type_t<T>{1} << enum_cast(pos);
            }
            else
            {
                m_bitset &= ~(std::underlying_type_t<T>{1} << enum_cast(pos));
            }
        }

        void reset() noexcept { m_bitset.store(0); }

        void reset(const T pos) noexcept { set(pos, false); }

        void flip(const T pos) noexcept { m_bitset ^= std::underlying_type_t<T>{1} << enum_cast(pos); }

        bool test(const T pos) const noexcept { return (m_bitset.load() & (std::underlying_type_t<T>{1} << enum_cast(pos))) != 0; }

      private:
        std::atomic<std::underlying_type_t<T>> m_bitset;
    };
}
