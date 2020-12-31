(import ./tw/tailwind)

(var- tw/styles @{})
(var- tw/classes @{})
(var- normalize nil)
(var- *scope* "")


(defn tailwind.min.css [filepath]
  (print "Generating tailwind styles...")

  (with [f (file/open filepath)]

    (let [css (file/read f :all)
          global-styles (get tw/classes "" [])]

      (eachp [k v] tw/classes
        (let [styles (tailwind/styles css [;v ;global-styles])]

          (unless normalize
            (set normalize (tailwind/normalize css)))

          (put tw/styles k styles))))))


(defmacro class [str &opt url]
  (default url *scope*)

  (let [classes (get tw/classes url @[])]
    # add the new classes to the tw/classes
    # dictionary
    (array/concat classes (string/split " " str))
    (put tw/classes url classes)

    str))


(defn style [uri]
  (string normalize (get tw/styles uri)))


(defmacro scope [uri]
  (set *scope* uri))
