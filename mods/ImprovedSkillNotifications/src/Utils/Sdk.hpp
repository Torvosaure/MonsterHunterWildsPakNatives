#pragma once

#include <sdk/RETypeDB.hpp>

namespace sdk
{
    template <typename T, bool U = false, bool W = false> class REFieldEx : public REField
    {
      public:
        T &get_data(void *object) const { return REField::get_data<T>(object, W); }
    };

    template <typename T, bool W> class REFieldEx<T, true, W> : public REField
    {
      public:
        T &get_data() const { return REField::get_data<T>(nullptr, W); }
    };

    template <typename T, typename... Args> class REMethodDefinitionEx : public REMethodDefinition
    {
      public:
        T call(Args... args) const { return REMethodDefinition::call<T, Args...>(args...); }
    };

    template <typename T> class ReflectionPropertyEx : public VariableDescriptor
    {
      public:
        T get_data(::REManagedObject *obj) const
        {
            return utility::re_managed_object::get_field<T>(obj, static_cast<VariableDescriptor *>(const_cast<ReflectionPropertyEx *>(this)));
        }
    };
}
