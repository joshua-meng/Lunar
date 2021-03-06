#ifndef FILEEXPLORERWIDGET_H
#define FILEEXPLORERWIDGET_H

#include <string>
#include <QList>
#include <QTreeWidget>
#include "lunarcommon.h"

class QMenu;
class QTreeWidgetItem;
class QContextMenuEvent;

namespace gui
{

class FileExplorerWidget : public QTreeWidget
{
    Q_OBJECT
public:
    explicit FileExplorerWidget(QWidget *parent = 0);
    virtual ~FileExplorerWidget();
    QString getCurrentSelectedDir();
signals:
    void openFile(const QString&);
    void executeExtensionTool(const QString& tool_script, const QString& execute_path, const QString& additional_args);
    void renameFile(const QString&, const QString&);
    void renameDir(const QString&, const QString&);
    void removeFile(const QString&);
    void removeDir(const QString&);
    void widthChanged(int width);
    void setProjectPath(const QString&);
public slots:
    void loadRoot();
    void onFileSaved(const QString& file);
    void onAllFilesSaved();
    void showContextMenu();
    void locateFile(const QString& file);
protected:
    virtual void keyPressEvent(QKeyEvent *event);
    virtual void contextMenuEvent(QContextMenuEvent *e);
private:
    void init();
    void initConnections();
    //load both folders and files
    bool loadNode(QTreeWidgetItem* item);
    //load only files
    bool loadNodeFiles(QTreeWidgetItem* item);
    QString getNodeAbsolutePath(QTreeWidgetItem* item);
    QString getNodeRelativePath(QTreeWidgetItem* item);
    void onClickExtensionTool(const std::string& str);
    void showContextMenu(const QPoint &pos);
    void showTools(QMenu* pmenu, const std::string& dst_dir);
private Q_SLOTS:
    void newFolder();
    void setAsProjectPath();
    void newFolderOk(const QString& folder_name);
    void deleteCurrentItem();
    void renameCurrentItem();
    void renameCurrentItemOk(const QString& new_name);
    void onItemDoubleClicked(QTreeWidgetItem *item, int column);
    void onItemReturn(QTreeWidgetItem *item, int column);
    void onDeleteItems(QTreeWidgetItem* item, int column);
    QTreeWidgetItem* findDirNodeItemWithFile(const QString& file);
private:
    DISALLOW_COPY_AND_ASSIGN(FileExplorerWidget)
};

}


#endif // FILEEXPLORERWIDGET_H
