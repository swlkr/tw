(import ./tw/tailwind)
(import path)

(var- tw/styles @{})
(var- tw/classes @{})
(var- normalize nil)
(var- *url* "")
(var tw/href "")


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
    (as-> (peg/match '(some (choice (capture (some (if-not :s 1))) 1)) str) ?
          (array/concat classes ?))
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


(defn- tw? [filename]
  (and (string/has-prefix? "tw" filename)
       (string/has-suffix? "css" filename)))


(defn tailwind-min-css [file &opt folder]
  (default folder "public")
  (print "Reading minified tailwind css file...")

  (with [f (file/open file)]

    (var classes @[])
    (eachp [k v] tw/classes
      (array/concat classes v))

    (let [css (file/read f :all)
          normalize (tailwind/normalize css)
          styles (tailwind/styles css classes)
          checksum (->> styles hash (string/format "%x"))
          filename (string "/tw." checksum ".css")]

      (set tw/href filename)

      (print "Writing tw css file")

      (each f (os/dir folder)
        (when (tw? f)
          (os/rm (path/join folder f))))

      (spit (path/join folder filename) (string normalize styles)))))
