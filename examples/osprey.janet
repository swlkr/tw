(use osprey)
(import ../src/tw :as tw)


(tw/tailwind.min.css "./tailwind.css")


(after "*"
  (ok text/html

    (html/encode

      (doctype :html5)
      [:html {:lang "en"}

        [:head
         [:title (request :uri)]
         [:style (html/unsafe (tw/style (request :uri)))]]

        [:body {:class (tw/class "container mx-auto")} response]])))


(GET "/"
  [[:h1 {:class (tw/class "text-5xl text-black" "/")}
    "/"]

   [:a {:href "/a"
        :class (tw/class "text-blue-500 hover:underline" "/")}
    "go to /a"]])


(GET "/a"
  [[:h1 {:class (tw/class "text-5xl text-black" "/a")}
    "/a"]

   [:a {:href "/"
        :class (tw/class "text-purple-500 hover:underline" "/a")}
    "go to /"]])


(server 9001)
