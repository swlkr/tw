(defn- inspect [val]
  (printf "%m" val)
  val)

# helpers for responsive media queries
(def- sm? (partial string/has-prefix? `.sm\:`))
(def- md? (partial string/has-prefix? `.md\:`))
(def- lg? (partial string/has-prefix? `.lg\:`))
(def- xl? (partial string/has-prefix? `.xl\:`))
(def- dark? (partial string/has-prefix? `.dark\:`))


# container is a special, mythical beast
(def- container? (partial string/has-prefix? ".container"))


# make sure the final output puts
# the containers under the media queries
# and any responsive variants as well
(defn- media-queries [class-strings]
  (let [sm (filter sm? class-strings)
        md (filter md? class-strings)
        lg (filter lg? class-strings)
        xl (filter xl? class-strings)
        dark (filter dark? class-strings)
        has-container? (any? (filter container? class-strings))
        other (filter |(and (not (sm? $))
                            (not (md? $))
                            (not (lg? $))
                            (not (xl? $))
                            (not (dark? $))
                            (not (container? $)))
                      class-strings)
        container (if has-container?
                    @[(first (filter container? class-strings))]
                    @[])
        containers (filter container? class-strings)
        mq [(string "@media (min-width: 640px) {" (get containers 1 "") (string/join sm) "}")
            (string "@media (min-width: 768px) {" (get containers 2 "") (string/join md) "}")
            (string "@media (min-width: 1024px) {" (get containers 3 "") (string/join lg) "}")
            (string "@media (min-width: 1280px) {" (get containers 4 "") (string/join xl) "}")
            (string "@media (prefers-color-scheme: dark) {" (string/join dark) "}")]]
     (string/join (array/concat container other mq))))


(defn- css-class-peg [classes]
  (let [p ~{:main (any (choice (capture :class) (capture :star) 1))
            :class (sequence "." (choice ,;classes) (choice "," "{" ">" ":") (thru "}"))
            :star (sequence "*{" (thru "}"))}]
    (peg/compile p)))


(defn normalize [css]
  (string/slice css 0 (inc (string/find "}.container" css))))


(defn styles [css classes]
  (let [classes (->> classes
                     distinct
                     sorted
                     reverse
                     (map |(string/replace-all `/` `\/` $))
                     (map |(string/replace-all `:` `\:` $)))]

    (as-> (css-class-peg classes) ?
          (peg/match ? css)
          (media-queries ?))))
