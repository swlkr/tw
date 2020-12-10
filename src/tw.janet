(import ./tw/tailwind)

(var- tw/styles @{})
(var- *tailwind.min.css* "")
(var- shown 0)


(defmacro tailwind.min.css [filepath]
  (set *tailwind.min.css* filepath))


(defmacro class [str &opt url]
  (default url "")

  (++ shown)

  (when (one? shown)
    (print "Generating tailwind styles..."))

  (let [str (eval str)]

    (with [f (file/open *tailwind.min.css*)]

      (let [css (file/read f :all)

            classes (array/concat (string/split " " str)
                                  (get tw/styles url ""))
            styles (tailwind/styles css classes)]

        (update tw/styles url string styles)))

    str))



(defn style [uri]
  (string (get tw/styles "" "") " " (get tw/styles uri "")))
