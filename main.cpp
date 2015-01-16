#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/qmlPong/main.qml"));
    viewer.showExpanded();
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setMinimumSize(QSize(500,500));

    return app.exec();
}
