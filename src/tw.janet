(import ./tw/tailwind)

(var- tw/styles @{})
(var- tw/classes @{})
(var- normalize nil)
(var- *url* "")


(defn tailwind.min.css [filepath]
  (print "Generating tailwind styles...")

  (with [f (file/open filepath)]

    (let [css (file/read f :all)
          global-classes (get tw/classes "" [])]

      (set normalize (tailwind/normalize css))

      (eachp [k v] tw/classes
        (let [styles (tailwind/styles css [;v ;global-classes])]
          (put tw/styles k styles))))))


(defn class* [str url]
  (let [classes (get tw/classes url @[])]
    # add the new classes to the tw/classes
    # dictionary
    (array/concat classes (string/split " " str))
    (put tw/classes url classes)

    str))


(defmacro class [str &opt url]
  (default url *url*)
  (class* (eval str) url))


(defmacro tw [str &opt url]
  (default url *url*)
  (class* (eval str) url))


(defn style [uri]
  (string normalize (get tw/styles uri)))


(defn url [uri]
  (set *url* uri))
