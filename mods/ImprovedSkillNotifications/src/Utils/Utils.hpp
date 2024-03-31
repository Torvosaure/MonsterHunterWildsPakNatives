#pragma once

#include <atomic>
#include <cassert>
#include <concepts>
#include <type_traits>

namespace Utils
{
    template <typename T> constexpr std::underlying_type_t<T> enum_cast(T e) noexcept
    {
        return static_cast<std::underlying_type_t<T>>(e);
    }

    template <typename T, std::unsigned_integral U = uint64_t> class AtomicBitset
    {
      public:
        AtomicBitset(U b) : m_bitset{b} {}

        void set(const T pos, const bool val = true) noexcept
        {
            assert(sizeof(U) * CHAR_BIT >= enum_cast(pos));
            if (val)
            {
                m_bitset |= U{1} << enum_cast(pos);
            }
            else
            {
                m_bitset &= ~(U{1} << enum_cast(pos));
            }
        }

        void reset() noexcept { m_bitset.store(0); }

        void reset(const T pos) noexcept
        {
            assert(sizeof(U) * CHAR_BIT >= enum_cast(pos));
            set(pos, false);
        }

        void flip(const T pos) noexcept
        {
            assert(sizeof(U) * CHAR_BIT >= enum_cast(pos));
            m_bitset ^= U{1} << enum_cast(pos);
        }

        bool test(const T pos) const noexcept
        {
            assert(sizeof(U) * CHAR_BIT >= enum_cast(pos));
            return (m_bitset.load() & (U{1} << enum_cast(pos))) != 0;
        }

      private:
        std::atomic<U> m_bitset;
    };
}
