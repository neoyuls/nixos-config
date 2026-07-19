{...}: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDF & ebooks (swap to "org.kde.okular.desktop" once okular is added)
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

      # LibreOffice — Writer
      "application/vnd.oasis.opendocument.text" = ["writer.desktop"];
      "application/msword" = ["writer.desktop"];
      "application/vnd.ms-word" = ["writer.desktop"];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["writer.desktop"];
      "application/rtf" = ["writer.desktop"];
      "text/rtf" = ["writer.desktop"];

      # LibreOffice — Calc
      "application/vnd.oasis.opendocument.spreadsheet" = ["calc.desktop"];
      "application/vnd.ms-excel" = ["calc.desktop"];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["calc.desktop"];
      "text/csv" = ["calc.desktop"];
      "text/comma-separated-values" = ["calc.desktop"];

      # LibreOffice — Impress
      "application/vnd.oasis.opendocument.presentation" = ["impress.desktop"];
      "application/vnd.ms-powerpoint" = ["impress.desktop"];
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["impress.desktop"];

      # LibreOffice — Draw
      "application/vnd.oasis.opendocument.graphics" = ["draw.desktop"];

      # App scheme handlers
      "x-scheme-handler/discord" = ["vesktop.desktop"];
      "x-scheme-handler/stremio" = ["com.stremio.Stremio.desktop"];
      "x-scheme-handler/zotero" = ["zotero.desktop"];
      "x-scheme-handler/obsidian" = ["obsidian.desktop"];
    };
  };
}
