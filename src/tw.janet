(import ./tw/tailwind)

(var- tw/styles @{})
(var- tw/classes @{})
(var- *tailwind.min.css* "")
(var- normalize nil)
(var- shown 0)


(defmacro tailwind.min.css [filepath]
  (set *tailwind.min.css* filepath))


(defmacro class [str &opt url]
  (default url "")

  (++ shown)

  (when (one? shown)
    (print "Generating tailwind styles..."))

  (let [str (eval str)]

    (unless (get tw/classes url)
      (put tw/classes url @[]))

    # concat the class names into
    # the tw/classes dictionary
    # throw the global ones in there as well
    (update tw/classes url (comp distinct array/concat) (get tw/classes "" "") (string/split " " str))

    (with [f (file/open *tailwind.min.css*)]

      (let [css (file/read f :all)

            styles (tailwind/styles css (get tw/classes url ""))]

        (unless normalize
          (set normalize (tailwind/normalize css)))

        (put tw/styles url styles)))

    str))


(defn style [uri]
  (string normalize (get tw/styles uri "")))
