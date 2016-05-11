wl.bookshalf =
  path:
    switch process.platform
      when "darwin" and "win32"
        path.join(app.getPath("home"),"/Documents/Novels")
      else
        path.join(app.getPath("documents"),"/Novels")
