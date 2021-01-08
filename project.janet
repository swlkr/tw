(declare-project
  :name "tw"
  :description "Generate just the tailwind.css styles you need"
  :dependencies ["https://github.com/janet-lang/path"]
  :author "Sean Walker"
  :license "MIT"
  :url "https://github.com/swlkr/tw"
  :repo "https://github.com/swlkr/tw.git")

(declare-source
  :source @["src/tw.janet" "src/tw"])

