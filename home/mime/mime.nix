{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDF & ebooks
      "application/pdf" = ["org.kde.okular.desktop"];
      "application/epub+zip" = ["org.pwmt.zathura.desktop"];
      "application/x-fictionbook" = ["org.pwmt.zathura.desktop"];
      "application/x-mobipocket-ebook" = ["org.pwmt.zathura.desktop"];
      "application/oxps" = ["org.pwmt.zathura.desktop"];

      # Images
      "image/jpeg" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/png" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/gif" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/bmp" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/tiff" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/x-png" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/svg+xml" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/svg+xml-compressed" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/x-pcx" = ["com.github.weclaw1.ImageRoll.desktop"];
      "image/x-portable-anymap" = ["com.github.weclaw1.ImageRoll.desktop"];

      # Video
      "video/mp4" = ["mpv.desktop"];
      "video/x-matroska" = ["mpv.desktop"];
      "video/webm" = ["mpv.desktop"];
      "video/avi" = ["mpv.desktop"];
      "video/x-msvideo" = ["mpv.desktop"];
      "video/quicktime" = ["mpv.desktop"];
      "video/mpeg" = ["mpv.desktop"];
      "video/ogg" = ["mpv.desktop"];
      "video/mp2t" = ["mpv.desktop"];
      "video/3gpp" = ["mpv.desktop"];
      "video/x-flv" = ["mpv.desktop"];
      "video/divx" = ["mpv.desktop"];

      # Audio
      "audio/mpeg" = ["mpv.desktop"];
      "audio/flac" = ["mpv.desktop"];
      "audio/x-flac" = ["mpv.desktop"];
      "audio/ogg" = ["mpv.desktop"];
      "audio/wav" = ["mpv.desktop"];
      "audio/x-wav" = ["mpv.desktop"];
      "audio/aac" = ["mpv.desktop"];
      "audio/mp4" = ["mpv.desktop"];
      "audio/x-m4a" = ["mpv.desktop"];
      "audio/opus" = ["mpv.desktop"];
      "audio/webm" = ["mpv.desktop"];
      "audio/x-ms-wma" = ["mpv.desktop"];
      "application/ogg" = ["mpv.desktop"];

      # Web
      "text/html" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];

      # Email & calendar
      "message/rfc822" = ["thunderbird.desktop"];
      "x-scheme-handler/mailto" = ["thunderbird.desktop"];
      "text/calendar" = ["thunderbird.desktop"];
      "text/x-vcard" = ["thunderbird.desktop"];

      # Torrents
      "application/x-bittorrent" = ["org.qbittorrent.qBittorrent.desktop"];
      "x-scheme-handler/magnet" = ["org.qbittorrent.qBittorrent.desktop"];

      # ONLYOFFICE handles all office formats via a single desktop entry
      # Documents
      "application/vnd.oasis.opendocument.text" = ["onlyoffice-desktopeditors.desktop"];
      "application/msword" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.ms-word" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
      "application/rtf" = ["onlyoffice-desktopeditors.desktop"];
      "text/rtf" = ["onlyoffice-desktopeditors.desktop"];

      # Spreadsheets
      "application/vnd.oasis.opendocument.spreadsheet" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.ms-excel" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["onlyoffice-desktopeditors.desktop"];
      "text/csv" = ["onlyoffice-desktopeditors.desktop"];
      "text/comma-separated-values" = ["onlyoffice-desktopeditors.desktop"];

      # Presentations
      "application/vnd.oasis.opendocument.presentation" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.ms-powerpoint" = ["onlyoffice-desktopeditors.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];

      # Graphics/drawings
      "application/vnd.oasis.opendocument.graphics" = ["onlyoffice-desktopeditors.desktop"];

      # App scheme handlers
      "x-scheme-handler/discord" = ["discord.desktop"];
      "x-scheme-handler/stremio" = ["com.stremio.Stremio.desktop"];
      "x-scheme-handler/zotero" = ["zotero.desktop"];
      "x-scheme-handler/obsidian" = ["obsidian.desktop"];
    };
  };
}
