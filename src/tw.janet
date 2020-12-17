(import ./tw/tailwind)

(var- tw/styles @{})
(var- tw/classes @{})
(var- normalize nil)
(var- shown 0)
(var- *scope* "")


(defn tailwind.min.css [filepath]
  (with [f (file/open filepath)]

    (let [css (file/read f :all)]

      (eachp [k v] tw/classes
        (let [styles (tailwind/styles css (or v ""))]

          (unless normalize
            (set normalize (tailwind/normalize css)))

          (put tw/styles k styles))))))


(defmacro class [str &opt url]
  (default url *scope*)

  (++ shown)

  (when (one? shown)
    (print "Generating tailwind styles..."))

  (let [str (eval str)]

    (unless (get tw/classes url)
      (put tw/classes url @[]))

    # concat the class names into
    # the tw/classes dictionary
    # throw the global ones in there as well
    (update tw/classes url (comp distinct array/concat) (get tw/classes "" @[]) (string/split " " str))

    str))


(defn style [uri]
  (string normalize (get tw/styles uri "")))


(defmacro scope [uri]
  (set *scope* uri))
