# tw

tw is a [tailwind.css](https://tailwindcss.com) dead code elimination tool that runs at build time

```clojure
; # osprey is used for demo purposes only
; # this works with any janet web framework
(use osprey)
(import tw)


<<<<<<< HEAD
=======
; # point tw to your *minified* tailwind.min.css file
(tw/tailwind.min.css "./tailwind.min.css")


>>>>>>> a1fc939a76e5541ff476e74c1327c3be7d786c49
(GET "/"
  [:html
    [:head
      ; # set tw/style to the current request's url
      [:style (tw/style "/")]]

      ; # add any tailwind class you need to tw/class
      ; # and use the optional second argument to scope by url
      ; # without that second argument, the classes will carry
      ; # across all pages

      ; # that's it! you now have *just* the classes you
      ; # need in the style tag for each page
      ; # could also use (tw/scope "/") before
      ; # a group of (tw/class) statements
    [:body {:class (tw/class "container mx-auto" "/")}
      "hello world!"]])


; # point tw to your *minified* tailwind.min.css file
; # reads the minified tailwind css file and puts the class bodies
; # from tw/class in memory
(tw/tailwind.min.css "./tailwind.min.css")

(server 9001)
```

# Installation

Make sure janet is installed first (macOS)

```sh
brew install janet
```

Then install tw using `jpm`

```sh
jpm install https://github.com/swlkr/tw
```
