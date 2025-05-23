local basic_options = {
  compatible = false,
  exrc = true, -- Enable .nvimrc
  backspace = "eol,start,indent",
  autoindent = true,
  cindent = true,
  wrap = false,
  ttimeout = true,
  ttimeoutlen = 50,
  timeoutlen = 500,
  ruler = true,
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  incsearch = true,
  encoding = "utf-8",
  fileencoding = "utf-8",
  fileencodings = "ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1",
  showmatch = true,
  matchtime = 2,
  display = "lastline",
  wildmenu = true,
  lazyredraw = true,
  listchars = "eol:¬,tab:>·,extends:>,precedes:<,space:␣",
  tags = "./.tags;,.tags",
  fileformats = "unix,dos,mac",
  formatoptions = "jcroqlmB",
  foldenable = true,
  foldmethod = "indent",
  foldlevel = 99,
  suffixes = ".bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class",
  wildignore = {
    "*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib",
    "*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex",
    "*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz",
    "*.gem",
    "*DS_Store*,*.ipch",
    "*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso",
    "*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**",
    "*/.nx/**,*.app,*.git,.git",
    "*.wav,*.mp3,*.ogg,*.pcm",
    "*.mht,*.suo,*.sdf,*.jnlp",
    "*.chm,*.epub,*.pdf,*.mobi,*.ttf",
    "*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc",
    "*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps",
    "*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu",
    "*.gba,*.sfc,*.078,*.nds,*.smd,*.smc",
    "*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android",
  },
}

local options = {
  updatetime = 300,
  mouse = "a",
  laststatus = 2,
  number = true,
  relativenumber = true,
  showtabline = 2,
  diffopt = "internal,filler,closeoff,vertical,algorithm:histogram,indent-heuristic,linematch:60",
  errorbells = false,
  spelllang = "en,cjk",
  undofile = true,
  backup = true,
  backupskip = "COMMIT_EDITMSG",
  completeopt = "fuzzy,menu,menuone,noselect",
  wrapscan = true,
  smartindent = true,
  breakindentopt = "shift:2,min:20",
  colorcolumn = "80",
  linebreak = true,
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  showmode = false,
  showcmd = true,
  autochdir = false,
  wildmenu = true,
  wildmode = "full",
  shortmess = "filnxtToOFc",
  signcolumn = "yes",
  termguicolors = true,
  sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
  backupdir = backup_dir,
  directory = swap_dir,
  undodir = undo_dir,
  mousemodel = "extend",
  tagrelative = false,
  spelloptions = "camel",
  spell = true,
  grepprg = "rg --vimgrep",
}

local function bind_option(opts)
  local o = vim.o
  for k, v in pairs(opts) do
    if type(v) ~= "table" then
      o[k] = v
    end
  end
end

bind_option(basic_options)
bind_option(options)

-- Make sure to use clipboard-osc52 in SSH session.
if os.getenv("SSH_TTY") then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
