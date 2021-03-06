#ifndef LUNAR_H
#define LUNAR_H

#include <string>
#include <vector>
#include <list>
#include <QtCore/QString>
#include <QtGui/QFont>
#include "util/lexicalcast.hpp"
#include "util/iterator.hpp"
#include "util/net.hpp"

struct lua_State;

const std::string kParseSupplementApi = "parseSupplementApi";
const std::string kGotoDefinition = "gotoDefinition";

QString StdStringToQString(const std::string &s);
std::string QStringToStdString(const QString &s);

QString QStringTrimRight(const QString& str);

std::string getExtensionAbsolutePath(const std::string& pathname);

template<typename T>
T getValueFromMap(const std::map<std::string, std::string>& from_map, const std::string& key, T default_value)
{
    std::map<std::string, std::string>::const_iterator it = from_map.find(key);
    if (it == from_map.end())
        return default_value;
    else
        return util::lexicalCastDefault<T>(it->second, default_value);
}

QString qtReadFile(const QString& filename, const char* codec = "UTF-8");
bool qtWriteFile(const QString& filename, const QString& content, bool append = false, const char* codec = "UTF-8");

void initLunarCommon(int argc, char* argv[]);
void LunarMsgBox(const std::string& str);
void LunarMsgBoxQ(const QString& str);
int scriptMessage(lua_State* plua_state);
int sendLog(lua_State* plua_state);
QString qstrReplaceOnce(const QString& str_src, const QString& str_find, const QString& str_replace);

void getRecentProjectPath(std::list<std::string>& out);
void addNewRecentProjectPath(const std::string& path);
void saveRecentProjectPath(const std::list<std::string>& paths);

class LogSocket
{
public:
    SINGLETON(LogSocket)
    void sendLog(const std::string& log, const std::string& ip, unsigned short port);
private:
    LogSocket();
private:
    util::DgramSocket log_sock_;
private:
    DISALLOW_COPY_AND_ASSIGN(LogSocket)
};

class LunarGlobal
{
public:
    SINGLETON(LunarGlobal)
    void init(int argc, char* argv[]);
    void quit();
    void readCfg(bool read_all = true);
    void writeCfg();
    inline std::string getAppPath() const { return app_path_; }
    inline std::string getAppName() const { return app_name_; }
    inline int getArgCnt() const { return argc_; }
    inline std::string getArg(size_t index) { return argvec_.at(index); }
    inline int getAutocompletionThreshold() const { return autocompletion_threshold_; }
    inline int getAutocompletionWordtip() const { return autocompletion_wordtip_; }
    inline QFont getFont() const { return font_; }
    inline void setFont(const QFont& font) { font_ = font; }
    inline unsigned short getProcessSockPort() const { return process_sock_port_; }
    inline void setProcessSockPort(unsigned short port) { process_sock_port_ = port; }
    inline size_t getMainwindowWidth() const { return mainwindow_width_; }
    inline size_t getMainwindowHeight() const { return mainwindow_height_; }
    inline void setMainwindowWidth(size_t width) { mainwindow_width_ = width; }
    inline void setMainwindowHeight(size_t height) { mainwindow_height_ = height; }
    inline void setRecentProjectPath(const std::string& path_list) { recent_project_path_ = path_list; }
    inline void setRecentProjectPathCnt(size_t cnt) { recent_project_path_cnt_ = cnt; }
    inline void setLastFindFileText(const std::string& last_find_file_text) { last_find_file_text_ = last_find_file_text; }

    inline std::string getExtensionFile() const { return "extension.lua"; }
    inline std::string getExtensionFuncParseFileType() const { return extension_func_parsefiletype_; }
    inline std::string getExtensionFuncFilefilter() const { return extension_func_filefilter_; }
    inline std::string getExtensionFuncIsLegalFile() const { return extension_func_is_legal_file_; }
    inline std::string getExtensionFuncFindFiles() const { return extension_func_find_files_; }
    inline std::string getExtensionTemplateFileInfo() const { return extension_func_template_file_info_; }
    inline std::string getFileFilter() const { return file_filter_; }
    inline std::string getToolsPath() const { return tools_path_; }
    inline std::string getLastFindFileText() const { return last_find_file_text_; }
    inline unsigned short getLogSockPort() const { return log_sock_port_; }
    inline bool isLogEnable() const { return is_log_enable_; }
    inline std::string getRecentProjectPath() const { return recent_project_path_; }
    inline size_t getRecentProjectPathCnt() const { return recent_project_path_cnt_; }
    inline util::Iterator<std::string> recentDocsIterator() { return util::createIterator<std::string>(recent_docs_); }
    void addRecentDoc(const std::string& doc);
    void trimRecentDocs();
    void removeRecentDoc(const std::string& doc);
    void parseExtensionFileFilter();
    inline util::Iterator<std::string> recentRunDocsIterator() { return util::createIterator<std::string>(recent_run_docs_); }
    void addRecentRunDoc(const std::string& doc);
    void trimRecentRunDoc();
    void removeRecentRunDoc(const std::string& doc);
private:
    LunarGlobal();
    ~LunarGlobal();
private:
    int argc_;
    std::vector<std::string> argvec_;
    std::string app_path_;
    std::string app_name_;
    int autocompletion_threshold_;
    int autocompletion_wordtip_;
    QFont font_;
    unsigned short process_sock_port_;
    size_t mainwindow_width_;
    size_t mainwindow_height_;
    std::string extension_func_parsefiletype_;
    std::string extension_func_filefilter_;
    std::string extension_func_is_legal_file_;
    std::string extension_func_find_files_;
    std::string extension_func_template_file_info_;
    std::string file_filter_;
    std::string tools_path_;
    unsigned short log_sock_port_;
    bool is_log_enable_;
    size_t  recent_project_path_cnt_;
    std::string recent_project_path_;
    std::list<std::string> recent_docs_;
    std::list<std::string> recent_run_docs_;
    std::string last_find_file_text_;
private:
    DISALLOW_COPY_AND_ASSIGN(LunarGlobal)
};


#endif // LUNARCOMMON_H
