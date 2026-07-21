{config, ...}: let
  c = config.lib.stylix.colors;
in {
  # Night Mapping dark theme as base; lain-rose stylesheet overrides palette colors.
  # QGIS loads customStyleSheet from [UI] on startup.
  xdg.dataFile."QGIS/QGIS3/profiles/default/QGIS/QGIS3.ini".text = ''
    [UI]
    UITheme=Night Mapping
    customStyleSheet=${config.home.homeDirectory}/.config/QGIS/lain-rose.qss
  '';

  # Custom QSS layered on top of Night Mapping to apply lain-rose palette
  xdg.configFile."QGIS/lain-rose.qss".text = ''
    QWidget {
      background-color: #${c.base00};
      color: #${c.base06};
    }
    QMainWindow, QDialog {
      background-color: #${c.base00};
    }
    QMenuBar {
      background-color: #${c.base01};
      color: #${c.base06};
      border-bottom: 1px solid #${c.base03};
    }
    QMenuBar::item:selected {
      background-color: #${c.base02};
      color: #${c.base07};
    }
    QMenu {
      background-color: #${c.base01};
      color: #${c.base06};
      border: 1px solid #${c.base03};
    }
    QMenu::item:selected {
      background-color: #${c.base0E};
      color: #${c.base00};
    }
    QToolBar {
      background-color: #${c.base01};
      border: none;
      spacing: 2px;
    }
    QToolButton {
      background-color: transparent;
      color: #${c.base06};
      border: 1px solid transparent;
      border-radius: 3px;
      padding: 2px;
    }
    QToolButton:hover {
      background-color: #${c.base02};
      border-color: #${c.base0E};
    }
    QToolButton:pressed, QToolButton:checked {
      background-color: #${c.base0E};
      color: #${c.base00};
    }
    QDockWidget {
      background-color: #${c.base00};
      color: #${c.base06};
    }
    QDockWidget::title {
      background-color: #${c.base01};
      color: #${c.base06};
      padding: 4px;
    }
    QTreeView, QListView, QTableView {
      background-color: #${c.base00};
      color: #${c.base06};
      alternate-background-color: #${c.base01};
      border: 1px solid #${c.base03};
      selection-background-color: #${c.base0E};
      selection-color: #${c.base00};
    }
    QTreeView::item:hover, QListView::item:hover {
      background-color: #${c.base02};
    }
    QHeaderView::section {
      background-color: #${c.base01};
      color: #${c.base05};
      border: 1px solid #${c.base03};
      padding: 3px;
    }
    QLineEdit, QTextEdit, QPlainTextEdit, QSpinBox, QDoubleSpinBox, QComboBox {
      background-color: #${c.base01};
      color: #${c.base06};
      border: 1px solid #${c.base03};
      border-radius: 3px;
      padding: 2px 4px;
      selection-background-color: #${c.base0E};
      selection-color: #${c.base00};
    }
    QLineEdit:focus, QTextEdit:focus, QPlainTextEdit:focus, QSpinBox:focus,
    QDoubleSpinBox:focus, QComboBox:focus {
      border-color: #${c.base0E};
    }
    QComboBox::drop-down {
      background-color: #${c.base02};
      border-left: 1px solid #${c.base03};
    }
    QComboBox QAbstractItemView {
      background-color: #${c.base01};
      color: #${c.base06};
      selection-background-color: #${c.base0E};
      selection-color: #${c.base00};
    }
    QPushButton {
      background-color: #${c.base02};
      color: #${c.base06};
      border: 1px solid #${c.base03};
      border-radius: 3px;
      padding: 4px 10px;
    }
    QPushButton:hover {
      background-color: #${c.base03};
      border-color: #${c.base0E};
      color: #${c.base07};
    }
    QPushButton:pressed, QPushButton:checked {
      background-color: #${c.base0E};
      color: #${c.base00};
      border-color: #${c.base0E};
    }
    QTabWidget::pane {
      border: 1px solid #${c.base03};
      background-color: #${c.base00};
    }
    QTabBar::tab {
      background-color: #${c.base01};
      color: #${c.base04};
      border: 1px solid #${c.base03};
      border-bottom: none;
      padding: 4px 10px;
    }
    QTabBar::tab:selected {
      background-color: #${c.base0E};
      color: #${c.base00};
      border-color: #${c.base0E};
    }
    QTabBar::tab:hover:!selected {
      background-color: #${c.base02};
      color: #${c.base06};
    }
    QScrollBar:vertical {
      background-color: #${c.base01};
      width: 10px;
    }
    QScrollBar::handle:vertical {
      background-color: #${c.base03};
      border-radius: 5px;
      min-height: 20px;
    }
    QScrollBar::handle:vertical:hover {
      background-color: #${c.base0E};
    }
    QScrollBar:horizontal {
      background-color: #${c.base01};
      height: 10px;
    }
    QScrollBar::handle:horizontal {
      background-color: #${c.base03};
      border-radius: 5px;
      min-width: 20px;
    }
    QScrollBar::handle:horizontal:hover {
      background-color: #${c.base0E};
    }
    QScrollBar::add-line, QScrollBar::sub-line { height: 0; width: 0; }
    QStatusBar {
      background-color: #${c.base01};
      color: #${c.base05};
      border-top: 1px solid #${c.base03};
    }
    QToolTip {
      background-color: #${c.base01};
      color: #${c.base06};
      border: 1px solid #${c.base0E};
    }
    QGroupBox {
      color: #${c.base05};
      border: 1px solid #${c.base03};
      border-radius: 4px;
      margin-top: 8px;
      padding-top: 4px;
    }
    QGroupBox::title {
      subcontrol-origin: margin;
      subcontrol-position: top left;
      padding: 0 4px;
      color: #${c.base0E};
    }
    QCheckBox, QRadioButton {
      color: #${c.base06};
    }
    QCheckBox::indicator, QRadioButton::indicator {
      width: 14px;
      height: 14px;
      background-color: #${c.base01};
      border: 1px solid #${c.base03};
      border-radius: 2px;
    }
    QCheckBox::indicator:checked, QRadioButton::indicator:checked {
      background-color: #${c.base0E};
      border-color: #${c.base0E};
    }
    QSplitter::handle {
      background-color: #${c.base03};
    }
    QProgressBar {
      background-color: #${c.base01};
      border: 1px solid #${c.base03};
      border-radius: 3px;
      text-align: center;
      color: #${c.base06};
    }
    QProgressBar::chunk {
      background-color: #${c.base0E};
      border-radius: 3px;
    }
  '';
}
