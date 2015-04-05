#include "util/luax.hpp"

class Extension
{
public:
    SINGLETON(Extension)
    Extension();
    ~Extension();
    bool initLuaState();
    inline std::string errorInfo() const { return error_information_; }
    inline bool isOk() const { return lua_state_ok_; }
    bool parse(const std::string& filename,
               std::string* pout_type,
               std::string* pout_api,
               std::string* pout_executor);
private:
    util::LuaState lua_state_;
    bool lua_state_ok_;
    std::string error_information_;
private:
    DISALLOW_COPY_AND_ASSIGN(Extension)
};
